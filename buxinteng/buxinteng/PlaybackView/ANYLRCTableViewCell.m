//
//  ANYLRCTableViewCell.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYLRCTableViewCell.h"
#import <UIView+SDCAutoLayout.h>

@interface ANYLRCTableViewCell ()

@property(nonatomic, strong) UILabel *lrcLabel;

@end

@implementation ANYLRCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setupViews];
}

- (void)setupViews {
    _lrcLabel = [Common generateLabelWithText:@""
                                textAlignment:NSTextAlignmentCenter
                                         font:FONT(17)
                                    textColor:RGB_TEXT_COLOR];
    [self.contentView addSubview:_lrcLabel];
    [_lrcLabel sdc_alignEdgesWithSuperview:UIRectEdgeAll];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [_lrcLabel setTextColor:RGB_PRIMARY];
    }
}

- (void)setupLRC:(NSString *)lrc {
    [_lrcLabel setText:lrc];
    [_lrcLabel setTextColor:RGB_TEXT_COLOR];
}

- (void)setupLRCColor:(UIColor *)color {
    [_lrcLabel setTextColor:color];
}

@end
