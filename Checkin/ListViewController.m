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

@interface ListViewController ()

@end

@implementation ListViewController {
    NSArray *listItems;
}
@synthesize btnBurger;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [btnBurger setTarget: self.revealViewController];
        [btnBurger setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    listItems = @[
                  @{@"name": @"Marko Kraljević", @"id": @"32DE89B562-1", @"date": @"08.01.2015"},
                  @{@"name": @"Mitar Mirić", @"id": @"88BA89B521-5", @"date": @"12.01.2015"},
                  @{@"name": @"Petar Mojsilović", @"id": @"26133481E6-1", @"date": @"30.12.2014"},
                  @{@"name": @"Djuro Ostojić", @"id": @"26133481E6-1", @"date": @"10.01.2015"},
                  @{@"name": @"Aleksandar Makedonski", @"id": @"26133481E6-1", @"date": @"11.12.2014"}
                ];
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
        
    cell.lblName.text = listItems[indexPath.row][@"name"];
    cell.lblID.text = listItems[indexPath.row][@"id"];
    cell.lblDate.text = listItems[indexPath.row][@"date"];
    
    if(indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:239.0/255.0 blue:242.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
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
