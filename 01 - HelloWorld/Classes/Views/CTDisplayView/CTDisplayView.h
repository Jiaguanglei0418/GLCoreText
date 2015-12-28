//
//  CTDisplayView.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//
/**
 *  负责显示的类  --  只负责显示
 *
 *  @param strong    <#strong description#>
 *  @param nonatomic <#nonatomic description#>
 *
 *  @return <#return value description#>
 */
#import <UIKit/UIKit.h>
#import "CoreTextData.h"



extern NSString *const CTDisplayViewImagePressNoticefication;
extern NSString *const CTDisplayViewLinkPressNoticefication;


@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData *data;

@end
