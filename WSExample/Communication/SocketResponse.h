//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocketResponse : NSObject


@property NSString *sequenceId;
@property NSString *type;
@property NSDictionary *data;

+ (SocketResponse *)fromJson:(NSString *)json;

@end