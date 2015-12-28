//
//  RODisplayView.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "RODisplayView.h"
#import <CoreText/CoreText.h>

@implementation RODisplayView
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1. 得到当前画布的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2. 将坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 3. 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // 4. 创建需要显示的内容
    NSAttributedString *attring = [[NSAttributedString alloc] initWithString:@"Hello World!!!" attributes:nil];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attring);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attring.length), path, NULL);
    
    // 5. 开始渲染
    CTFrameDraw(frame, context);
    
    // 6. 释放
    CFRelease(frameSetter);
    CFRelease(path);
    CFRelease(frame);
    
    
}
@end
