//
//  MainViewController.m
//  WSExample
//
//  Created by Denis Zabozhanov on 14.01.16.
//  Copyright © 2016 Denis Zabozhanov. All rights reserved.
//

#import "MainViewController.h"
#import "ServerAPI.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtLog;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.txtLog.text  = [ServerAPI instance].tokenExpirationDate.description;
}


@end
