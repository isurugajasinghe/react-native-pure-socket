//
//  MySocketSingleton.m
//  TestSocket
//
//  Created by Isuru Gajasinghe on 3/31/18.
//  Copyright © 2018 Epic Lanka. All rights reserved.
//

#import "MySocketSingleton.h"

@interface MySocketSingleton()<NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableArray *messages;

@end

static MySocketSingleton *_sharedGlobals;

@implementation MySocketSingleton

RCT_EXPORT_MODULE();

- (dispatch_queue_t) methodQueue
{
  return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventReminder"];
}

//+ (MySocketSingleton *)sharedGlobals {
//    @synchronized(self) {
//        if (_sharedGlobals == nil) {
//            _sharedGlobals = [[super allocWithZone:NULL] init];
//        }
//    }
//    return _sharedGlobals;
//}


RCT_EXPORT_METHOD(initNetworkCommunicationUrl:(NSString*)serveripString port:(NSInteger)port) {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)serveripString, (UInt32)port, &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
}

RCT_EXPORT_METHOD(sendString:(NSString*)message) {
    NSString *response  = message;
  
   // RCTLogInfo(@"Disconnect from room '%@'", message);

   // RCTLogInfo(@"message is: '%@");
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)messageReceived:(NSString *)message {
    
    [self.messages addObject:message];
//    if (self.delegate && [_delegate respondsToSelector:@selector(something:)]){
//        [_delegate something:message];
//    }
  [self sendEventWithName:@"EventReminder" body:@{@"message": message}];

    NSLog(@"message Received : %@",message);
}

#pragma mark stream delegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                NSUInteger len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                            
                        }
                    }
                }
            }
            break;
            
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host");
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}


@end
