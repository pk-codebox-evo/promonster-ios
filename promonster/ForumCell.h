//
//  ForumCell.h
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailProductViewController.h"

@interface ForumCell : UITableViewCell

@property (nonatomic, retain) DetailProductViewController *delegate;
@property (strong, nonatomic) IBOutlet UIView *bgrView;

@property (strong, nonatomic) IBOutlet UIButton *urlpromoButton;
@property (strong, nonatomic) IBOutlet UIButton *urlForumButton;

@property (nonatomic, retain) NSString *promo_url;
@property (nonatomic, retain) NSString *forum_url;

- (void) sourceSite;
- (void) forumSite;

@end
