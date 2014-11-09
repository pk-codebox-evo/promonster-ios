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


/**
 *  Share product information in facebook
 *
 *  @param product information (name, price, site)
 */
- (void) sharedFacebookProduct: (Product *)produto;

/**
 *  Share product information in Twitter
 *
 *  @param product information (name, price, site)
 */
- (void) sharedTwitterProduct: (Product *)produto;

/**
 * auxiliary functions
 */
- (NSString *) getSiteWithPromoID: (NSString *) promo_id;
- (NSString *) getDescription: (Product*) produto;

/**
 *  Shared App information in Facebook
 */
- (void) sharedFacebookPromonster;
@end
