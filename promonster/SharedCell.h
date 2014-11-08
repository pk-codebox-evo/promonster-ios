//
//  SharedCell.h
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailProductViewController.h"
@interface SharedCell : UITableViewCell

@property (nonatomic, retain) DetailProductViewController *delegate;

@property (strong, nonatomic) IBOutlet UIView *bgrView;

@property (strong, nonatomic) IBOutlet UIButton *sharedOutlet;
@property (strong, nonatomic) IBOutlet UIButton *notifyOutlet;

@property (nonatomic, retain) NSString *promo_id;

- (IBAction)notifyEndPromo:(UIButton *)sender;
- (IBAction)sharedButton:(UIButton *)sender;
@end
