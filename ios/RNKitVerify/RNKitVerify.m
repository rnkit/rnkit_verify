//
//  RNKitVerify.m
//  RNKitVerify
//
//  Created by Snow on 2018/1/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

#import "RNKitVerify.h"


#if __has_include(<React/RCTBridge.h>)
#import <React/RCTConvert.h>
#import <React/RCTLog.h>
#else
#import "RCTConvert.h"
#import "RCTLog.h"
#endif

#import "CodeView.h"

@interface RNKitVerify ()

@property (nonatomic, strong) CodeView *codeView;

@end

@implementation RNKitVerify

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents
{
    return @[@"verifyResult"];
}

/**
 *显示验证码
 */
RCT_EXPORT_METHOD (showVerifyView:(NSString *)url) {
    RCTLogInfo(@"======进来了=======");
    [self.codeView showVerificationCodeView:url resultBlock:^(id result) {
        [self backResult:result];
        NSLog(@"最后返回的结果%@", result);
    }];
}

- (void)backResult:(NSDictionary *)result {
    if ([result[@"ret"] intValue] == 0) { //成功
        NSDictionary *dict = @{@"result": @"success",
                               @"ticket": result[@"ticket"]
                               };
        [self sendEventWithName:@"verifyResult" body:dict];
    } else { //失败
        NSDictionary *dict = @{@"result": @"fail"};
        [self sendEventWithName:@"verifyResult" body:dict];
    }
}

- (CodeView *)codeView {
    if (!_codeView) {
        _codeView = [[CodeView alloc] init];
    }
    return _codeView;
}

@end
