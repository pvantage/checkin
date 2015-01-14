//
//  HomeViewController.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/10/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewControllerDelegate;

@interface HomeViewController : UIViewController

@property (weak, nonatomic) id<HomeViewControllerDelegate> homeDelegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBurger;
@property (weak, nonatomic) IBOutlet UIView *viewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblSold;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckins;

@property (nonatomic, assign) BOOL isLogout;
@property (strong, nonatomic) NSString *loFlag;

@end

@protocol HomeViewControllerDelegate <NSObject>

@optional
-(void)updateLabelsWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle;

@end
