//
//  UIButton+Common.h
//  HYOCoding
//
//  Created by mob on 2019/7/2.
//  Copyright © 2019 mob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Common)

-(UIImage *)buttonImageFromColor:(UIColor *)color;

+(UIButton *)setButtonTitle:(NSString *)titleText FontSize:(CGFloat)fontSize ColorName:(UInt32)colorName ImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
