//
//  StaredViewController.h
//  promonster
//
//  Created by Conrado on 01/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "DefaultViewController.h"
#import "CCLabel.h"
@interface StaredViewController : DefaultViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *monsterFav;

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderBy;
@property (weak, nonatomic) IBOutlet CCLabel *fav;

@property (nonatomic, retain) NSMutableArray *info;

- (IBAction)optionButton:(UIButton *)sender;
- (void) hiddenNoFav;
- (void) showNoFav;
@end
