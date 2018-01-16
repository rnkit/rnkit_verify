//
//  CodeView.m
//  RNKitSensor
//
//  Created by Snow on 2018/1/13.
//  Copyright © 2018年 SnowYang. All rights reserved.
//

#import "CodeView.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

@interface CodeView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIControl *backgroundView;
@property (nonatomic, strong) UIView *webview;

@end


@implementation CodeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            weakSelf.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            
            weakSelf.backgroundView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
            weakSelf.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4F];
            weakSelf.backgroundView.userInteractionEnabled = YES;
        });
        
    }
    return self;
}


- (void)showVerificationCodeView:(NSString *)url
                     resultBlock:(void(^)(id result))resultBlock {
    __weak typeof(self)  weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"url====%@",url);
        [[TCWebCodesBridge sharedBridge] setCallback:^(NSDictionary *resultJSON, UIView *webView) {
            resultBlock(resultJSON);
            [weakSelf stopLoading];
            [weakSelf.backgroundView removeFromSuperview];
        }];
        
        [[TCWebCodesBridge sharedBridge] setReadyCallback:^(NSDictionary *resultJSON, UIView *webView) {
            NSLog(@"readyback====%@",resultJSON);
            if (2 == [resultJSON[@"state"] intValue]) { // 混合验证，验证码类型变化，刷新webview宽和高。说明：仅当业务需要自定义fwidth属性时需要处理state==2的情况
                CGFloat width = [resultJSON[@"fwidth"] floatValue];
                CGFloat height = [resultJSON[@"fheight"] floatValue];
                weakSelf.webview.frame = CGRectMake((kScreen_Width-width)*0.5, weakSelf.webview.frame.origin.y, width, height);
            } else {
                [weakSelf stopLoading];
            }
        }];
       
        
        [[TCWebCodesBridge sharedBridge] resetCapValue];
        
        CGFloat w = kScreen_Width * 0.9;
        CGSize size = [[TCWebCodesBridge sharedBridge] getCapSizeByWidth:w];
        NSLog(@"获取的宽度是====:%f,高度是:%f",size.width,size.height);
        [[TCWebCodesBridge sharedBridge] setCapValue:@"\"popup\"" forKey:@"type"];
        [[TCWebCodesBridge sharedBridge] setCapValue:[NSString stringWithFormat:@"\"%f\"", w] forKey:@"fwidth"];
        
        [weakSelf.webview removeFromSuperview];
        weakSelf.webview = nil;
        weakSelf.webview = [[TCWebCodesBridge sharedBridge] startLoad:url webFrame:CGRectMake((kScreen_Width-size.width)*0.5, (kScreen_Height-size.height)*0.5, size.width, size.height)];
        weakSelf.webview.userInteractionEnabled = YES;
        [weakSelf.backgroundView addSubview:weakSelf.webview];
        [weakSelf startLoading];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:weakSelf.backgroundView];
        
    });
    
}


- (void)startLoading
{
    _activityIndicator.center = CGPointMake(_webview.bounds.size.width*0.5, _webview.bounds.size.height*0.5);
    [_webview addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)stopLoading
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
}


@end

