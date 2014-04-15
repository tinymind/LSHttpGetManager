//
//  NSURLConnectionWithTag.h
//
//
//  Created by lslin on 14-4-15.
//  Copyright (c) 2014年 lessfun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionWithTag : NSURLConnection

@property (nonatomic, strong) id tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(id)tag;

@end
