//
//  LSHttpGetManager.h
//  
//
//  Created by lslin on 14-4-15.
//  Copyright (c) 2014年 lessfun.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HttpCompletion)(BOOL succeed, NSData * recvData, NSError *error);
typedef void (^HttpProgress)(id taskKey, long long writeDataLength, long long expectedTotalLength);

@interface LSHttpGetManager : NSObject <NSURLConnectionDataDelegate>

+ (LSHttpGetManager *)sharedObject;

- (void)sendHttpRequestWithUrl:(NSString *)url taskKey:(id)taskKey completion:(HttpCompletion)completion;
- (void)sendHttpRequestWithUrl:(NSString *)url taskKey:(id)taskKey completion:(HttpCompletion)completion progress:(HttpProgress)progress;
- (void)sendHttpRequest:(NSURLRequest *)request taskKey:(id)taskKey completion:(HttpCompletion)completion;
- (void)cancelRequestWithTaskKey:(id)taskKey;

@end
