//
//  CoreTextLinkData.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

/**
 *  链接名称 -- 载体
 */
@property (copy, nonatomic) NSString *title;
/**
 *  链接url
 */
@property (copy, nonatomic) NSString *url;
/**
 *  链接文字的range
 */
@property (assign, nonatomic) NSRange range;
@end
