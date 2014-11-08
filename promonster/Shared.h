//
//  Shared.h
//  promonster
//
//  Created by Conrado on 12/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "MainViewController.h"
#import "CSNotificationView.h"
@interface Shared : UIViewController
@property (nonatomic, retain) UIViewController *delegate;

- (void) sharedFacebookProduct: (Product *)produto;
- (void) sharedTwitterProduct: (Product *)produto;

- (NSString *) getSiteWithPromoID: (NSString *) promo_id;
- (NSString *) getDescription: (Product*) produto;
- (void) sharedFacebookPromonster;
@end
