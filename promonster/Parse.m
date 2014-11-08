//
//  Parse.m
//  promonster
//
//  Created by Conrado on 31/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "Parse.h"

@implementation Parse
- (ProductDetail *) parseProductDetailFromDic: (NSDictionary *) dict {
    
// KeyValueObjectMapping
    // https://github.com/dchohfi/KeyValueObjectMapping
    // Configurando Nome para Mapear
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    /* DCObjectMapping *eventConfig = [DCObjectMapping mapKeyPath:@"id"
     toAttribute:@"event_id"
     onClass:[FestivalEvent class]];
     
     [config addObjectMapping:eventConfig];*/
    
    
    // parsing do JSON -> Product Class
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[ProductDetail class] andConfiguration:config];
   
    ProductDetail *produto = [parser parseDictionary:dict];
    return produto;
}
- (NSMutableArray *) parseProductFromDic: (NSDictionary *) dict {
    
    // KeyValueObjectMapping
    // https://github.com/dchohfi/KeyValueObjectMapping
    // Configurando Nome para Mapear
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    /* DCObjectMapping *eventConfig = [DCObjectMapping mapKeyPath:@"id"
     toAttribute:@"event_id"
     onClass:[FestivalEvent class]];
     
     [config addObjectMapping:eventConfig];*/
    
    
    // parsing do JSON -> Product Class
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Product class] andConfiguration:config];
    
    NSMutableArray *productsArray = [NSMutableArray array];
    
    for (NSMutableDictionary *produtsDictArray in dict) {
        Product *produto = [parser parseDictionary:produtsDictArray];
        [productsArray addObject:produto];
    }
    return productsArray;
}
- (NSMutableArray *) parseCategorieFromDic:(NSDictionary *)dict {

    DCParserConfiguration *config = [DCParserConfiguration configuration];

    // parsing do JSON -> Categories Class
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Categories class] andConfiguration:config];
    NSMutableArray *categoriesArray = [NSMutableArray array];
    
    for (NSMutableDictionary *categoriesDictArray in dict) {
        Categories *categoria = [parser parseDictionary:categoriesDictArray];
        [categoriesArray addObject:categoria];
    }
    return categoriesArray;
}
- (CreateCategories *) parseCreateCategorieFromDic:(NSDictionary *)dict {
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    
    // parsing do JSON -> Categories Class
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[CreateCategories class] andConfiguration:config];
    CreateCategories *categoria;
    for (NSMutableDictionary *categoriesDictArray in dict) {
         categoria = [parser parseDictionary:categoriesDictArray];
    }
    return categoria;
}
@end
