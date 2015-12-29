//
//  CTWebContentViewController.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/28.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTWebContentViewController.h"

@interface CTWebContentViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) UIActivityIndicatorView *activity;

@end

@implementation CTWebContentViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PP_SCREEN_WIDTH, 64)];
        titleLabel.backgroundColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        
        [self.view addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, PP_SCREEN_WIDTH, PP_SCREEN_HIGHT)];
        web.delegate = self;
        web.scalesPageToFit = YES;
        [self.view addSubview:web];
        _webView = web;
    }
    return _webView;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        act.center = self.webView.center;
        [self.view addSubview:act];
        _activity = act;
    }
    return _activity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置标题
    self.titleLabel.text = self.urlTitle;
    
    UIButton *back = [self addBackBtnWithTitle:@"back"];
    back.frame = CGRectMake(2, 21, 60, 42);

    [self.view insertSubview:back aboveSubview:self.titleLabel];
    
    //
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}

- (UIButton *)addBackBtnWithTitle:(NSString *)title
{
    //
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:title forState:UIControlStateNormal];
    [back setAdjustsImageWhenHighlighted:NO];
    back.layer.borderColor = [UIColor lightGrayColor].CGColor;
    back.layer.borderWidth = 1;
    back.layer.cornerRadius = 10;
    back.layer.masksToBounds = YES;
    back.backgroundColor = [UIColor clearColor];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    return back;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activity stopAnimating];
}
@end
