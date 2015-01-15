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
    NSArray *searchResults;
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
    
    searchResults = [NSArray array];
    
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
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [listItems count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    CustomListCell *cell = (CustomListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSDictionary *ticketDict;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ticketDict = [searchResults objectAtIndex:indexPath.row];
    } else {
        ticketDict = [listItems objectAtIndex:indexPath.row];
    }
        
    cell.lblName.text = [NSString stringWithFormat:@"%@", ticketDict[@"full_name"]];
    cell.lblID.text = ticketDict[@"transaction_id"];
    cell.lblDate.text = ticketDict[@"date"];
    
    if(indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:239.0/255.0 blue:242.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.selectionStyle = UITableViewCellStyleDefault;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetails" sender:nil];
}

-(void)loadTicketsList
{
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/tickets_info/%@/1/?ct_json", [defaults stringForKey:@"baseUrl"], [defaults stringForKey:@"soldTickets"]];
    [MBProgressHUD showHUDAddedTo:tblTickets animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:tblTickets animated:YES];
        listItems = [NSMutableArray array];

        NSDateFormatter *printFormatter = [[NSDateFormatter alloc] init];
        [printFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy hh:mm a"];
        NSDate *dateObj;
        
        unsigned int i;
        for (i=0; i < [responseObject count]-1; i++) {
            NSMutableDictionary *tempData = [responseObject objectAtIndex:i];
            NSMutableDictionary *tempObj = [tempData[@"data"] mutableCopy];

            dateObj = [dateFormatter dateFromString:tempObj[@"payment_date"]];
            [tempObj setValue:[printFormatter stringFromDate:dateObj] forKey:@"date"];
            [tempObj setValue:[NSString stringWithFormat:@"%@ %@", tempObj[@"buyer_first"], tempObj[@"buyer_last"]] forKey:@"full_name"];
            [listItems addObject:tempObj];
        }
        
        [tblTickets reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There is a problem in loading your data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];

}

#pragma mark - Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"full_name contains[c] %@", searchText];
    searchResults = [listItems filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"SEGUE");
    NSIndexPath *indexPath = nil;
    NSDictionary *ticketDict = nil;
    if (self.searchDisplayController.active) {
        NSLog(@"SEARCH ACTIVE");
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        ticketDict = [searchResults objectAtIndex:indexPath.row];
    } else {
        indexPath = [tblTickets indexPathForSelectedRow];
        ticketDict = [listItems objectAtIndex:indexPath.row];
    }
    
    TicketViewController *ticketVC = [segue destinationViewController];
    ticketVC.ticketData = ticketDict;
}

@end
