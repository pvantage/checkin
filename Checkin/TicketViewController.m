//
//  TicketViewController.m
//  Checkin
//
//  Created by Borislav Jagodic on 1/12/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import "TicketViewController.h"
#import "TicketCustomFieldsTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>

@interface TicketViewController ()

@end

@implementation TicketViewController {
    NSArray *checkinsArray;
    NSArray *customFieldsArray;
    NSUserDefaults *defaults;
    __weak IBOutlet UILabel *lblIDStatic;
    __weak IBOutlet UILabel *lblPurchased;
    __weak IBOutlet UILabel *lblCheckins;
    __weak IBOutlet UINavigationItem *navItem;
}
@synthesize btnCheckin, tblCheckins, lblDate, lblHolderName, lblID, ticketData, imgStatusIcon, lblStatusText, lblStatusTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    navItem.title = [defaults objectForKey:@"APP_TITLE"];
    
    btnCheckin.layer.cornerRadius = 4;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    lblHolderName.text = ticketData[@"name"];
    lblID.text = ticketData[@"checksum"];
    lblDate.text = ticketData[@"date"];
    
    lblPurchased.text = [defaults objectForKey:@"PURCHASED"];
    lblIDStatic.text = [defaults objectForKey:@"ID"];
    lblCheckins.text = [defaults objectForKey:@"CHECKINS"];
    [btnCheckin setTitle:[defaults objectForKey:@"CHECK_IN"] forState:UIControlStateNormal];
    
//TEST ONLY
//    customFieldsArray = @[
//                          @[@"Ticket Type:", @"VIP"],
//                          @[@"Buyer Name:", @"Hanke Beckett"],
//                          @[@"Buyer E-mail:", @"example@gmail.com"],
//                        ];
    
    customFieldsArray = [[NSArray alloc] initWithArray:ticketData[@"custom_fields"]];
    self.viewOverlay.layer.cornerRadius = 5;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self ticketCheckins];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)overlayClose:(id)sender
{
    [self.viewOverlayWrapper setHidden:YES];
}

- (void)showOverlayWithStatus:(BOOL)status
{
    if(status == YES) {
        imgStatusIcon.image = [UIImage imageNamed:@"success"];
        lblStatusTitle.text = [defaults objectForKey:@"SUCCESS"];
        lblStatusText.text = [defaults objectForKey: @"SUCCESS_MESSAGE"];
    } else {
        imgStatusIcon.image = [UIImage imageNamed:@"error"];
        lblStatusTitle.text = [defaults objectForKey:@"ERROR"];
        lblStatusText.text = [defaults objectForKey:@"ERROR_MESSAGE"];
    }
    [self.viewOverlayWrapper setHidden:NO];
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
    
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/check_in/%@?ct_json", [defaults stringForKey:@"baseUrl"], ticketData[@"checksum"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"CHECKIN RESPONSE %@", responseObject);
        
        [self ticketCheckins];
        if ([responseObject[@"status"] isEqualToNumber:@0]) {
            [self showOverlayWithStatus:NO];
        } else {
            [self showOverlayWithStatus:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showOverlayWithStatus:NO];
    }];
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
    if (tableView == self.tblCheckins) {
        return [checkinsArray count];
    } else {
        return [customFieldsArray count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblCheckins) {
        NSString *cellIdentifier = @"checkinsCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", checkinsArray[indexPath.row][@"data"][@"date_checked"], checkinsArray[indexPath.row][@"data"][@"status"]];
        
        if ([tableView respondsToSelector:@selector(layoutMargins)]) {
            tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(layoutMargins)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        return cell;
    } else {
        NSString *cellIdentifier = @"customFieldCell";
        TicketCustomFieldsTableViewCell *ticketCell = (TicketCustomFieldsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        ticketCell.lblKey.text = [customFieldsArray[indexPath.row] objectAtIndex:0];
        ticketCell.lblValue.text = [customFieldsArray[indexPath.row] objectAtIndex:1];
        
        
        if ([tableView respondsToSelector:@selector(layoutMargins)]) {
            tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([ticketCell respondsToSelector:@selector(layoutMargins)]) {
            ticketCell.layoutMargins = UIEdgeInsetsZero;
        }
        
        
        
        return ticketCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblCustomFields) {
        return 44;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblCustomFields) {
        return 44;
    } else {
        return 30;
    }
}

#pragma mark - Network
-(void)ticketCheckins
{
    NSString *requestedUrl = [NSString stringWithFormat:@"%@/ticket_checkins/%@?ct_json", [defaults stringForKey:@"baseUrl"], ticketData[@"checksum"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        checkinsArray = [[NSArray alloc] initWithArray:responseObject];
        
        NSLog(@"CHECLKINS ARRAY %@", checkinsArray);
        NSLog(@"CHECKINS NUMBER %lu", (unsigned long)[checkinsArray count]);
        
        [tblCheckins reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[defaults objectForKey: @"ERROR"] message: [defaults objectForKey: @"ERROR_LOADING_DATA"] delegate:self cancelButtonTitle:[defaults objectForKey: @"OK"] otherButtonTitles:nil];
        [alert show];

    }];
}

@end
