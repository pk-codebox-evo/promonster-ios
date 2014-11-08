//
//  DetailProductViewController.h
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetail.h"
#import "WebService.h"
#import "DefaultViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailProductViewController : DefaultViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    BOOL hasForum;
    int contProsTemp;
    int contConsTemp;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ProductDetail *produto;
@property (nonatomic, retain) WebService *service;

@property (nonatomic, retain) NSMutableArray *itens;
@property (nonatomic, retain) NSString *promo_id;

@property (nonatomic) int contItens;
@property (nonatomic) int contPros;
@property (nonatomic) int contCons;
@property (nonatomic) BOOL showAct;

- (void) sharedEmailProduct;
- (void) showActionSheet;
- (void) download;
@end
