//
//  QUCustomAlertView.m
//  QuickCocoaDemo
//
//  Created by BriceZH on 2018/7/19.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "QUCustomAlertView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kCustomAlertViewButtonHeight       = 44;
const CGFloat kCustomAlertViewCornerRadius       = 7;

@implementation QUCustomAlertView

CGFloat customButtonHeight = 0;

- (instancetype)initWithParrentView:(UIView *)parrentView {
    self = [super initWithFrame:parrentView.bounds];
    if (self) {
        self.parrentView = parrentView;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.delegate = self;
        self.isUseMotionEffects = NO;
        self.closeOnTouchUpOutside = NO;
        self.buttonTitles = @[@"关闭"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)show {
    self.backgroundColor = [UIColor clearColor];
    self.dialogBoxView = [self createContainerView];
    
    [self addSubview:self.dialogBoxView];
    if (self.parrentView != nil) {
        [self.parrentView addSubview:self];
        
        // Attached to the top most window
    } else {
        CGSize screenSize = self.bounds.size;
        CGSize dialogSize = [self countDialogSize];
        CGSize keyboardSize = CGSizeMake(0, 0);
        
        self.dialogBoxView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
        [[[UIApplication sharedApplication] windows].firstObject addSubview:self];
    }
    self.dialogBoxView.layer.opacity = 0.5f;
    self.dialogBoxView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [QUCustomAlertView colorWithR:0 g:0 b:0 a:0.5];
                         self.dialogBoxView.layer.opacity = 1.0f;
                         self.dialogBoxView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:nil];
}

- (void)close
{
    CATransform3D currentTransform = self.dialogBoxView.layer.transform;
    self.dialogBoxView.layer.opacity = 1.0f;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         self.dialogBoxView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogBoxView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (UIView *)createContainerView
{
    if (self.containerView == nil) {
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 160)];
    }
    
    if (self.buttonTitles && self.buttonTitles.count) {
        customButtonHeight = kCustomAlertViewButtonHeight;
    } else {
        customButtonHeight = 0;
    }
    
    CGSize dialogSize = [self countDialogSize];
    
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - dialogSize.width) / 2, (self.bounds.size.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    dialogContainer.layer.cornerRadius = kCustomAlertViewCornerRadius;
    dialogContainer.layer.masksToBounds = YES;
    [dialogContainer addSubview:self.containerView];
    
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

- (CGSize)countDialogSize {
    CGFloat dialogWidth = self.containerView.frame.size.width;
    CGFloat dialogHeight = self.containerView.frame.size.height + customButtonHeight;
    return CGSizeMake(dialogWidth, dialogHeight);
}

- (void)addButtonsToView: (UIView *)container {
    if (self.buttonTitles == nil) {
        return;
    }
    NSUInteger titleCount = self.buttonTitles.count;
    CGFloat buttonWidth = (container.bounds.size.width - 10 * (titleCount + 1)) / titleCount;
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, container.bounds.size.height - kCustomAlertViewButtonHeight, container.bounds.size.width, kCustomAlertViewButtonHeight)];
    btnBackView.backgroundColor = [UIColor whiteColor];
    [container addSubview:btnBackView];
    for (int i = 0; i < titleCount; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(i * buttonWidth + (i + 1) * 10, container.bounds.size.height - kCustomAlertViewButtonHeight - 10, buttonWidth, kCustomAlertViewButtonHeight)];
        closeButton.layer.cornerRadius = 3.0f;
        [closeButton addTarget:self action:@selector(ZXDialogBoxButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        closeButton.titleLabel.numberOfLines = 1;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            UIColor *titleColor = titleCount <= 1 ? [UIColor whiteColor] : [QUCustomAlertView colorWithR:153 g:153 b:153 a:1];
            UIColor *backgroundColor = titleCount <= 1 ? [QUCustomAlertView colorWithR:80 g:140 b:238 a:1] : [UIColor whiteColor];
            closeButton.layer.borderWidth = titleCount <= 1 ? 0.0f : 1.0f;
            closeButton.layer.borderColor = [QUCustomAlertView colorWithR:233 g:233 b:233 a:1].CGColor;
            [closeButton setTitleColor:titleColor forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
            [closeButton setBackgroundColor:backgroundColor];
        }
        if(i>0){
            //右侧按钮
            [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
            [closeButton setBackgroundColor:[QUCustomAlertView colorWithR:80 g:140 b:238 a:1]];
        }
        container.backgroundColor = [UIColor clearColor];
        [container addSubview:closeButton];
    }
}

- (void)ZXDialogBoxButtonTouchUpInside:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate CustomAlertViewTouchUpInside:self clickedButtonAtIndex:[(UIButton*)sender tag]];
    }
    
    if (self.onButtonTouchUpInside != nil) {
        self.onButtonTouchUpInside(self, (NSUInteger)[(UIButton*)sender tag]);
    }
}

// Default button behaviour
- (void)CustomAlertViewTouchUpInside:(QUCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}

- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = self.bounds.size;
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogBoxView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     } completion:nil];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = self.bounds.size;
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogBoxView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     } completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.closeOnTouchUpOutside) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[QUCustomAlertView class]]) {
        [self close];
    }
}


+ (UIColor *)colorWithHex:(NSUInteger)hex {
    
    CGFloat red, green, blue, alpha;
    
    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    if (hexString.length) {
        NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        // String should be 6 or 8 characters
        
        if ([cString length] < 6) return [UIColor blackColor];
        // strip 0X if it appears
        if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
        if ([cString length] != 6) return [UIColor blackColor];
        
        // Separate into r, g, b substrings
        
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        // Scan values
        unsigned int r, g, b;
        
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }else {
        return nil;
    }
}

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a];
}


@end
