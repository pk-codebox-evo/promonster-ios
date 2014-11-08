//
//  Parse.h
//  promonster
//
//  Created by Conrado on 31/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCKeyValueObjectMapping.h>
#import <DCParserConfiguration.h>
#import <DCObjectMapping.h>

#import "Product.h"
#import "ProductDetail.h"
#import "CreateCategories.h"


/**
 *  Performs parse the JSON received from WebService
 */
@interface Parse : NSObject

- (NSMutableArray *) parseProductFromDic: (NSDictionary *) dict;
- (ProductDetail *) parseProductDetailFromDic: (NSDictionary *) dict;
- (NSMutableArray *) parseCategorieFromDic: (NSDictionary *) dict;
- (CreateCategories *) parseCreateCategorieFromDic: (NSDictionary *) dict;

@end
