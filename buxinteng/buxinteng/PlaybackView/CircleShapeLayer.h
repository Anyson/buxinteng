//
//  CircleShapeLayer.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/17.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CircleShapeLayer : CAShapeLayer

@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval timeLimit;
@property (assign, nonatomic, readonly) double percent;
@property (nonatomic) UIColor *progressColor;

@end
