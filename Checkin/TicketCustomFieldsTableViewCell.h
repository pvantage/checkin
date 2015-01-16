//
//  TicketCustomFieldsTableViewCell.h
//  Checkin
//
//  Created by Borislav Jagodic on 1/15/15.
//  Copyright (c) 2015 Krooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCustomFieldsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblKey;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end
