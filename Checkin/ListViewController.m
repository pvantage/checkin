//
//  ListViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/11/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "CustomListCell.h"
#import "TicketViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>

@interface ListViewController ()

@end

@implementation ListViewController {
    NSMutableArray *listItems;
    NSUserDefaults *defaults;
}
@synthesize btnBurger, tblTickets;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    listItems = [NSArray array];
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
    
    [self loadTicketsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listItems count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    CustomListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@", listItems[indexPath.row][@"buyer_first"],listItems[indexPath.row][@"buyer_last"]];
    cell.lblID.text = listItems[indexPath.row][@"transaction_id"];
    cell.lblDate.text = listItems[indexPath.row][@"date"];
    
    if(indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:239.0/255.0 blue:242.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)loadTicketsList
{
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/tickets_info/20/1/?ct_json", [defaults stringForKey:@"baseUrl"]];
    [MBProgressHUD showHUDAddedTo:tblTickets animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:tblTickets animated:YES];
//        NSLog(@"%@",[responseObject class]);
//        listItems = [responseObject count];
//        listItems = [[NSMutableArray alloc] initWithArray:responseObject];
        listItems = [NSMutableArray array];
        unsigned int i;

        NSDateFormatter *printFormatter = [[NSDateFormatter alloc] init];
        [printFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy hh:mm a"];

        NSDate *dateObj;
        for (i=0; i < [responseObject count]-1; i++) {
            NSMutableDictionary *tempData = [responseObject objectAtIndex:i];
            NSMutableDictionary *tempObj = [tempData[@"data"] mutableCopy];

            dateObj = [dateFormatter dateFromString:tempObj[@"payment_date"]];
            [tempObj setValue:[printFormatter stringFromDate:dateObj] forKey:@"date"];
            [listItems addObject:tempObj];
        }
        
        
        [tblTickets reloadData];
        
//        NSLog(@"%@",listItems);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There is a problem in loading your data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TicketViewController *ticketVC = [segue destinationViewController];
    
    ticketVC.ticketData = [listItems objectAtIndex:[tblTickets indexPathForSelectedRow].row];
}

@end
