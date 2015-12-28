//
//  CTDisplayView.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTDisplayView.h"


NSString *const CTDisplayViewImagePressNoticefication = @"CTDisplayViewImagePressNoticefication";
NSString *const CTDisplayViewLinkPressNoticefication = @"CTDisplayViewLinkPressedNotification";


typedef NS_ENUM(NSInteger, CTDisplayViewState) {
    CTDisplayViewStateNormal,   // 普通状态
    CTDisplayViewStateTouching, // 正在按下, 需要弹出放大镜
    CTDisplayViewStateSelecting // 选中一些文字, 需要弹出复制菜单
};


@interface CTDisplayView ()<UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSInteger selectionStartPosition;
@property (assign, nonatomic) NSInteger selectionEndPosition;
@property (assign, nonatomic) CTDisplayViewState state;
@property (strong, nonatomic) UIImageView *leftSectionAnchor;
@property (strong, nonatomic) UIImageView *rightSectionAnchor;

@end


@implementation CTDisplayView



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // 绘制文本
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    // 绘制图片
    for (CoreTextImageData * imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }

    
}

@end
