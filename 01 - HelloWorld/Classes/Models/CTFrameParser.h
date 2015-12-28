//
//  CTFrameParser.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

/**
 *  排版类  ---  用于生成最后绘制界面需要的CTFrameRef 实例  -- 实现排版
 */

#import <Foundation/Foundation.h>
#import "CTFrameParseConfig.h"
#import "CoreTextData.h"
#import "CoreTextImageData.h"

@interface CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParseConfig *)config;

//+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParseConfig *)config;
//+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParseConfig *)config;


+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParseConfig *)config;


@end
