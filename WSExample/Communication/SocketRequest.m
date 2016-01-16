//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import "SocketRequest.h"


@implementation SocketRequest {

}
- (instancetype)initWithSequenceId:(NSString *)sequenceId type:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener {
    self = [super init];
    if (self) {
        _sequenceId = sequenceId;
        self.type = type;
        self.data = data;
        self.listener = listener;
    }
    return self;
}

- (instancetype)initWithType:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener {
    self = [super init];
    if (self) {
        self.type = type;
        self.data = data;
        self.listener = listener;
        _sequenceId = [self uuidString];
    }

    return self;
}

+ (instancetype)requestWithType:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener {
    return [[self alloc] initWithType:type data:data listener:listener];
}


+ (instancetype)requestWithSequenceId:(NSString *)sequenceId type:(NSString *)type data:(NSDictionary *)data listener:(RequestListener)listener {
    return [[self alloc] initWithSequenceId:sequenceId type:type data:data listener:listener];
}

- (NSString *)uuidString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidString;
}
@end