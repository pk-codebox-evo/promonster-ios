//
//  Product.h
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, retain) NSNumber *promo_id;
@property (nonatomic, retain) NSString *price_mean;
@property (nonatomic, retain) NSString *favorites_count;

@end
