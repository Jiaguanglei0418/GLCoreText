//
//  Define.h
//  Onlyou
//
//  Created by jiaguanglei on 15/12/17.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#ifndef Define_h
#define Define_h


/**
 *  1. 通知处理
 */

// 添加通知
#define PP_NOTIFICATION_ADD(notificationName,method) \
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method) name:notificationName object:nil];

// 调用通知
#define PP_NOTIFICATION_POST(notificationName,param) \
[[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:param];

// 删除通知
#define PP_NOTIFICATION_REMOVE(notificationName) \
[[NSNotificationCenter defaultCenter]removeObserver:self name:notificationName object:nil];

/* 2. 版本号
 */
//唯一标示
#define PP_UTILS_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//版本号
#define PP_UTILS_VERSION [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]

/**
 *  3. 收键盘
 */
// 收键盘
#define PP_RETURNKEYBOARD [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

/**
 *  4. 移除对象
 */
#define PP_SAFEREMOVEW(varName) \
[varName removeFromSuperview]; \
varName = nil;

/**
 *  5. 添加corner
 */
#define PP_ADDCORNER(varName) \
varName.layer.cornerRadius = kCornerRadius; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PPCOLOR_RGB_CG(220, 220, 220); \
varName.layer.masksToBounds = YES; \

#define PP_ADDCORNER_10(varName) \
varName.layer.cornerRadius = 10; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PPCOLOR_RGB_CG(220, 220, 220); \
varName.layer.masksToBounds = YES; \


#define PP_ADDCORNERGREEN(varName) \
varName.layer.cornerRadius = kCornerRadius; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PPCOLOR_RGB_CG(47, 192, 177); \
varName.layer.masksToBounds = YES; \


#define PP_UIViewLine(varName,cellHeight) \
UIView *line=[[UIView alloc]initWithFrame:CGRectMake( 0,cellHeight-1,SCREEN_WIDTH, 1)];\
[line setBackgroundColor:PPCOLOR_RGB_CG(238, 238, 238)];\
[varName addSubview:line];


/**
 *  1. RGB背景色
 */
#define PPCOLOR_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PPCOLOR_RGB_CG(r, g, b) PPCOLOR_RGB(r,g,b).CGColor


#define PPCOLOR_BG PPCOLOR_RGB(231, 231, 231)

#define PPCOLOR_FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define PPCOLOR_RANDOM PPCOLOR_RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))


#define PPCOLOR_TABBAR_TITLE PPCOLOR_RGB(236,103,0)
#define PPCOLOR_TABBAR_NORMAL PPCOLOR_RGB(117,117,117)



/**
 *  2.通知
 */
#define PPNOTICEFICATION [NSNotificationCenter defaultCenter]

#define PP_APPLICATION [UIApplication sharedApplication]
#define PP_KEYWINDOW [UIApplication sharedApplication].keyWindow

/**
 *  3. 获取屏幕宽度
 */
#define PP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PP_SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
#define PP_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define PP_SCREEN_RECT [UIScreen mainScreen].bounds


/**
 *  4. weakSelf
 */
#define WS(weakSelf)  __weak typeof(self)weakSelf = self


/**
 *  5. 路径
 */
#define PP_PATH_ACCOUNT [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]



// ---------------------------- 打印日志  ----------------------------------
// 自定义log
#ifdef DEBUG
#define PPLog(FORMAT, ...) fprintf(stderr,"\n%s %d\n %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
//#define PPLog(...) NSLog(@"%s %@",__func__, [NSString stringWithFormat:__VA_ARGS__])

#else
#define PPLog(FORMAT, ...)

#endif


// 打印返回responsedata
#define PPLogData(obj,content) \
if(DEBUG) \
{ \
NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil]; \
NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]; \
NSLog(@"%@----->%@",content,string); \
}


#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;"
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;"
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"

/**  不同等级的Log，也可开关，当前已开  */
#define LOG_LEVEL_Warn
#define LOG_LEVEL_INFO
#define LOG_LEVEL_ERROR
//如需关闭，就将你需要关闭的宏定义注销那么该种形式的Log将不显示或者以默认颜色显示
#ifdef LOG_LEVEL_ERROR
#define KKLogError(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#else
#define KKLogError(...) //NSLog(__VA_ARGS__)
#endif


// 设置输出颜色 --  需要安装Xcode colors 插件 https://github.com/robbiehanson/XcodeColors
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBlack(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBrown(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg153,102,51;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogCyan(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogMagenta(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogOrange(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,127,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogPurple(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg127,0,127;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogYellow(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogWhite(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)




#endif /* Define_h */
