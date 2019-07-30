//
//  UIButton+Common.m
//  HYOCoding
//
//  Created by mob on 2019/7/2.
//  Copyright © 2019 mob. All rights reserved.
//

#import "UIButton+Common.h"
#import "UIColor+expanded.h"

@implementation UIButton (Common)

- (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(UIButton *)setButtonTitle:(NSString *)titleText FontSize:(CGFloat)fontSize ColorName:(UInt32)colorName ImageName:(NSString *)imageName
{
    CGFloat intervalF = 10.0;
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempButton setTitle:titleText forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor colorWithRGBHex:colorName] forState:UIControlStateNormal];
    [tempButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    CGFloat titleRight = tempButton.imageView.frame.size.width + intervalF;
    CGFloat imageLeft = 0.0;
//    使用frame获取titleLabel的width、height为nil，要使用intrinsicContentSize变量
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
         imageLeft = tempButton.titleLabel.intrinsicContentSize.width;
    }else{
         imageLeft = tempButton.titleLabel.frame.size.width + intervalF;
    }
    [tempButton setImageEdgeInsets:UIEdgeInsetsMake(0, imageLeft, 0, -imageLeft)];
    [tempButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleRight, 0, titleRight)];

    return tempButton;
}


@end
