//
//  NSURLConnectionWithTag.m
//
//
//  Created by lslin on 14-4-15.
//  Copyright (c) 2014年 lessfun.com. All rights reserved.
//

#import "NSURLConnectionWithTag.h"

@implementation NSURLConnectionWithTag

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(NSNumber*)tag
{
    self = [super initWithRequest:request delegate:delegate];
    if (self) {
        _tag = tag;
    }
    return self;
}

@end
