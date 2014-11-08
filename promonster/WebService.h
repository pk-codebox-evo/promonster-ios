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

- (void) getProductsByOrder : (NSString *)order
                withDelegate: (UIViewController *) delegate;

- (void) getProductDetailWithPromo_ID: (NSString *)promo_id
                         withDelegate: (UIViewController *) delegate;

- (void) searchProductByQuery: (NSString *)query
                     andOrder: (NSString *)order
                 withDelegate: (UIViewController *) delegate;

- (void) getProductsByName: (NSString *)name
                  andOrder: (NSString *)order
              withDelegate: (UIViewController *) delegate;

- (void) getListCategorieWithDelegate: (UIViewController *) delegate;

- (void) getListFavoritesOrder: (NSString *) order
                   andDelegate: (UIViewController *) delegate;

- (void) deleteCategoryName: (NSString *) name
                andDelegate: (UIViewController *) delegate
                    forCell: (UITableViewCell *)cell;

- (void) markStaredPromoID: (NSNumber *) promo_ID
               andDelegate: (UIViewController *) delegate
                 andButton: (UIButton *) button
                   andCell: (UITableViewCell *) cell ;

- (void) makeLogin: (UserLogin *) user
       andDelegate: (UIViewController *) delegate;

- (void) oldImageButton: (UIButton *) likeButton;

- (void) notifyEndPromo: (NSString *) promo_id
            andDelegate: (UIViewController *) delegate;

- (void) createCategory: (CreateCategories *) category
            andDelegate: (UIViewController *) delegate ;

- (void) editCategoryGET: (Categories *) category
             andDelegate: (UIViewController *) delegate
                 forCell: (UITableViewCell *) cell;

- (void) editCategoryPOST: (CreateCategories *) category
              andDelegate: (UIViewController *) delegate;

- (void) unMarkStaredPromoID: (NSNumber *) promo_ID
                 andDelegate: (UIViewController *) delegate
                     andCell: (UITableViewCell *) cell;

- (void) makeLogOff: (UIViewController *)delegate ;

- (void) pushOffService: (UIViewController *)delegate;

- (void) pushOnService: (UserLogin *) user
           andDelegate: (UIViewController *) delegate;
@end