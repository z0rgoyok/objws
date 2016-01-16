//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketResponse.h"

typedef void (^RequestListener)(SocketResponse *response, NSError *error);

@interface SocketRequest : NSObject

@property (readonly) NSString *sequenceId;
@property NSString *type;
@property NSDictionary *data;
@property (copy) RequestListener listener;

- (instancetype)initWithSequenceId:(NSString *)sequenceId type:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener;
+ (instancetype)requestWithSequenceId:(NSString *)sequenceId type:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener;

- (instancetype)initWithType:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener;

+ (instancetype)requestWithType:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener;


@end