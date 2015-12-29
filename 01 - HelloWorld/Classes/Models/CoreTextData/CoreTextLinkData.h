//
//  CoreTextLinkData.h
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;

@property (assign, nonatomic) NSRange range;
@end
