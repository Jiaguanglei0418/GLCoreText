//
//  CoreTextUtils.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CoreTextUtils.h"

@implementation CoreTextUtils

// 检测点击位置是否在链接上
+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data
{
    CFIndex idx = [self touchContentOffsetInView:view atPoint:point data:data];
    if (idx == -1) {
        return nil;
    }

    CoreTextLinkData *fountLink = [self linkAtIndex:idx linkArray:data.linkArray];

    return fountLink;
}


// 将点击位置转换成字符串偏移量, 如果没有找到, 则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data
{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行orgin的坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

/**
 *      获得每一行的CGRect信息
 */
+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

+ (CoreTextLinkData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    CoreTextLinkData *link = nil;
    for (CoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

//+ (CoreTextLinkData *)linkAtIndex:(CFIndex)idx linkArray:(NSArray *)linkArray
//{
//    CoreTextLinkData *link = nil;
//    for (CoreTextLinkData *data in linkArray) {
//        if (NSLocationInRange(idx, data.range)) {
//            link = data;
//            break;
//        }
//    }
//    return link;
//}

@end
