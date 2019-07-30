//
//  NSObject+Common.h
//  HYOCoding
//
//  Created by mob on 2019/7/3.
//  Copyright © 2019 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Common)

-(NSString *)getBaseUrl;

+(id)objectOfClass:(NSString *)object fromJson:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
