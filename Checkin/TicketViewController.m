//
//  TicketViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/12/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController {
    NSArray *checkinsArray;
}
@synthesize btnCheckin;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnCheckin.layer.cornerRadius = 4;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    checkinsArray = @[
                      @{@"data": @{@"date_checked": @"2014-12-30 12:48:27", @"status": @"Pass"}},
                      @{@"data": @{@"date_checked": @"2014-12-30 13:24:20", @"status": @"Pass"}},
                      @{@"data": @{@"date_checked": @"2014-12-30 13:24:19", @"status": @"Pass"}},
                      @{@"data": @{@"date_checked": @"2014-12-30 13:24:22", @"status": @"Pass"}}
                    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)checkin:(id)sender {
    
    NSLog(@"Check In");
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [checkinsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"checkinsCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", checkinsArray[indexPath.row][@"data"][@"date_checked"], checkinsArray[indexPath.row][@"data"][@"status"]];
    
    return cell;
}

@end
