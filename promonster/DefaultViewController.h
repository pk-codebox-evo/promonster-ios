//
//  DefaultViewController.h
//  promonster
//
//  Created by Conrado on 28/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

#define IS_IOS7 [[UIDevice currentDevice].systemVersion hasPrefix:@"7"]

@interface DefaultViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate> {
    BOOL m_postingInProgress;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

- (NSString *) getEN_orderName: (NSString *) nameOrder;
- (void) backButtonCustom;
- (void) titleCustom;

@end
