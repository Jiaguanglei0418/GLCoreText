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
/**
 *  显示放大信息
 */
@property (weak, nonatomic) UIView *viewToMagnify;
/**
 *  记录屏幕中点击位置
 */
@property (assign, nonatomic) CGPoint touchPoint;
@end
