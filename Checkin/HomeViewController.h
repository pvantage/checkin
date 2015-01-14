//
//  HomeViewController.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/10/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBurger;
@property (weak, nonatomic) IBOutlet UIView *viewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblSold;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckins;

@end
