//
//  TicketViewController.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/12/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;

@end
