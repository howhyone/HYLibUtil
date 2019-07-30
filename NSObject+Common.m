//
//  NSObject+Common.m
//  HYOCoding
//
//  Created by mob on 2019/7/3.
//  Copyright © 2019 mob. All rights reserved.
//

#import "NSObject+Common.h"
#import <objc/runtime.h>

#define kBaseURLStr @"https://coding.net/"
#define OMDateFormat @"yyyy-MM-dd'T'HH:mm:ss.SSS"
#define OMTimeZone @"UTC"
#define EADateFormat @"yyyy-MM-dd HH:mm:ss"

@implementation NSObject (Common)

-(NSString *)getBaseUrl
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"kBaseURLStr"] ?:kBaseURLStr;
    
}

-(NSString *)typeFromProperty:(objc_property_t)property
{
    return [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","][0];
}

-(NSString *)nameOfClass
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}
static const char *getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)  {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) -1] bytes];
        }else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2){
            return "id";
        }else if (attribute[0] == 'T' && attribute[1] == '@'){
            return (const char*)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}
-(NSString *)classOfPropertyName:(NSString *)propName
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int xx = 0; xx < count; xx++) {
        NSString *curProperty = [NSString stringWithUTF8String:property_getName(properties[xx])];
        if ([curProperty isEqualToString:propName]) {
            NSString *className = [NSString stringWithFormat:@"%s",getPropertyType(properties[xx])];
            free(properties);
            return className;
        }
    }
    return nil;
}

+(NSDate *)p_dateFromObj:(id)obj
{
    NSDate *date;
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *timeSince1970 = (NSNumber *)obj;
        NSTimeInterval timeSince1970TimeInterval = timeSince1970.doubleValue/1000;
        date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
        
    }else if ([obj isKindOfClass:[NSString class]]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:OMDateFormat];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
        date = [formatter dateFromString:(NSString *)obj];
        if (!date) {
            [formatter setDateFormat:EADateFormat];
            date = [formatter dateFromString:(NSString *)obj];
        }
    }
    return date;
}

+(NSMutableArray *)arrayMapFromArray:(NSArray *)nestedArray forPropertyName:(NSString *)propertyName
{
    NSMutableArray *objectsArray = [@[] mutableCopy];
    for (int xx = 0; xx < nestedArray.count; xx++) {
        if ([nestedArray[xx] isKindOfClass:[NSDictionary class]]) {
            id nestedObj = [[NSClassFromString(propertyName) alloc] init];
            
            for (NSString *newKey in [nestedArray[xx] allKeys]) {
                if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSArray class]]) {
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [@"propertyArrayMap" UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *propertyType = [nestedObj valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@",newKey]];
                    if (!propertyType) {
                        continue;
                    }
                    [nestedObj setValue:[NSObject arrayMapFromArray:[nestedArray[xx] objectForKey:newKey] forPropertyName:propertyType] forKey:newKey];
                }else if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSDictionary class]]){
                    NSString *type = [nestedObj classOfPropertyName:newKey];
                    if (!type) {
                        continue;
                    }
                    id nestedDictObj = [NSObject objectOfClass:type fromJson:[nestedArray[xx] objectForKey:newKey]];
                    [nestedObj setValue:nestedDictObj forKey:newKey];
                    
                }else{
                    NSString *tempNewKey;
                    if ([newKey isEqualToString:@"description"] || [newKey isEqualToString:@"hash"]) {
                        tempNewKey = [newKey stringByAppendingString:@"_mine"];
                    }else{
                        tempNewKey = newKey;
                    }
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [tempNewKey UTF8String]);
                    if (!property) {
                        continue;
                    }
                    NSString *classType = [self typeFromProperty:property];
                    if ([classType isEqualToString:@"T@\"NSData\""]) {
                        [nestedObj setValue:[self p_dateFromObj:[nestedArray[xx] objectForKey:newKey]] forKey:tempNewKey];
                    }else{
                        [nestedObj setValue:[nestedArray[xx] objectForKey:newKey] forKey:tempNewKey];
                    }
                }
            }
            [objectsArray addObject:nestedObj];
        }else if ([nestedArray[xx] isKindOfClass:[NSArray class]]){
            [objectsArray addObject:[NSObject arrayMapFromArray:nestedArray[xx] forPropertyName:propertyName]];
        }else{
            [objectsArray addObject:nestedArray[xx]];
        }
    }
    return objectsArray;
}

+(id)objectOfClass:(NSString *)object fromJson:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id newObject = [[NSClassFromString(object) alloc] init];
    NSDictionary *mapDictionary = [newObject propertyDictionary];
    for (NSString *key in [dict allKeys]) {
        NSString *tempKey;
        if ([key isEqualToString:@"description"] || [key isEqualToString:@"hash"]) {
            tempKey = [key stringByAppendingString:@"_mine"];
        }else{
            tempKey = key;
        }
        NSString *propertyName = [mapDictionary objectForKey:tempKey];
        if (!propertyName) {
            continue;
        }
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSString *propertyType = [newObject classOfPropertyName:propertyName];
            id nestedObj = [NSObject objectOfClass:propertyType fromJson:[dict objectForKey:key]];
            [newObject setValue:nestedObj forKey:propertyName];
        }else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]){
            NSArray *nestedArray = [dict objectForKey:key];
            NSString *propertyType = [newObject valueForKeyPath:[NSString stringWithFormat:@"properArrayMap.%@",key]];
            [newObject setValue:[NSObject arrayMapFromArray:nestedArray forPropertyName:propertyType] forKey:propertyName];
        }else{
            objc_property_t property = class_getProperty([newObject class], [propertyName UTF8String]);
            if (!property) {
                continue;
            }
            NSString *classType = [newObject typeFromProperty:property];
            if ([classType isEqualToString:@"T@\"NSDate\""]) {
                [newObject setValue:[self p_dateFromObj:[dict objectForKey:key]] forKey:propertyName];
            }else{
                if ([dict objectForKey:key] != [NSNull null]) {
                    [newObject setValue:[dict objectForKey:key] forKey:propertyName];
                }else{
                    [newObject setValue:nil forKey:propertyName];
                }
            }
        }
    }
    return newObject;
}

-(NSDictionary *)propertyDictionary
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    unsigned count;
    objc_property_t *propereties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propereties[i])];
        [mDict setObject:key forKey:key];
    }
    free(propereties);
    NSString *superClassName = [[self superclass] nameOfClass];
    if (![superClassName isEqualToString:@"NSObject"]) {
        for (NSString *property in [[[self superclass] propertyDictionary] allKeys]) {
            [mDict setObject:property forKey:property];
        }
    }
    return mDict;
}

@end
