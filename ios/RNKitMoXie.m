//
//  RNKitMoXie.m
//  RNKitMoXie
//
//  Created by aevit on 2018/1/2.
//  Copyright © 2018年 aevit. All rights reserved.
//

#import "RNKitMoXie.h"
#import "MoxieSDK.h"

@interface RNKitMoXie () <MoxieSDKDelegate>
@end

@implementation RNKitMoXie

#define RNKIT_MOXIE_LOGIN_DONE @"loginDone"

RCT_EXPORT_MODULE(RNKitMoXie)

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents {
    return @[RNKIT_MOXIE_LOGIN_DONE];
}

RCT_EXPORT_METHOD(initial:(NSString*)userId apiKey:(NSString*)apiKey) {
    NSAssert(userId && apiKey, @"RNKitMoXie: missing userId or apiKey");
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].userId = userId;
    [MoxieSDK shared].apiKey = apiKey;
    [MoxieSDK shared].useNavigationPush = NO;
    [MoxieSDK shared].fromController = [RNKitMoXie getTopViewController];
}

RCT_EXPORT_METHOD(start:(NSString*)functionName) {
    NSAssert(functionName, @"RNKitMoXie: missing functionName");
    [MoxieSDK shared].taskType = functionName;
    [[MoxieSDK shared] start];
}

#pragma MoxieSDK Delegate
- (void)receiveMoxieSDKResult:(NSDictionary *)resultDictionary {
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
//    NSString *message = resultDictionary[@"message"];
//    NSString *account = resultDictionary[@"account"];
//    BOOL loginDone = [resultDictionary[@"loginDone"] boolValue];
//    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,message:%@,account:%@, loginDone:%d",code,taskType,taskId,message,account,loginDone);
    // 假如code是2则继续查询该任务进展
    if (code == 2) {
    }
    // 假如code是1则成功
    else if (code == 1) {
        [self sendEventWithName:RNKIT_MOXIE_LOGIN_DONE body:@{ @"functionName": taskType, @"taskId": taskId }];
    }
    // 用户没有做任何操作
    else if (code == -1) {
    }
    //该任务失败按失败处理
    else {
    }
}

#pragma mark - private methods
+ (UIViewController *)getTopViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self topVisibleViewController:rootViewController];
}

+ (UIViewController *)topVisibleViewController:(UIViewController*)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topVisibleViewController:((UITabBarController *)vc).selectedViewController];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topVisibleViewController:((UINavigationController *)vc).visibleViewController];
        
    } else if (vc.presentedViewController) {
        return [self topVisibleViewController:vc.presentedViewController];
        
    } else if (vc.childViewControllers.count > 0) {
        return [self topVisibleViewController:vc.childViewControllers.lastObject];
    }
    return vc;
}

@end
