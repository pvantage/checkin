//
//  CustomListCell.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/11/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblID;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStaticID;
@property (strong, nonatomic) IBOutlet UILabel *lblStaticPurchased;
@property (strong, nonatomic) IBOutlet UIImageView *imgDetails;
@end
