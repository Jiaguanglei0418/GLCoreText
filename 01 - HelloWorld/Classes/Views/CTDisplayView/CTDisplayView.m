//
//  CTDisplayView.m
//  01 - HelloWorld
//
//  Created by jiaguanglei on 15/12/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "CTDisplayView.h"
#import "CTMagnifiterView.h"
#import "CoreTextUtils.h"


NSString *const CTDisplayViewImagePressNoticefication = @"CTDisplayViewImagePressNoticefication";
NSString *const CTDisplayViewLinkPressNoticefication = @"CTDisplayViewLinkPressedNotification";


typedef NS_ENUM(NSInteger, CTDisplayViewState) {
    CTDisplayViewStateNormal,   // 普通状态
    CTDisplayViewStateTouching, // 正在按下, 需要弹出放大镜
    CTDisplayViewStateSelecting // 选中一些文字, 需要弹出复制菜单
};

#define ANCHOR_TARGET_TAG 1
#define FONT_HEIGHT  40
@interface CTDisplayView ()<UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSInteger selectionStartPosition;
@property (assign, nonatomic) NSInteger selectionEndPosition;
@property (assign, nonatomic) CTDisplayViewState state;
@property (strong, nonatomic) UIImageView *leftSectionAnchor;
@property (strong, nonatomic) UIImageView *rightSectionAnchor;

@property (strong, nonatomic) CTMagnifiterView *magnifiterView;
@end


@implementation CTDisplayView
/**
 *  lazy -  magnifiterView
 */
- (CTMagnifiterView *)magnifiterView
{
    if (_magnifiterView == nil) {
        _magnifiterView = [[CTMagnifiterView alloc] init];
        _magnifiterView.viewToMagnify = self;
        [self addSubview:_magnifiterView];
    }
    return _magnifiterView;
}


#pragma mark - 初始化
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEvents];
    }
    return self;
}




- (void)setData:(CoreTextData *)data
{
    _data = data;
    
    self.state = CTDisplayViewStateNormal;
}

// 1.
- (void)setupAnchors
{
    _leftSectionAnchor = [self creatSelectionAnchorWithTop:YES];
    _rightSectionAnchor = [self creatSelectionAnchorWithTop:NO];
    [self addSubview:_leftSectionAnchor];
    [self addSubview:_rightSectionAnchor];
}
// 1.1
- (UIImageView *)creatSelectionAnchorWithTop:(BOOL)isTop
{
    UIImage *image = [self cursorWithFontHeight:FONT_HEIGHT isTop:isTop];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 11, FONT_HEIGHT);
    return imageView;
}

/**
 *  1.2 获取上下文图片
 */
- (UIImage *)cursorWithFontHeight:(CGFloat)height isTop:(BOOL)top
{
    // 22
    CGRect rect = CGRectMake(0, 0, 22, height * 2);
    UIColor *color = PPCOLOR_RGB(28, 107, 222);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw point
    if (top) {
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 22, 22));
    }else{
        CGContextAddEllipseInRect(context, CGRectMake(0, height * 2 - 22, 22, 22));
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    // draw line
    [color set];
    CGContextSetLineWidth(context, 4);
    CGContextMoveToPoint(context, 11, 22);
    CGContextAddLineToPoint(context, 11, height * 2 - 22);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 1.3
- (void)removeSelectionAnchor
{
    if (_leftSectionAnchor) {
        [_leftSectionAnchor removeFromSuperview];
        _leftSectionAnchor = nil;
    }
    if (_rightSectionAnchor) {
        [_rightSectionAnchor removeFromSuperview];
        _rightSectionAnchor = nil;
    }
}

- (void)setState:(CTDisplayViewState)state
{
    if (_state == state) {
        return;
    }
    
    _state = state;
    if (_state == CTDisplayViewStateNormal) {
        _selectionStartPosition = -1;
        _selectionEndPosition = -1;
        [self removeSelectionAnchor];
        [self removeMagnifiterView];
        [self hideMenuController];
    }else if(_state == CTDisplayViewStateTouching){
        if (_leftSectionAnchor == nil && _rightSectionAnchor == nil) {
            [self setupAnchors];
        }
    }else if (_state == CTDisplayViewStateSelecting){
        if (_leftSectionAnchor == nil && _rightSectionAnchor == nil) {
            [self setupAnchors];
        }
        if (_leftSectionAnchor.tag != ANCHOR_TARGET_TAG && _rightSectionAnchor.tag != ANCHOR_TARGET_TAG) {
            [self removeMagnifiterView];
            [self hideMenuController];
        }
    }
    [self setNeedsDisplay];
}

/**
 *  2. 设置点击手势
 */
- (void)setupEvents
{
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(tapGestureDetected:)];
    [self addGestureRecognizer:tap];
    
    UIGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(longPressGuestureDetected:)];
    [self addGestureRecognizer:longPress];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(panGestureDetected:)];
    [self addGestureRecognizer:pan];
    
    // 开启交互
    self.userInteractionEnabled = YES;
}


#pragma mark - tapGestureDetected
/**
 *  监听手势点击
 */
