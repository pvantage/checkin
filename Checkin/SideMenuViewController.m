//
//  SideMenuViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/10/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController {
    NSUserDefaults *defaults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    self.lblEventTitle.text = [defaults stringForKey:@"eventName"];
    self.lblEventSubtitle.text = [defaults stringForKey:@"eventDateTime"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLabelsWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle
{
    NSLog(@"pozvan");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"signOut"]) {
        [defaults setObject:NO forKey:@"autoLogin"];
        [defaults setBool:NO forKey:@"logged"];
        [defaults synchronize];
    }
}


@end
