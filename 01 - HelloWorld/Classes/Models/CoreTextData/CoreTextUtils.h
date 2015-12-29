//
//  CoreTextUtils.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject
+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
