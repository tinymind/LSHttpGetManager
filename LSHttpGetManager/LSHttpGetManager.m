//
//  LSHttpGetManager.m
//
//
//  Created by lslin on 14-4-15.
//  Copyright (c) 2014年 lessfun.com. All rights reserved.
//

#import "LSHttpGetManager.h"
#import "NSURLConnectionWithTag.h"


@interface LSHttpInfo : NSObject

@property (strong, nonatomic) NSString          *url;
@property (strong, nonatomic) NSURLConnection   *connection;
@property (strong, nonatomic) NSURLResponse     *response;
@property (strong, nonatomic) NSMutableData     *receivedData;
@property (copy, nonatomic) HttpCompletion      completionBlock;
@property (copy, nonatomic) HttpProgress        progressBlock;

@end

//==============================

@implementation LSHttpInfo

@end

//============================================================


static LSHttpGetManager* _httpInstance = nil;

@interface LSHttpGetManager()
{
    NSMutableDictionary *_urlByTag;                 //key: tag; value: url
    NSMutableDictionary *_dataFromConnectionsByTag; //key: tag; value: data
    NSMutableDictionary *_connectionByTag;          //key: tag; value: connection
    NSMutableDictionary *_completionBlockByTag;     //key: tag; value: block
    NSMutableDictionary *_responseByTag;            //key: tag; value: response
    NSMutableDictionary *_progressBlockByTag;       //key: tag; value: block
}

@property (strong, nonatomic) NSMutableDictionary *httpInfoByTag;//key: (id)tag; value: (LSHttpInfo)httpData

@end

//==============================

@implementation LSHttpGetManager

+ (LSHttpGetManager *)sharedObject
{
    @synchronized(self) {
        
        if (!_httpInstance) {
            _httpInstance = [[LSHttpGetManager alloc] init];
        }
    }
    return _httpInstance;
}

- (id)init
{
    if (self = [super init]) {
        _httpInfoByTag = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)sendHttpRequestWithUrl:(NSString *)url taskKey:(id)taskKey completion:(HttpCompletion)completion
{
    if (!completion) {
        return;
    }
    
    [self sendHttpRequestWithUrl:url taskKey:taskKey completion:completion progress:nil];
}

- (void)sendHttpRequestWithUrl:(NSString *)url taskKey:(id)taskKey completion:(HttpCompletion)completion progress:(HttpProgress)progress
{
    if (!completion) {
        return;
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [self sendHttpRequest:request taskKey:taskKey completion:completion progress:progress];
}

- (void)sendHttpRequest:(NSURLRequest *)request taskKey:(id)taskKey completion:(HttpCompletion)completion
{
    if (!completion) {
        return;
    }
    [self sendHttpRequest:request taskKey:taskKey completion:completion progress:nil];
}

- (void)sendHttpRequest:(NSURLRequest *)request taskKey:(id)taskKey completion:(HttpCompletion)completion progress:(HttpProgress)progress;
{
    NSLog(@"[HM] - LSHttpGetManager sendHttpRequest:[%@], taskKey:[%@]", request.URL.absoluteString, taskKey);
    
    //cancel last task with taskKey
    LSHttpInfo *info = [self.httpInfoByTag objectForKey:taskKey];
    if (info && info.connection) {
        [self cancelRequestWithTaskKey:taskKey];
    }
    
    if (!info) {
        info = [[LSHttpInfo alloc] init];
    }
    info.url = request.URL.absoluteString;
    info.completionBlock = completion;
    info.progressBlock = progress;
    
    NSURLConnection *connection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:taskKey];
    info.connection = connection;
    [self.httpInfoByTag setObject:info forKey:taskKey];
}

- (void)cancelRequestWithTaskKey:(id)taskKey
{
    if (taskKey) {
        LSHttpInfo *info = [self.httpInfoByTag objectForKey:taskKey];
        if (info && info.connection) {
            [info.connection cancel];
            [self removeObjectForTaskKey:taskKey];
            NSLog(@"LSHttpGetManager cancelRequestWithTaskKey::[%@]", taskKey);
        }
    }
}

- (void)removeObjectForTaskKey:(id)taskKey
{
    [self.httpInfoByTag removeObjectForKey:taskKey];
}

#pragma mark - NSURLConnection delegate

// support SSL
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
    //   if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    LSHttpInfo *info = [self.httpInfoByTag objectForKey:((NSURLConnectionWithTag*)connection).tag];
    info.response = response;
}

- (void)connection:(NSURLConnectionWithTag *)connection didReceiveData:(NSData *)data
{
    // save data
    LSHttpInfo *info = [self.httpInfoByTag objectForKey:connection.tag];
    if (info.receivedData == nil) {
        info.receivedData = [[NSMutableData alloc] initWithData:data];
    } else {
        [info.receivedData appendData:data];
    }
   
    // tell the progress
    if (info.progressBlock) {
        info.progressBlock(connection.tag, info.receivedData.length, info.response.expectedContentLength);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"LSHttpGetManager didFailWithError");
    [self handleConnection:connection withError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self handleConnection:connection withError:nil];
}

- (void)handleConnection:(NSURLConnection *)connection withError:(NSError *)error
{
    id tag = [(NSURLConnectionWithTag *)connection tag];
    if (!tag) {
        return;
    }

    LSHttpInfo *info = [self.httpInfoByTag objectForKey:tag];
    if (info.url) {
        NSLog(@"LSHttpGetManager handleConnection, url:[%@], taskKey:[%@], error:%@", info.url, tag, error);
        
        if (info.completionBlock) {
            info.completionBlock(!error, info.receivedData, error);
        }
    }
    
    [self removeObjectForTaskKey:tag];
}

@end
