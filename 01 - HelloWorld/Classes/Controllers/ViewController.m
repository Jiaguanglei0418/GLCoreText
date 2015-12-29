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
@property (strong, nonatomic)CTDisplayView *ctView;

@end

@implementation ViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self setupNotifications];
    
    self.ctView = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 20, PP_SCREEN_WIDTH, PP_SCREEN_HIGHT)];
    
    [self.view addSubview:self.ctView];
    
    
    
    // 1. 配置参数
    CTFrameParseConfig *config = [[CTFrameParseConfig alloc] init];
    config.width = self.ctView.width;
    config.textColor = [UIColor blackColor];
    
    
    // 1.1 从文件中读取配置
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    
    // 2. 
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor lightGrayColor];

}
- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePressed:)
                                                 name:CTDisplayViewImagePressNoticefication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPressed:)
                                                 name:CTDisplayViewLinkPressNoticefication object:nil];
    
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
