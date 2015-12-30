//
//  CTMagnifiterView.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTMagnifiterView.h"

@implementation CTMagnifiterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 80, 80)];
    if (self) {
        // 设置边框
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    
    // 更新放大镜位置
    self.center = CGPointMake(touchPoint.x, touchPoint.y -70);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.width * 0.5, self.height * 0.5);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, -1 * (_touchPoint.x), -1 * (_touchPoint.y));
    [self.viewToMagnify.layer renderInContext:context];
    
}
@end
