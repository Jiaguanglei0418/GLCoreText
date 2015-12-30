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

/**
 *  CTDisplayView -- frame
 */
@property (assign, nonatomic) CTFrameRef ctFrame;
/**
 *  CTDisplayView -- height
 */
@property (assign, nonatomic) CGFloat height;
/**
 *  需要展示的 文本内容
 */
@property (strong, nonatomic) NSAttributedString *content;



/**
 *  需要展示的 images
 */
@property (strong, nonatomic) NSArray * imageArray;
/**
 *  需要展示的 Links
 */
@property (strong, nonatomic) NSArray * linkArray;


@end
