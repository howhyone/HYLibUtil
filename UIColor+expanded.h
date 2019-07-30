//
//  UIColor+expanded.h
//  HYOCoding
//
//  Created by mob on 2019/3/15.
//  Copyright © 2019年 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (expanded)

@property(nonatomic, readonly) CGFloat red;
@property(nonatomic, readonly) CGFloat green;
@property(nonatomic, readonly) CGFloat blue;
@property(nonatomic, readonly) CGFloat white;
@property(nonatomic, readonly) CGFloat alpha;
//@property(nonatomic, readonly) UInt32 rbgHex;
@property(nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property(nonatomic, readonly) BOOL canProvideoRGBComponents;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
