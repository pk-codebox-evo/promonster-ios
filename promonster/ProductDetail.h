//
//  ProductDetail.h
//  promonster
//
//  Created by Conrado on 13/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "Product.h"

@interface ProductDetail : Product
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *favorites_count;
@property (nonatomic, retain) NSString *forum_url;
@property (nonatomic, retain) NSArray  *pros;
@property (nonatomic, retain) NSArray  *cons;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSString *tip;
@property (nonatomic, retain) NSString *promo_url;
@end
