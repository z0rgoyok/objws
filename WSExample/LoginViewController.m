//
//  LoginViewController.m
//  WSExample
//
//  Created by Denis Zabozhanov on 15.01.16.
//  Copyright © 2016 Denis Zabozhanov. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerAPI.h"

@interface LoginViewController ()
@property(weak, nonatomic) IBOutlet UITextField *txtLogin;
@property(weak, nonatomic) IBOutlet UITextView *txtLog;
@property(weak, nonatomic) IBOutlet UITextField *txtPass;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([ServerAPI instance].tokenExpirationDate) {

    }
}

- (IBAction)btnLoginHandler:(id)sender {
    [[ServerAPI instance] authWithLogin:self.txtLogin.text password:self.txtPass.text listener:^(SocketResponse *response, NSError *error) {
        if (!error) {
            [ServerAPI instance].token = response.data[@"api_token"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [ServerAPI instance].tokenExpirationDate = [dateFormatter dateFromString:response.data[@"api_token_expiration_date"]];
        }
    }];
}

@end
