//
//  WebService.h
//  promonster
//
//  Created by Conrado on 31/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//


/**
 *  Class that performs communication with the WebService
 */
#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UserLogin.h"
#import "FacebookSDK/FacebookSDK.h"
#import "CreateCategories.h"
@interface WebService : NSObject <FBViewControllerDelegate>{
    AFHTTPRequestOperationManager *manager;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIViewController *delegate;

- (void) getProductsByOrder: (NSString *)order;

- (void) getProductDetailWithPromo_ID: (NSString *)promo_id;

- (void) searchProductByQuery: (NSString *)query
                     andOrder: (NSString *)order;

- (void) getProductsByName: (NSString *)name
                  andOrder: (NSString *)order;

- (void) getListCategorie;

- (void) getListFavoritesOrder: (NSString *) order;

- (void) deleteCategoryName: (NSString *) name
                andDelegate: (UIViewController *) delegate
                    forCell: (UITableViewCell *)cell;

- (void) markStaredPromoID: (NSNumber *) promo_ID
               andDelegate: (UIViewController *) delegate
                 andButton: (UIButton *) button
                   andCell: (UITableViewCell *) cell ;

- (void) makeLogin: (UserLogin *) user;

- (void) oldImageButton: (UIButton *) likeButton;

- (void) notifyEndPromo: (NSString *) promo_id andDelegate: (UIViewController *) delegate;

- (void) createCategory: (CreateCategories *) category;

- (void) editCategoryGET: (Categories *) category
             andDelegate: (UIViewController *) delegate
                 forCell: (UITableViewCell *) cell;

- (void) editCategoryPOST: (CreateCategories *) category;

- (void) unMarkStaredPromoID: (NSNumber *) promo_ID
                 andDelegate: (UIViewController *) delegate
                     andCell: (UITableViewCell *) cell;

- (void) makeLogOff;

- (void) pushOffService;
- (void) pushOnService: (UserLogin *) user;
@end