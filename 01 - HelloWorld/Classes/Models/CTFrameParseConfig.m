//
//  CTFrameParseConfig.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTFrameParseConfig.h"

@implementation CTFrameParseConfig

- (instancetype)init
{
    if (self = [super init]) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 10.0f;
        _textColor = PPCOLOR_RGB(108, 108, 108);
    }
    return self;
}

@end
