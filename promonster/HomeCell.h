//
//  HomeCell.h
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadImage.h"
#import "GHContextMenuView.h"
#import "TabBarViewController.h"
#import "Product.h"
#import "MainViewController.h"
#import "StaredViewController.h"
#import "CCLabel.h"

#import "SWTableViewCell.h"

@interface HomeCell : UITableViewCell <GHContextOverlayViewDelegate, GHContextOverlayViewDataSource, UIActionSheetDelegate>
@property (nonatomic, retain) StaredViewController *delegate2;
@property (nonatomic, retain) MainViewController *delegate;
@property (weak, nonatomic) IBOutlet DownloadImage *img_url;

@property (weak, nonatomic) IBOutlet UIView *viewBackgroundCell;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *name;

@property (strong, nonatomic) IBOutlet CCLabel *count_fav;
@property (strong, nonatomic) IBOutlet CCLabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (nonatomic, retain) NSString *price_mean;
@property (nonatomic, retain) Product *produto;

- (IBAction)paperplanButton:(UIButton *)sender;
- (void) setStaredDelegate: (StaredViewController *) tempDelegate;
- (void) setDelegate: (MainViewController *) tempDelegate;
- (void) setProduto: (Product *)prod;
- (void) setStrikeLine;
- (void) setUnlike;
- (void) setLike;


@end
