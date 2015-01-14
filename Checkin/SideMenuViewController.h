//
//  SideMenuViewController.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/10/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface SideMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEventSubtitle;

@property (strong, nonatomic) NSString *locTitle;
@property (strong, nonatomic) NSString *locSubtitle;

@end

