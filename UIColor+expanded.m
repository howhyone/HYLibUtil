//
//  UIColor+expanded.m
//  HYOCoding
//
//  Created by mob on 2019/3/15.
//  Copyright © 2019年 mob. All rights reserved.
//

#import "UIColor+expanded.h"

@implementation UIColor (expanded)

-(BOOL)canProvideoRGBComponents
{
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}
-(CGFloat)red
{
    NSAssert(self.canProvideoRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}
-(CGFloat)green
{
    NSAssert(self.canProvideoRGBComponents, @"Must be an RGB color to use- green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) {
        return c[0];
    }
    return c[1];
}
-(CGFloat)blue
{
    NSAssert(self.canProvideoRGBComponents,@"Must be an RGB color to use -bleu");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelUnknown) {
        return c[0];
    }
    return c[2];
}
-(CGFloat)white
{
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}
-(CGFloat)alpha
{
    return CGColorGetAlpha(self.CGColor);
}

+(UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+(UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) {
        return  nil;
    }
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithHexString:stringToConvert];
    return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:alpha];
}

@end
