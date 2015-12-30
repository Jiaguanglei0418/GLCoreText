//
//  CoreTextData.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData


/**
 *  重写set方法, 先清除之前的frame, 再赋值
 */
- (void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != ctFrame) {
        if (_ctFrame) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

/**
 *  避免野指针 和 内存泄露问题
 */
- (void)dealloc{
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}


- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    [self fillImagePosition];
}




/**
 *  找到没张图片在绘制时的位置
 */
- (void)fillImagePosition{
    if (_imageArray.count == 0) {
        return;
    }
    
    // 根据frame, 获取CTline --- 行数
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];
    
    for (int i = 0; i < lineCount; i++) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        // 根据line, 获取每行具体内容;
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)(runObj);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes objectForKey:(id)kCTRunDelegateAttributeName]);
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            }else{
                imageData = self.imageArray[imgIndex];
            }
        }
    }
    
}

@end
