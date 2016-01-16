//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRequest.h"

@interface SocketRequestFabric : NSObject

+ (SocketRequest *)loginRequestWithLogin:(NSString *)login password:(NSString *)password listener:(RequestListener)listener;

@end