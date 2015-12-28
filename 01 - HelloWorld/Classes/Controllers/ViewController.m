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

@interface ViewController ()
@property (strong, nonatomic)CTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ctView = [[CTDisplayView alloc] initWithFrame:CGRectMake(5, 20, PP_SCREEN_WIDTH - 10, PP_SCREEN_HIGHT * 0.5)];
    
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
    self.ctView.backgroundColor = [UIColor yellowColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
