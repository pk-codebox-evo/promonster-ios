//
//  DetailCell.h
//  promonster
//
//  Created by Conrado on 18/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLabel.h"
#import "DownloadImage.h"
#import "DetailProductViewController.h"
@interface DetailCell : UITableViewCell

@property (nonatomic, retain) DetailProductViewController *delegate;
@property (strong, nonatomic) IBOutlet DownloadImage *img_url;

@property (strong, nonatomic) IBOutlet UIView *viewBackgroundCell;
@property (strong, nonatomic) IBOutlet UIView *bgrView;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *name;

@property (strong, nonatomic) IBOutlet CCLabel *oldPrice;
@property (strong, nonatomic) IBOutlet CCLabel *contFav;
@property (strong, nonatomic) IBOutlet CCLabel *source;
@property (strong, nonatomic) IBOutlet CCLabel *price;
@property (strong, nonatomic) IBOutlet CCLabel *date;

@property (nonatomic, retain) NSString *price_mean;
@property (nonatomic, retain) NSNumber *promo_id;
@property (nonatomic, retain) NSString *link;

- (IBAction)sharedButton:(UIButton *)sender;
- (IBAction)forumSiteButton:(id)sender;
- (void) setStrikeLine;

@end
