//
//  CoreTextData.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//
/**
 *  模型类  --  承载显示需要的所有数据 
 */

#import <Foundation/Foundation.h>
#import "CoreTextImageData.h"
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;


// 新增加 图片数组
@property (strong, nonatomic) NSArray * imageArray;
// 点击事件
@property (strong, nonatomic) NSArray * linkArray;

@property (strong, nonatomic) NSAttributedString *content;


@end
