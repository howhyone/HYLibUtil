//
//  NSString+Common.h
//  HYOCoding
//
//  Created by mob on 2019/4/14.
//  Copyright © 2019年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)

-(BOOL)isPhoneNum;

- (NSString*) sha1Str;
@end

NS_ASSUME_NONNULL_END
