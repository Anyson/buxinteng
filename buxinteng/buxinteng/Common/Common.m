//
//  Common.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/15.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "Common.h"

/*
 * @class BarItemButton
 * @discription 自动button，解决：iOS7中自定义导航栏按钮图片会有左右偏移，比如leftBarButtonItem可能会向右偏移10几个像素。
 *
 */
@interface BarItemButton : UIButton

@end

@implementation BarItemButton

//- (UIEdgeInsets)alignmentRectInsets
//{
//    UIEdgeInsets insets;
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        if([self isLeftButton])
//        {
//            insets = UIEdgeInsetsMake(0, 13, 0, 0);
//        }
//        else
//        {
//            insets = UIEdgeInsetsMake(0, 0, 0, 13);
//        }
//    }
//    else
//    {
//        insets = UIEdgeInsetsZero;
//    }
//
//    return insets;
//}
//
//- (BOOL)isLeftButton
//{
//    return self.frame.origin.x < (self.superview.frame.size.width / 2);
//}

@end


@implementation Common

+ (UIBarButtonItem *)initBackwardButton:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action  {
    
    UIImage *back_ima = [UIImage imageNamed:@"btn-back-icon"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:17.0f], paragraphStyle]
                                                                             forKeys:@[NSFontAttributeName, NSParagraphStyleAttributeName]];
    
    CGRect  rectOfStr = [title boundingRectWithSize:CGSizeMake(100.0f, 17.0f)
                                            options:NSStringDrawingTruncatesLastVisibleLine
                                         attributes:textAttributes
                                            context:nil];
    
    BarItemButton *btn = [[BarItemButton alloc] initWithFrame:CGRectMake(0, 0, rectOfStr.size.width + back_ima.size.width + 20, 20)];
    [btn setTitle:title
         forState:UIControlStateNormal];
    [btn setTitleColor:RGB_PRIMARY
              forState:UIControlStateNormal];
    [btn setImage:back_ima
         forState:UIControlStateNormal];
    [[btn titleLabel] setFont:[UIFont systemFontOfSize:17.0f]];
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtn;
}

+ (UIBarButtonItem *)initButtonImageName:(NSString *)imageName
                                  target:(id)target
                                  action:(SEL)action  {
    UIImage *image = [UIImage imageNamed:imageName];
    BarItemButton *btn = [[BarItemButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [btn setImage:image
         forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtn;
}

+ (UIView *)generateSeperateLineWithFrame:(CGRect)frame {
    UIView *seperateLine = [[UIView alloc] initWithFrame:frame];
    [seperateLine setBackgroundColor:RGBA(181.0f, 181.0f, 181.0f, 1.0f)];
    return seperateLine;
}

+ (UIView *)generateViewWithBackgroundColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}

+ (UIImageView *)generateImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return imageView;
}

+ (UIImageView *)generateImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return imageView;
}

+ (UITextField *)generateTextFieldWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)textColor placeholder:(NSString *)placeholder delegate:(id)delegate {
    //_nickNameField
    UITextField *textField = [[UITextField alloc] init];
    textField.text = text;
    textField.textAlignment = textAlignment;
    textField.font = font;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.delegate = delegate;
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    return textField;
}

+ (UIButton *)generateButtonWithTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)generateLabelWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setText:text];
    [label setTextAlignment:textAlignment];
    [label setFont:font];
    [label setTextColor:textColor];
    return label;
}

+ (void)addConstraintWithSuperView:(UIView *)superView visualFormats:(NSArray *)visualFormats views:(NSDictionary *)views {
    for (NSString *str in visualFormats) {
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:str
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
}

+ (void)centerXWithSubView:(UIView *)subView superView:(UIView *)superView {
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
}

+ (void)centerYWithSubView:(UIView *)subView superView:(UIView *)superView {
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
