//
//  ViewController.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/23.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "UIView+Extension.h"

#import "CTImageViewController.h"
#import "CoreTextLinkData.h"
#import "CTWebContentViewController.h"

@interface ViewController ()
@property (weak, nonatomic)CTDisplayView *ctView;
@end

@implementation ViewController
/**
 *  设置状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (CTDisplayView *)ctView
{
    if (!_ctView) {
        CTDisplayView *ctView = [[CTDisplayView alloc] init];
        ctView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:ctView];
        _ctView = ctView;
    }
    return _ctView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    self.ctView.frame = CGRectMake(0, 0, PP_SCREEN_WIDTH, PP_SCREEN_HIGHT - 20);
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
////    self.extendedLayoutIncludesOpaqueBars = NO;
    
    // 0 注册通知
    [self setupNotifications];
    
    // 1. 配置参数
    CTFrameParseConfig *config = [[CTFrameParseConfig alloc] init];
    config.width = self.ctView.width;
    config.textColor = [UIColor blackColor];
    
    // 1.1 从文件中读取
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    
    // 2. 
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
}


/**
 *  注册通知
 */
- (void)setupNotifications {
    // 监听点击图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePressed:)
                                                 name:CTDisplayViewImagePressNoticefication
                                               object:nil];
    // 监听点击链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPressed:)
                                                 name:CTDisplayViewLinkPressNoticefication
                                               object:nil];
}


- (void)imagePressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextImageData *imageData = userInfo[@"imageData"];
    
    CTImageViewController *vc = [[CTImageViewController alloc] init];
    vc.image = [UIImage imageNamed:imageData.name];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)linkPressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextLinkData *linkData = userInfo[@"linkData"];
    LogYellow(@"linkdata -  %@", linkData);
    
    CTWebContentViewController *vc = [[CTWebContentViewController alloc] init];
    vc.urlTitle = linkData.title;
    vc.url = linkData.url;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