- (void)tapGestureDetected:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    if (_state == CTDisplayViewStateNormal) {
        for (CoreTextImageData *imageData in self.data.imageArray) {
            // 翻转坐标系, 因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在Rect内部
            if(CGRectContainsPoint(rect, point)){
                LogRed(@"点击了图片");
                NSDictionary *userInfo = @{@"imageData" : imageData};
                // 发通知
                [PPNOTICEFICATION postNotificationName:CTDisplayViewImagePressNoticefication object:self userInfo:userInfo];
                return;
            }
        }
        
        CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
        if (linkData) {
            LogYellow(@"点击了链接");
            NSDictionary *userInfo = @{@"linkData" : linkData};
            [PPNOTICEFICATION postNotificationName:CTDisplayViewLinkPressNoticefication object:self userInfo:userInfo];
            return;
        }
    }else{
        self.state = CTDisplayViewStateNormal;
    }
}


#pragma mark - longPressGuestureDetected
- (void)longPressGuestureDetected:(UITapGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:self];
//
//    LogYellow(@"%s -- state:%ld --- point:%@", __FUNCTION__, longPress.state, NSStringFromCGPoint(point));
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
        if (index != -1 && index <= self.data.content.length) {
            _selectionStartPosition = index;
            _selectionEndPosition = index + 2;
        }
        self.magnifiterView.touchPoint = point;
        self.state = CTDisplayViewStateTouching; // 触摸状态
    }else{ // 选中状态
        if (_selectionStartPosition >= 0 && _selectionEndPosition <= self.data.content.length) {
            self.state = CTDisplayViewStateSelecting;
            [self showMenuController];
        }else{
            self.state = CTDisplayViewStateNormal;
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    LogYellow(@"%s", __FUNCTION__);
    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:) || action == @selector(selectAll:)) {
        return YES;
    }
    return NO;
}

#pragma mark - 显示选中文本操作
- (void)showMenuController
{
    if([self becomeFirstResponder]){
        CGRect selectionRect = [self rectForMenuController];
        // 翻转坐标系
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
        selectionRect = CGRectApplyAffineTransform(selectionRect, transform);
        
        // 显示菜单控制器
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}



// 显示菜单控制器
- (CGRect)rectForMenuController
{
    if(_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length){
        return CGRectZero;
    }
    
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return CGRectZero;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);

    CGRect resultRect = CGRectZero;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        
        // 1. state 和 end 在一个line, 则直接break
        if([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]){
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            
            resultRect = lineRect;
            break;
        }
    }
    
    if (!CGRectIsEmpty(resultRect)) {
        return resultRect;
    }
    
    // 2. start 和 end 不在一个line
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        
        // 如果start 在line中, 则记录当前起始行
        if([self isPosition:_selectionStartPosition inRange:range]){
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            resultRect = lineRect;
        }
    }
    
    return resultRect;
}



// 判断是否在当前行
- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range
{
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - panGestureDetected
- (void)panGestureDetected:(UITapGestureRecognizer *)pan
{
    if (self.state == CTDisplayViewStateNormal) {
        return;
    }
    CGPoint point = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (_leftSectionAnchor && CGRectContainsPoint(CGRectInset(_leftSectionAnchor.frame, -25, -6), point)) {
            LogRed(@"try to move left anchor");
            _leftSectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        }else if (_rightSectionAnchor && CGRectContainsPoint(CGRectInset(_rightSectionAnchor.frame, -25, -6), point)){
            LogRed(@"try to move right anchor");
            _rightSectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
        if (index == -1) {
            return;
        }
        
        if (_leftSectionAnchor.tag == ANCHOR_TARGET_TAG && index < _selectionEndPosition) {
            LogRed(@"change start position to %ld", index);
            _selectionStartPosition = index;
            self.magnifiterView.touchPoint = point;
            [self hideMenuController];
        }else if (_rightSectionAnchor.tag == ANCHOR_TARGET_TAG){ //  && index > _selectionEndPosition 限制只能往后拖拽
            LogRed(@"change end position to %ld", index);
            _selectionEndPosition = index;
            self.magnifiterView.touchPoint = point;
            [self hideMenuController];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled){
        LogRed(@"end move");
        _leftSectionAnchor.tag = 0;
        _rightSectionAnchor.tag = 0;
        
        [self removeMagnifiterView];
        [self showMenuController];
    }
    [self setNeedsDisplay];
}

- (void)removeMagnifiterView
{
    if (_magnifiterView) {
        [_magnifiterView removeFromSuperview];
        _magnifiterView = nil;
    }
}

- (void)hideMenuController
{
    if ([self resignFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setMenuVisible:NO animated:YES];
    }
}

#pragma mark - drawAnchors

- (void)drawAnchors {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            _leftSectionAnchor.origin = origin;
        }
        if ([self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            _rightSectionAnchor.origin = origin;
            break;
        }
    }
}

- (void)drawSelectionArea {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
            break;
        }
        
        // 2. start和end不在一个line
        // 2.1 如果start在line中，则填充Start后面部分区域
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.2 如果 start在line前，end在line后，则填充整个区域
        else if (_selectionStartPosition < range.location && _selectionEndPosition >= range.location + range.length) {
            CGFloat ascent, descent, leading, width;
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, width, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.3 如果start在line前，end在line中，则填充end前面的区域,break
        else if (_selectionStartPosition < range.location && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        }
    }
}


- (void)fillSelectionAreaInRect:(CGRect)rect {
    UIColor *bgColor = PPCOLOR_RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if (self.data == nil) {
        return;
    }
    
    // 绘制文本
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    // 选中文字 
    if (self.state == CTDisplayViewStateTouching || self.state == CTDisplayViewStateSelecting) {
        [self drawSelectionArea];
        [self drawAnchors];
    }
    
    CTFrameDraw(self.data.ctFrame, context);
    
    // 绘制图片
    for (CoreTextImageData * imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end
