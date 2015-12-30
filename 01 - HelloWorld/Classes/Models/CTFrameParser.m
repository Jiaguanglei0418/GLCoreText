//
//  CTFrameParser.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser

/**
 *  内联函数  --- 编译的时候效率更快
 **/
static inline CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static inline CGFloat descentCallback(void *ref){
    return 0;
}

static inline CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParseConfig *)config
{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    return [self parseAttributedContent:contentString config:config];
}


/**
 *  1. 配置设置 - attributes
 */
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParseConfig *)config
{
    // 设置字号
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    // 设置行距
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex KNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[KNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, KNumberOfSettings);
    // 设置文本颜色
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

/**
 *  2. 创建 CoreTextData实例
 */
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParseConfig *)config
{
   // 创建CTFrameSetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) content);
    
    // 获得要绘制得区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self creatFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中, 最后返回CoretextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}


/**
 *  2.1 生成CTFrameRef实例
 */
+ (CTFrameRef)creatFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParseConfig *)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}


/**
 *  3. 根据模板(json) 生成CoreTextData
 */
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParseConfig *)config
{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

// 3.1
+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParseConfig* )config imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) { // 文本
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict
                                                                                   config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"img"]){
                    // 创建CoreTextImageData
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    
                    // 创建空白占位符, 并且设置他的CTRunDelegate
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict
                                                                           config:config];

                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"link"]){
                    NSUInteger startPos = result.length;
                    // 创建CoretextLinkData
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict      config:config];
                    [result appendAttributedString:as];
                    
                    NSUInteger length = result.length - startPos;
                    NSRange linkPange = NSMakeRange(startPos, length);
                    
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkPange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return result;
}



// 3.2 设置链接属性文本
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(CTFrameParseConfig *)config
{
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    
    // set Color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    // set Font
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

// 3.3 设置颜色
+ (UIColor *)colorFromTemplate:(NSString *)name
{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if ([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    }else if ([name isEqualToString:@"yellow"]){
        return [UIColor yellowColor];
    }else if ([name isEqualToString:@"cyanColor"]){
        return [UIColor cyanColor];
    }else if ([name isEqualToString:@"darkGrayColor"]){
        return [UIColor darkGrayColor];
    }else if ([name isEqualToString:@"whiteColor"]){
        return [UIColor whiteColor];
    }else if ([name isEqualToString:@"grayColor"]){
        return [UIColor grayColor];
    }else if ([name isEqualToString:@"greenColor"]){
        return [UIColor greenColor];
    }else if ([name isEqualToString:@"magentaColor"]){
        return [UIColor magentaColor];
    }else if ([name isEqualToString:@"orangeColor"]){
        return [UIColor orangeColor];
    }else if ([name isEqualToString:@"purpleColor"]){
        return [UIColor purpleColor];
    }else if ([name isEqualToString:@"brownColor"]){
        return [UIColor brownColor];
    }else if ([name isEqualToString:@"clearColor"]){
        return [UIColor clearColor];
    }
        return nil;
}


// 3.4 生成图片空白的占位符, 并且设置CTRunDelegate信息
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CTFrameParseConfig *)config
{
    CTRunDelegateCallbacks callbacks;
    // memset: void *memset(void *s, int ch, size_t n);
    // 函数解释：将s中前n个字节 （typedef unsigned int size_t ）用 ch 替换并返回 s 。
    // 作用: 在一段内存块中填充某个给定的值，它是对较大的结构体或数组进行清零操作的一种最快方法
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    return space;
}

@end
