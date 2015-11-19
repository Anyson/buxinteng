//
//  Common.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/15.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject

+ (UIBarButtonItem *)initBackwardButton:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)initButtonImageName:(NSString *)imageName target:(id)target action:(SEL)action;

//生成 views
+ (UIView *)generateSeperateLineWithFrame:(CGRect)frame;

+ (UIView *)generateViewWithBackgroundColor:(UIColor *)color;


+ (UIImageView *)generateImageView;
+ (UIImageView *)generateImageViewWithImage:(UIImage *)image;

+ (UITextField *)generateTextFieldWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)textColor placeholder:(NSString *)placeholder delegate:(id)delegate;

+ (UIButton *)generateButtonWithTarget:(id)target action:(SEL)action;

+ (UILabel *)generateLabelWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)textColor;

+ (void)addConstraintWithSuperView:(UIView *)superView visualFormats:(NSArray *)visualFormats views:(NSDictionary *)views;

+ (void)centerXWithSubView:(UIView *)subView superView:(UIView *)superView;

+ (void)centerYWithSubView:(UIView *)subView superView:(UIView *)superView;

@end
