//
// Created by Denis Zabozhanov on 16.01.16.
// Copyright (c) 2016 Denis Zabozhanov. All rights reserved.
//

#import "ServerAPI.h"
#import "SRWebSocket.h"
#import "SocketRequestFabric.h"

NSString *const c_token_expiration = @"token_expiration";
NSString *const c_token = @"token";

@interface ServerAPI () <SRWebSocketDelegate>
@property SRWebSocket *socket;
@property NSString *url;

@property NSMutableArray *requestQueue;
@property SocketRequest *currentRequest;
@property NSMutableDictionary *requestsIds;

@end

@implementation ServerAPI {

}
+ (ServerAPI *)instance {
    static ServerAPI *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.url = @"ws://52.29.182.220:8080/customer-gateway/customer";
        self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:self.url]];
        self.socket.delegate = self;
        self.requestsIds = [NSMutableDictionary dictionary];
        self.requestQueue = [NSMutableArray array];
        [self connect];
    }
    return self;
}
- (void)connect {
    [self.socket open];
}

- (BOOL)isLoggedIn {
    return [ServerAPI instance].tokenExpirationDate &&
            ([[ServerAPI instance].tokenExpirationDate compare:[NSDate date]] == NSOrderedAscending);
}


- (NSDate *)tokenExpirationDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:c_token_expiration];
}

- (void)setTokenExpirationDate:(NSDate *)tokenExpirationDate {
    [[NSUserDefaults standardUserDefaults] setObject:tokenExpirationDate forKey:c_token_expiration];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:c_token];
}

- (void)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:c_token];
}

- (void)authWithLogin:(NSString *)login password:(NSString *)password listener:(RequestListener)listener {
    SocketRequest *request = [SocketRequestFabric loginRequestWithLogin:login password:password listener:listener];
    [self addRequest:request];
}

- (void)addRequest:(SocketRequest *)request {
    [self.requestQueue addObject:request];
    [self processQueue];
}

- (void)processQueue {
    if (self.isConnected && !self.currentRequest && self.requestQueue.count > 0) {
        SocketRequest *request = self.requestQueue[0];
        NSError *error = [self processRequest:request];
        if (error) {
            request.listener(nil, error);
        }
    }
}

- (NSError *)processRequest:(SocketRequest *)request {
    NSDictionary *dict = @{
            @"type" : request.type,
            @"sequence_id" : request.sequenceId,
            @"data" : request.data
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        return error;
    } else {
        self.requestsIds[request.sequenceId] = request;
        [self.socket send:jsonData];
        return nil;
    }
}


- (void)closedWithCode:(NSInteger)code reason:(NSString *)reason error:(NSError *)error {
    for (SocketRequest *request in self.requestQueue) {
        if (!error) {
            error = [NSError errorWithDomain:@"" code:code userInfo:@{@"reason" : reason}];
        }
        request.listener(nil, error);
    }
    [self.requestQueue removeAllObjects];
    [self.requestsIds removeAllObjects];
}

#pragma mark SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *response = message;
    SocketResponse *socketResponse = [SocketResponse fromJson:message];
    SocketRequest *request = self.requestsIds[socketResponse.sequenceId];
    if (request) {
        request.listener(socketResponse, nil);
    }
    self.currentRequest = nil;
    [self.requestQueue removeObjectAtIndex:0];
    [self processQueue];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    _isConnected = YES;
    [self processQueue];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    _isConnected = NO;
    [self closedWithCode:-1 reason:nil error:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    _isConnected = NO;
    [self closedWithCode:code reason:reason error:nil];
}

@end