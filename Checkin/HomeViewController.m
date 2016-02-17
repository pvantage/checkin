//
//  HomeViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/10/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSUserDefaults *defaults;
    __weak IBOutlet UILabel *lblSoldTickets;
    __weak IBOutlet UILabel *lblCheckedIn;
}
@synthesize btnBurger;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [btnBurger setTarget: self.revealViewController];
        [btnBurger setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    lblCheckedIn.text = @"";
    lblSoldTickets.text = @"";
    lblSoldTickets.transform = CGAffineTransformMakeRotation(3.14/2);
    lblCheckedIn.transform = CGAffineTransformMakeRotation(3.14/2);
    NSLog(@"Will APEAR");
}

- (void)viewDidAppear:(BOOL)animated
{
    lblCheckedIn.text = [defaults objectForKey:@"CHECKED_IN_TICKETS"];
    lblSoldTickets.text = [defaults objectForKey:@"SOLD_TICKETS"];
    self.navigationItem.title = [defaults objectForKey:@"APP_TITLE"];
    
    [self checkLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)checkLogin
{
    if(![defaults boolForKey:@"logged"]) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    } else {
        [self eventDetails];
    }
}

-(void)eventDetails
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/event_essentials?ct_json", [defaults stringForKey:@"baseUrl"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
//        NSLog(@"%@",responseObject);

        self.lblSold.text = [NSString stringWithFormat:@"%@", responseObject[@"sold_tickets"]];
        self.lblCheckins.text =  [NSString stringWithFormat:@"%@", responseObject[@"checked_tickets"]];
        
        [defaults setObject:responseObject[@"event_name"] forKey:@"eventName"];
        [defaults setObject:responseObject[@"event_date_time"] forKey:@"eventDateTime"];
        [defaults setObject:responseObject[@"sold_tickets"] forKey:@"soldTickets"];
        [defaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[defaults objectForKey:@"ERROR"] message:[defaults objectForKey:@"ERROR_LOADING_DATA"] delegate:self cancelButtonTitle:[defaults objectForKey:@"OK"] otherButtonTitles:nil];
        [alert show];
    }];

}

@end
