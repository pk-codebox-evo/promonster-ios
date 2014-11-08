//
//  SearchViewController.h
//  promonster
//
//  Created by Conrado on 01/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "DefaultViewController.h"
#import "WebService.h"

@interface SearchViewController : DefaultViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) WebService *service;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *orderButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *ordeByeLabel;
@property (weak, nonatomic) IBOutlet UILabel *option;

@property (nonatomic, strong) NSMutableArray *filteredTableData;
@property (nonatomic, strong) NSArray *info;

- (void) download;
- (void) hideKeyboard;
@end
