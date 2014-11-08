//
//  CategoriesViewController.h
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSNotificationView.h"
#import "DefaultViewController.h"
#import "SWTableViewCell.h"
#import "CreateCategories.h"
@interface CategoriesViewController: DefaultViewController  <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate> {
    BOOL disapearWithNavigation;
    BOOL viewDidAppear;
    BOOL loadAgain;
    BOOL log;
}

@property (strong, nonatomic) IBOutlet UIButton *createCategoryOutlet;
@property (nonatomic) BOOL update;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *info;

- (IBAction)createCategory:(UIButton *)sender;
- (void) openView: (CreateCategories *) cat;
@end
