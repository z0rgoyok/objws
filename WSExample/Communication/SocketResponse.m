//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import "SocketResponse.h"


@implementation SocketResponse {

}

+ (SocketResponse *)fromJson:(NSString *)json {

    NSData *webData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    SocketResponse *response = [[SocketResponse alloc] init];
    response.type = jsonDict[@"type"];
    response.data = jsonDict[@"data"];
    response.sequenceId = jsonDict[@"sequence_id"];
    return response;
}

@end