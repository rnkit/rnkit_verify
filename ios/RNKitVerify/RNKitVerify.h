//
//  RNKitVerify.h
//  RNKitVerify
//
//  Created by Snow on 2018/1/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#import <React/RCTEventEmitter.h>

@interface RNKitVerify : RCTEventEmitter <RCTBridgeModule>

@end
