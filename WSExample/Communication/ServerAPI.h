//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRequest.h"

@interface ServerAPI : NSObject

+ (ServerAPI *)instance;

/**
 * Возвращает дату окончания токена или nil если входа не было
 */
@property NSDate *tokenExpirationDate;
@property NSString *token;
- (BOOL)isLoggedIn;

- (void)authWithLogin:(NSString *)login password:(NSString *)password listener:(RequestListener)listener;
- (void)addRequest:(SocketRequest *)request;
@property (readonly) BOOL isConnected;

@end