//
//  UILabel+Common.h
//  HYOCoding
//
//  Created by mob on 2019/3/15.
//  Copyright © 2019年 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Common)

+(instancetype)labelWithFont:(UIFont *)fontSize textColor:(UIColor*)textColor;

+(instancetype)labelWithSystemFontSize:(CGFloat)fontSize TextColroHexString:(UInt32 )colorStr;


@end

NS_ASSUME_NONNULL_END
