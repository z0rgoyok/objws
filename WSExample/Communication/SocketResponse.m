//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import "SocketResponse.h"


@implementation SocketResponse {

}

+ (SocketResponse *)fromJson:(NSDictionary *)json {
    SocketResponse *response = [[SocketResponse alloc] init];
    response.type = json[@"type"];
    response.data = json[@"data"];
    response.sequenceId = json[@"sequence_id"];
    return response;
}

@end