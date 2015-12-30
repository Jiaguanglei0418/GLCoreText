//
//  CoreTextImageData.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

/**
 *  图片名称
 */
@property (strong, nonatomic) NSString * name;
/**
 *  图片的个数
 */
@property (nonatomic, assign) NSInteger position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;


@end
