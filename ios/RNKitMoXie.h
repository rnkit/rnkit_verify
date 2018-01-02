//
//  RNKitMoXie.h
//  RNKitMoXie
//
//  Created by aevit on 2018/1/2.
//  Copyright © 2018年 aevit. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#else
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#endif

@interface RNKitMoXie : RCTEventEmitter <RCTBridgeModule>

@end
