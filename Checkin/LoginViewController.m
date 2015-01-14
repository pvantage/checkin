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
    
    txtUrl.layer.cornerRadius = 4;
    txtApiKey.layer.cornerRadius = 4;
    
    txtUrl.text = [defaults stringForKey:@"url"];
    txtApiKey.text = [defaults stringForKey:@"apiKey"];
    
    
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
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"%@",responseObject[@"pass"]);
            
            // Store data to user defaults
            if([responseObject[@"pass"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [defaults setObject:url forKey:@"url"];
                [defaults setObject:apiKey forKey:@"apiKey"];
                [defaults setObject:baseUrl forKey:@"baseUrl"];
                
                if(autoLogin.on) {
                    [defaults setBool:YES forKey:@"autoLogin"];
                } else {
                    [defaults setBool:NO forKey:@"autoLogin"];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eror" message:@"The API Key and/or URL is wrong!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [defaults setBool:NO forKey:@"autoLogin"];
            }
            [defaults synchronize];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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
