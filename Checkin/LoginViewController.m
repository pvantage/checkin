//
//  LoginViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/12/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSUserDefaults *defaults;
    __weak IBOutlet UILabel *lblInstalationURL;
    __weak IBOutlet UILabel *lblApiKey;
    __weak IBOutlet UILabel *lblAutoLogin;
}
@synthesize autoLogin, txtApiKey, txtUrl, btnSignIn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    btnSignIn.layer.cornerRadius = 4;
    
    txtUrl.delegate = self;
    txtApiKey.delegate = self;
    
    txtUrl.layer.borderColor = [[UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:217.0/255.0 alpha:1.0] CGColor];
    txtApiKey.layer.borderColor = [[UIColor redColor] CGColor];
    
    self.viewUrl.layer.cornerRadius = 4;
    self.viewApi.layer.cornerRadius = 4;
    
    txtUrl.text = [defaults stringForKey:@"url"];
    txtApiKey.text = [defaults stringForKey:@"apiKey"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lblApiKey.text = [defaults valueForKey:@"API_KEY"];
    lblAutoLogin.text = [defaults valueForKey:@"AUTO_LOGIN"];
    lblInstalationURL.text = [defaults valueForKey:@"WORDPRESS_INSTALLATION_URL"];
    [btnSignIn setTitle:[defaults objectForKey:@"SIGN_IN"] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtApiKey endEditing:YES];
    [txtUrl endEditing:YES];
}

- (IBAction)login:(id)sender
{
//    NSError *jsonError;
    if([self inputValid]) {
        NSString *url = txtUrl.text;
        NSString *apiKey = txtApiKey.text;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *baseUrl = [NSString stringWithFormat:@"%@/tc-api/%@", url, apiKey];
        NSString *requestedUrl = [NSString stringWithFormat:@"%@/check_credentials?ct_json", baseUrl];
        
        if([NSURL URLWithString:requestedUrl] == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[defaults stringForKey:@"ERROR"] message:[defaults stringForKey:@"API_KEY_LOGIN_ERROR"] delegate:self cancelButtonTitle:[defaults stringForKey:@"OK"] otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"URL: %@", requestedUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            // Store data to user defaults
            if([responseObject[@"pass"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [defaults setObject:url forKey:@"url"];
                [defaults setObject:apiKey forKey:@"apiKey"];
                [defaults setObject:baseUrl forKey:@"baseUrl"];
                [defaults setBool:YES forKey:@"logged"];
                if(autoLogin.on) {
                    [defaults setBool:YES forKey:@"autoLogin"];
                } else {
                    [defaults setBool:NO forKey:@"autoLogin"];
                }
                
                NSString *translationURL = [NSString stringWithFormat:@"%@/translation?ct_json", baseUrl];

                
                [manager GET:translationURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Translation response obj: %@", responseObject);
                    if(responseObject[@"pass"] == nil) {
                        
                        [defaults setObject: responseObject[@"WORDPRESS_INSTALLATION_URL"] forKey:@"WORDPRESS_INSTALLATION_URL"];
                        [defaults setObject: responseObject[@"API_KEY"] forKey:@"API_KEY"];
                        [defaults setObject: responseObject[@"AUTO_LOGIN"] forKey:@"AUTO_LOGIN"];
                        [defaults setObject: responseObject[@"SIGN_IN"] forKey:@"SIGN_IN"];
                        [defaults setObject: responseObject[@"SOLD_TICKETS"] forKey:@"SOLD_TICKETS"];
                        [defaults setObject: responseObject[@"CHECKED_IN_TICKETS"] forKey:@"CHECKED_IN_TICKETS"];
                        [defaults setObject: responseObject[@"HOME_STATS"] forKey:@"HOME_STATS"];
                        [defaults setObject: responseObject[@"LIST"] forKey:@"LIST"];
                        [defaults setObject: responseObject[@"SIGN_OUT"] forKey:@"SIGN_OUT"];
                        [defaults setObject: responseObject[@"CANCEL"] forKey:@"CANCEL"];
                        [defaults setObject: responseObject[@"SEARCH"] forKey:@"SEARCH"];
                        [defaults setObject: responseObject[@"ID"] forKey:@"ID"];
                        [defaults setObject: responseObject[@"PURCHASED"] forKey:@"PURCHASED"];
                        [defaults setObject: responseObject[@"CHECKINS"] forKey:@"CHECKINS"];
                        [defaults setObject: responseObject[@"CHECK_IN"] forKey:@"CHECK_IN"];
                        [defaults setObject: responseObject[@"SUCCESS"] forKey:@"SUCCESS"];
                        [defaults setObject: responseObject[@"SUCCESS_MESSAGE"] forKey:@"SUCCESS_MESSAGE"];
                        [defaults setObject: responseObject[@"OK"] forKey:@"OK"];
                        [defaults setObject: responseObject[@"ERROR"] forKey:@"ERROR"];
                        [defaults setObject: responseObject[@"ERROR_MESSAGE"] forKey:@"ERROR_MESSAGE"];
                        [defaults setObject: responseObject[@"PASS"] forKey:@"PASS"];
                        [defaults setObject: responseObject[@"FAIL"] forKey:@"FAIL"];
                        [defaults setObject: responseObject[@"ERROR_LOADING_DATA"] forKey:@"ERROR_LOADING_DATA"];
                        [defaults setObject: responseObject[@"API_KEY_LOGIN_ERROR"] forKey:@"API_KEY_LOGIN_ERROR"];
                        [defaults setObject: responseObject[@"APP_TITLE"] forKey:@"APP_TITLE"];

                        
                        [defaults setBool:YES forKey:@"custom_translations"];
                        [defaults synchronize];
                    }
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"GRESKA NA TRANSLATE %@", error);
                }];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[defaults stringForKey:@"ERROR"] message:[defaults stringForKey:@"API_KEY_LOGIN_ERROR"] delegate:self cancelButtonTitle:[defaults stringForKey:@"OK"] otherButtonTitles:nil];
                [alert show];
                [defaults setBool:NO forKey:@"autoLogin"];
                [defaults setBool:NO forKey:@"logged"];
            }
            [defaults synchronize];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[defaults stringForKey:@"ERROR"] message:[defaults stringForKey:@"ERROR_LOADING_DATA"] delegate:self cancelButtonTitle:[defaults stringForKey:@"OK"] otherButtonTitles:nil];
            NSLog(@"ERROR: %@", error.localizedDescription);
            [alert show];
        }];
        
    }
}

-(BOOL)inputValid
{
    return YES;
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
