//
//  CTFrameParseConfig.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

/**
 *  配置类  --  用于实现排版时的可配置项
 **/

#import <Foundation/Foundation.h>

@interface CTFrameParseConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;


@end
