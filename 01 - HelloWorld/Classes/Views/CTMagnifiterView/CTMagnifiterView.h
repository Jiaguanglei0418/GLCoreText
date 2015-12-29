//
//  CTMagnifiterView.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//
/**
 *   -------             放大镜视图
 * */
#import <UIKit/UIKit.h>

@interface CTMagnifiterView : UIView
@property (strong, nonatomic) UIView *viewToMagnify;
@property (assign, nonatomic) CGPoint touchPoint;
@end
