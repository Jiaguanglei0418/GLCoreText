//
//  CTImageViewController.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTImageViewController.h"

@interface CTImageViewController ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation CTImageViewController
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, PP_SCREEN_WIDTH, PP_SCREEN_HIGHT)];
        imageView.image = _image;
//        imageView.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置工具条
    [self setupUI];

    // 按比例缩放图片
    [self adjustImageView];
}

- (void)setupUI
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, PP_SCREEN_WIDTH, 64)];
    toolbar.backgroundColor = [UIColor darkGrayColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backItem.width = 50;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    title.text = @"图片详情";
    title.center = toolbar.center;
    [toolbar addSubview:title];
    
    [toolbar setItems:@[backItem] animated:YES];
    [self.view addSubview:toolbar];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)adjustImageView {
    CGPoint center = self.view.center;
    CGFloat height = self.image.size.height * self.image.size.width / self.imageView.width;
    self.imageView.height = height;
    self.imageView.center = center;
}

@end
