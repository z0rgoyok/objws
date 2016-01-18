//
//  LoginViewController.m
//  WSExample
//
//  Created by Denis Zabozhanov on 15.01.16.
//  Copyright © 2016 Denis Zabozhanov. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerAPI.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property(weak, nonatomic) IBOutlet UITextField *txtLogin;
@property(weak, nonatomic) IBOutlet UITextView *txtLog;
@property(weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([ServerAPI instance].tokenExpirationDate) {

    }
    self.btnLogin.enabled = NO;
}

- (IBAction)txtLoginChanged:(id)sender {
    self.btnLogin.enabled = [self validateEmailWithString:self.txtLogin.text];
}

- (BOOL)validateEmailWithString:(NSString*)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)btnLoginHandler:(id)sender {
    [[ServerAPI instance] authWithLogin:self.txtLogin.text password:self.txtPass.text listener:^(SocketResponse *response, NSError *error) {
        if (!error) {
            if (response.data[@"api_token"]) {
                [ServerAPI instance].token = response.data[@"api_token"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                [ServerAPI instance].tokenExpirationDate = [dateFormatter dateFromString:response.data[@"api_token_expiration_date"]];
                MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self presentViewController:mainViewController animated:YES completion:nil];

            } else {
                NSString *errorDescription = response.data[@"error_description"];
                self.txtLog.text = errorDescription;
            }
        } else {
            self.txtLog.text = error.userInfo[@"reason"];
        }
    }];
}

@end
