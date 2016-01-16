//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import "SocketRequestFabric.h"
#import "SocketRequest.h"


@implementation SocketRequestFabric {

}

+ (SocketRequest *)loginRequestWithLogin:(NSString *)login password:(NSString *)password listener:(RequestListener)listener {
    return [SocketRequest requestWithType:@"LOGIN_CUSTOMER" data:@{@"email" : login, @"password" : password} listener:listener];
}

@end