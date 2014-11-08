//
//  infoCell.h
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLabel.h"

@interface infoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet CCLabel *proText;
@property (strong, nonatomic) IBOutlet CCLabel *contText;
@property (strong, nonatomic) IBOutlet UIView *bgrView;

@end
