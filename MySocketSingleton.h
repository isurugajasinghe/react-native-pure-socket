//
//  MySocketSingleton.h
//  TestSocket
//
//  Created by Isuru Gajasinghe on 3/31/18.
//  Copyright © 2018 Epic Lanka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@protocol SomethingDelegate <NSObject>
@optional
- (void)something:(NSString*)something;

@end

@interface MySocketSingleton : RCTEventEmitter <RCTBridgeModule>

//@property (nonatomic, weak) id <SomethingDelegate> delegate;

//+ (MySocketSingleton*)sharedGlobals;
//
//+ (void)initNetworkCommunicationUrl:(NSString*)serveripString port:(UInt32)port;
//+(void)sendString:(NSString*)message;

@end
