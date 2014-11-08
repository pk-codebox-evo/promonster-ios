//
//  MainViewController.h
//  promonster
//
//  Created by Conrado on 25/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "DefaultViewController.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "WebService.h"
#import "Product.h"


@interface MainViewController : DefaultViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    BOOL disapearWithNavigation;
    BOOL viewDidAppear;
    BOOL loadAgain;
}
@property (nonatomic) BOOL start;
@property (nonatomic) BOOL custom;
@property (nonatomic) BOOL failLoad;

@property (nonatomic, retain) NSMutableArray *info;
@property (nonatomic, retain) WebService *service;
@property (nonatomic, retain) NSString *name;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *orderButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *option;

- (void) sharedEmailProduct: (Product *) produto;
- (void) setSelectedIndex: (int) index;
- (void) download;
@end
