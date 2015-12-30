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

/**
 *  CTDisplayView - width
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  显示的text 字号大小
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 *  显示text 行距
 */
@property (nonatomic, assign) CGFloat lineSpace;
/**
 *  显示text 颜色
 */
@property (nonatomic, strong) UIColor *textColor;


@end
