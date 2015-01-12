//
//  LoginViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/12/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtApiKey, txtUrl, btnSignIn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    btnSignIn.layer.cornerRadius = 4;
    
    txtUrl.delegate = self;
    txtApiKey.delegate = self;
    
    txtUrl.layer.borderColor = [[UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:217.0/255.0 alpha:1.0] CGColor];
    txtApiKey.layer.borderColor = [[UIColor redColor] CGColor];
    
    txtUrl.layer.cornerRadius = 4;
    txtApiKey.layer.cornerRadius = 4;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [txtApiKey endEditing:YES];
    [txtUrl endEditing:YES];
}

- (IBAction)login:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
