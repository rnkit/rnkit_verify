//
//  CodeView.h
//  RNKitSensor
//
//  Created by Snow on 2018/1/13.
//  Copyright © 2018年 SnowYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeView : NSObject

- (void)showVerificationCodeView:(NSString *)url
                     resultBlock:(void(^)(id result))resultBlock;

@end
