//
//  WebService.m
//  promonster
//
//  Created by Conrado on 31/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "WebService.h"
#import "Parse.h"

#import "DejalActivityView.h"
#import "ProgressHUD.h"
#import "CSNotificationView.h"
#import "ProductDetail.h"
#import "UAAppReviewManager.h"

#import "CCAux.h"
#import "MainViewController.h"
#import "CreateCategoryViewController.h"
#import "StaredViewController.h"
#import "SearchViewController.h"
#import "CategoriesViewController.h"
#import "SetViewController.h"
#import "DetailProductViewController.h"
#import "HomeCell.h"
#import "DetailCell.h"
#import "SVModalWebViewController.h"

#define kSiteTerms @"http://www.promonster.com.br/termos"

#define kLINK @"http://promonster-app.appspot.com/"
#define kTIME 20
#define kCity @"noCity"
#define kBirthday @"00/00/0000"
#define dBUG NO

#define kForum @100
#define kDetail @212
#define kTip @104
#define kPros @58
#define kInfo @31
#define kShared @120

@implementation WebService
@synthesize indicator;
#pragma mark - Products
- (void) getProductsByOrder : (NSString *)order withDelegate: (MainViewController *) delegate {
    [self startDownloadInView:delegate.view];

    NSString *site = kLINK;
    site = [site stringByAppendingString:@"main?sort="];
    site = [site stringByAppendingString:order];
    
    if (dBUG) {
        NSLog(@"%@",site);
    }
    
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            BOOL start = [[NSUserDefaults standardUserDefaults] boolForKey:@"start"];
            if (!start) {
                NSURL *URL = [NSURL URLWithString:kSiteTerms];
                SVModalWebViewController *webViewController = [[SVModalWebViewController alloc]
                                                               initWithURL:URL];
                webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
                webViewController.barsTintColor = [UIColor blackColor];
                [delegate presentViewController:webViewController animated:YES completion:NULL];
                
                [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:@"start"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSDictionary *infoArray = [response valueForKey:@"products"];
            Parse *parse = [[Parse alloc] init];
            delegate.info = [parse parseProductFromDic:infoArray];

            [delegate.tableView reloadData];
            [delegate.refreshControl endRefreshing];

        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [delegate.refreshControl endRefreshing];
        delegate.failLoad = YES;
        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}
- (void) getProductDetailWithPromo_ID: (NSString *)promo_id withDelegate: (DetailProductViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [UAAppReviewManager userDidSignificantEvent:YES];

    NSString *site = kLINK;
    site = [site stringByAppendingString:@"promoJson/"];
    site = [site stringByAppendingString:promo_id];

    if (dBUG) {
        NSLog(@"%@",site);
    }
    
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            
            NSMutableArray *elements = [NSMutableArray array];
            NSDictionary *element;
            
            NSDictionary *infoArray = [response valueForKey:@"product"];
            Parse *parse = [[Parse alloc] init];
            
            element = @{@"name":@"DetailCell", @"height":kDetail};
            [elements addObject:element];

            delegate.produto = [parse parseProductDetailFromDic:infoArray];


            if (delegate.produto.tip) {
                element = @{@"name":@"TipCell", @"height":kTip};
                [elements addObject:element];
            }
            
            element = @{@"name":@"ForumCell", @"height":kForum};
            [elements addObject:element];
            
            int contPros = (int)[delegate.produto.pros count];
            int contContras = (int)[delegate.produto.cons count];
            int cont = 0;
            if (contPros > contContras) {
                cont += contPros;
            } else {
                cont += contContras;
            }
            if (cont !=0) {
                element = @{@"name":@"ProsConsCell", @"height":kPros};
                [elements addObject:element];
            }
            for (int i = 0; i<cont; i++) {
                element = @{@"name":@"infoCell", @"height":kInfo };
                [elements addObject:element];
            }
            element = @{@"name":@"SharedCell", @"height":kShared};
            [elements addObject:element];
            
            
            delegate.contCons = contContras;
            delegate.contPros = contPros;
            delegate.itens = elements;
            [delegate.tableView reloadData];
            delegate.tableView.hidden = NO;
            [delegate.refreshControl endRefreshing];
            
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [delegate.refreshControl endRefreshing];
        delegate.tableView.hidden = NO;

        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}

- (void) getProductsByName: (NSString *)name andOrder: (NSString *)order withDelegate: (MainViewController *) delegate {
    [self startDownloadInView:delegate.view];
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    NSString *site = kLINK;
    site = [site stringByAppendingString:@"category?"];
    
    site = [site stringByAppendingString:@"custom="];
    if (delegate.custom) {
        site = [site stringByAppendingString:@"1"];
    } else {
        site = [site stringByAppendingString:@"0"];
    }
    
    site = [site stringByAppendingString:@"&"];

    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&"];
    }
        
    site = [site stringByAppendingString:@"name="];
    site = [site stringByAppendingString:[self encodeURIComponent:name]];
    site = [site stringByAppendingString:@"&sort="];
    site = [site stringByAppendingString:order];
    
    if (dBUG) {
        NSLog(@"%@",site);
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            NSDictionary *infoArray = [response valueForKey:@"products"];
            Parse *parse = [[Parse alloc] init];
            delegate.info = [parse parseProductFromDic:infoArray];
            [delegate.tableView reloadData];
            [delegate.refreshControl endRefreshing];
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [delegate.refreshControl endRefreshing];

        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}

#pragma mark - Search
- (void) searchProductByQuery: (NSString *)query andOrder: (NSString *)order withDelegate: (SearchViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Buscando"];

    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    NSString *site = kLINK;
    site = [site stringByAppendingString:@"search"];

    site = [site stringByAppendingString:@"?query="];
    query = [self encodeURIComponent:query];
    site = [site stringByAppendingString:query];
    site = [site stringByAppendingString:@"&sort="];
    site = [site stringByAppendingString:order];
    
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"&user_id="];
        NSString *user_id = [CCAux getUserID];
        site = [site stringByAppendingString:user_id];
    }
    
    if (dBUG) {
        NSLog(@"%@",site);
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        NSString *message = [responseObject objectForKey:@"message"];
        if ([response count]!=0) {
            if (![message isEqualToString:@"Pesquisa Vazia"]) {
                NSDictionary *infoArray = [response valueForKey:@"products"];
                Parse *parse = [[Parse alloc] init];
                delegate.info = [parse parseProductFromDic:infoArray];
                if ([delegate.info count]!=0) {
                    delegate.tableView.hidden = NO;
                    [delegate.tableView reloadData];
                    [delegate hideKeyboard];
                    delegate.navigationItem.title = [delegate.searchBar.text uppercaseString];
                } else {
                    delegate.tableView.hidden = YES;
                }
                if ([message isEqualToString:@"Nenhuma promoção encontrada"]) {
                   
                    delegate.tableView.hidden = YES;
                    [CSNotificationView showInViewController:delegate
                                                       style:CSNotificationViewStyleError
                                                     message:message];
                    delegate.navigationItem.title = @"BUSCAR";

                }
                

                
            } else {
                [CSNotificationView showInViewController:delegate
                                                    style:CSNotificationViewStyleError
                                                 message:message];
                delegate.navigationItem.title = @"BUSCAR";
                delegate.tableView.hidden = YES;
 
            }
            [delegate.refreshControl endRefreshing];
        } else {
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [delegate.refreshControl endRefreshing];
        delegate.navigationItem.title = @"BUSCAR";


        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}


#pragma mark - Category
- (void) getListCategorieWithDelegate: (CategoriesViewController *) delegate {
    [self startDownloadInView:delegate.view];
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"categories?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&"];

    } else {
        site = [site stringByAppendingString:@"categories?"];
    }
    site = [site stringByAppendingString:@"device_id="];
    site = [site stringByAppendingString:[CCAux getDeviceID]];
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            NSDictionary *infoArray = [response valueForKey:@"categories"];
            Parse *parse = [[Parse alloc] init];
            delegate.info = [parse parseCategorieFromDic: infoArray];
            delegate.tableView.hidden = NO;
            [delegate.tableView reloadData];
            [delegate.refreshControl endRefreshing];

        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [delegate.refreshControl endRefreshing];

        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}
#pragma mark - Favoritos
- (void) getListFavoritesOrder: (NSString *) order andDelegate: (StaredViewController *) delegate {
    [self startDownloadInView:delegate.view];

    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    site = [site stringByAppendingString:@"favorites?"];

    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
    }
    site = [site stringByAppendingString:@"&sort="];
    site = [site stringByAppendingString:order];
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            NSDictionary *infoArray = [response valueForKey:@"products"];
            if ([infoArray count]!=0) {
                Parse *parse = [[Parse alloc] init];
                delegate.info = [parse parseProductFromDic: infoArray];
                [delegate hiddenNoFav];
                [delegate.tableView reloadData];
            } else {
                [delegate showNoFav];

            }
            [delegate.refreshControl endRefreshing];

        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
        [delegate.refreshControl endRefreshing];
    }];
    [manager.operationQueue addOperation:operation];
}

#pragma mark - DeleteCategory
- (void) deleteCategoryName: (NSString *) name andDelegate: (CategoriesViewController *) delegate forCell: (UITableViewCell *)cell {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Removendo"];

    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"category/delete?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&name="];
        site = [site stringByAppendingString:[self encodeURIComponent:name]];
    } else {
        NSLog(@"Error = usuario nao logado");
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            NSString *message = [responseObject objectForKey:@"message"];
            
            if ([status isEqual:@"OK"]) {
                NSIndexPath *cellIndexPath = [delegate.tableView indexPathForCell:cell];
                [delegate.info removeObjectAtIndex:cellIndexPath.row];
                [delegate.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:message];
            } else {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleError
                                                 message:message];
            }

        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
       // [delegate.refreshControl endRefreshing];
    }];
    [manager.operationQueue addOperation:operation];
}
#pragma mark - CreateCategory
- (void) createCategory: (CreateCategories *) category andDelegate: (CreateCategoryViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Criando categoria"];
    delegate.isSalve = YES;

    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"category/new?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&name="];
        site = [site stringByAppendingString:[self encodeURIComponent:category.name]];
        site = [site stringByAppendingString:@"&color="];
        site = [site stringByAppendingString:[self encodeURIComponent:category.color]];
        site = [site stringByAppendingString:@"&keywords_in="];
        site = [site stringByAppendingString:[self encodeURIComponent:category.stringIn]];
        site = [site stringByAppendingString:@"&keywords_out="];
        site = [site stringByAppendingString:[self encodeURIComponent:category.stringOut]];

    } else {
        [CSNotificationView showInViewController:delegate
                                           style:CSNotificationViewStyleError
                                         message:@"Usuário não logado!"];
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
          //  NSLog(@". %@",responseObject);
            NSString *status = [responseObject objectForKey:@"status"];
            NSString *message = [responseObject objectForKey:@"message"];
            
            if ([status isEqual:@"OK"]) {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:message];
                delegate.delegate.update = YES;
                [delegate retractKeyboard];
                
                [self performSelector:@selector(goHomeWithDelegate: ) withObject:delegate.navigationController afterDelay:0];

                
                
            } else {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleError
                                                 message:message];
            }
            delegate.isSalve = NO;

        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        delegate.isSalve = NO;

        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}
#pragma mark - Edit Category GET
- (void) editCategoryGET: (Categories *) category andDelegate: (CategoriesViewController *) delegate forCell: (SWTableViewCell *) cell {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Baixando info"];

    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"category/edit?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&name="];
        site = [site stringByAppendingString:[self encodeURIComponent:category.name]];
    } else {
        NSLog(@"Error = usuario nao logado");
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];

    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = responseObject;
        if ([response count]!=0) {
            NSLog(@". %@",response);
       
            [cell hideUtilityButtonsAnimated:YES];
            CreateCategories *cat = [[CreateCategories alloc] init];
            cat.color = [response objectForKey:@"color"];
            cat.name = [responseObject objectForKey:@"name"];
            cat.wordsOut = [responseObject objectForKey:@"keywords_out"];
            cat.wordsIn = [responseObject objectForKey:@"keywords_in"];
            
            [delegate openView:cat];
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
    }];
    [manager.operationQueue addOperation:operation];
}

#pragma mark - Edit Category POST
- (void) editCategoryPOST: (CreateCategories *) category andDelegate: (CreateCategoryViewController *) delegate  {
    delegate.isSalve = YES;
    [self startDownloadInView:delegate.view];
    [delegate retractKeyboard];

    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Salvando"];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"category/edit"];
    } else {
        NSLog(@"Error = usuario nao logado");
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"\n\n\n\n- name: %@ \ncolor:%@ \niN:%@ \nout:%@ - userid %@",category.name,category.color, category.stringIn, category.stringOut,[CCAux getUserID]);
    NSDictionary *params = @{@"user_id": [CCAux getUserID],
                             @"name" : category.name,
                             @"color": category.color,
                             @"keywords_in": category.stringIn,
                             @"keywords_out":category.stringOut
                             };
                             
                             [manager POST:site parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                [self doneDownload];
                                 NSString *message = [responseObject objectForKey:@"message"];
                                 NSString *status  = [responseObject objectForKey:@"status"];
                                 if ([status isEqualToString:@"OK"]) {
                                     [CSNotificationView showInViewController:delegate
                                                                        style:CSNotificationViewStyleSuccess
                                                                      message:message];
                                     delegate.delegate.update = YES;
                                     [delegate.navigationController popToRootViewControllerAnimated:YES];
                                 }else {
                                     [CSNotificationView showInViewController:delegate
                                                                        style:CSNotificationViewStyleError
                                                                      message:message];
                                 }
                                 delegate.isSalve = NO;

                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [CSNotificationView showInViewController:delegate
                                                                    style:CSNotificationViewStyleError
                                                                  message:@"Falha na comunicação"];
                                 [self doneDownload];
                                 NSLog(@"Error: %@", error);
                                 delegate.isSalve = NO;

                             }];
}
#pragma mark - POST LOGOFF
- (void) makeLogOff: (SetViewController *)delegate  {
    [self startDownloadInView:delegate.view];
    
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Saindo.."];
    
    NSString *site = kLINK;

    site = [site stringByAppendingString:@"turnOffPush"];

    if (dBUG) {
        NSLog(@"%@",site);
    }
    manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"user_id": [CCAux getUserID],
                             @"device_id" : [CCAux getDeviceID]
                             };
    
    [manager POST:site parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self doneDownload];
        NSString *message = [responseObject objectForKey:@"message"];
        NSString *status  = [responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"OK"]) {
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleSuccess
                                             message:message];
        }else {
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleError
                                             message:message];
        }
        
        delegate.notifyAction.enabled = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CSNotificationView showInViewController:delegate
                                           style:CSNotificationViewStyleError
                                         message:@"Falha na comunicação"];
        [self doneDownload];
        NSLog(@"Error: %@", error);
    }];
}
- (void) pushOnService: (UserLogin *) user andDelegate: (SetViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Habilitando notificações..."];
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    
    NSString *username = [self encodeURIComponent:user.name];
    NSString *social_id = user.social_id;
    NSString *city = [self encodeURIComponent:user.city];
    NSString *birthday = [self encodeURIComponent:user.birthday];
    NSString *email = user.email;
    
    if (!city) {
        city = kCity;
    }
    if (!birthday) {
        birthday = kBirthday;
    }
    if (!email) {
        email = @"user@user.com";
    }
    
    
    site = [site stringByAppendingString:@"login?source="];
    site = [site stringByAppendingString:user.source];
    site = [site stringByAppendingString:@"&username="];
    site = [site stringByAppendingString:username];
    site = [site stringByAppendingString:@"&gender="];
    site = [site stringByAppendingString:user.gender];
    site = [site stringByAppendingString:@"&birthday="];
    
    site = [site stringByAppendingString:birthday];
    site = [site stringByAppendingString:@"&city="];
    site = [site stringByAppendingString:city];
    site = [site stringByAppendingString:@"&social_id="];
    site = [site stringByAppendingString:social_id];
    site = [site stringByAppendingString:@"&email="];
    site = [site stringByAppendingString:email];
    
    site = [site stringByAppendingString:@"&social_token="];
    site = [site stringByAppendingString:user.accesTokenFB];
    
    NSString *pushToken = [CCAux getPushToken];
    NSLog(@"PUSH TOKEN: %@",pushToken);
    
    if (![pushToken isEqualToString:@"null"]) {
        site = [site stringByAppendingString:@"&push_token="];
        site = [site stringByAppendingString:pushToken];
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            NSString *status = [responseObject objectForKey:@"status"];
            NSString *message = [responseObject objectForKey:@"message"];
            NSString *user_id = [responseObject objectForKey:@"user_id"];
            [CCAux setUserID:user_id];
            
            if ([status isEqual:@"OK"]) {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:@"Notificações habilitadas"];
                [CCAux setNotifyEnable:NO];
            } else {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleError
                                                 message:message];
                [FBSession.activeSession closeAndClearTokenInformation];
            }
            
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
        [FBSession.activeSession closeAndClearTokenInformation];
        
        ///        [delegate.refreshControl endRefreshing];
        [self doneDownload];
    }];
    [manager.operationQueue addOperation:operation];
}

- (void) pushOffService: (SetViewController *)delegate  {
    [self startDownloadInView:delegate.view];
    
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Desabilitando..."];
    
    NSString *site = kLINK;
    
    site = [site stringByAppendingString:@"turnOffPush"];
    
    if (dBUG) {
        NSLog(@"%@",site);
    }
    manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"user_id": [CCAux getUserID],
                             @"device_id" : [CCAux getDeviceID]
                             };
    
    [manager POST:site parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self doneDownload];
        NSString *message = [responseObject objectForKey:@"message"];
        NSString *status  = [responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"OK"]) {
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleSuccess
                                             message:@"Notificações desabilitadas"];
            [CCAux setNotifyEnable:YES];
        }else {
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleError
                                             message:message];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CSNotificationView showInViewController:delegate
                                           style:CSNotificationViewStyleError
                                         message:@"Falha na comunicação"];
        [self doneDownload];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Favoritos
- (void) markStaredPromoID: (NSNumber *) promo_ID andDelegate: (MainViewController *) delegate andButton: (UIButton *) button andCell: (UITableViewCell *) cell{
    [self startDownloadInView:delegate.view];
    button.enabled = NO;
    
     indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat halfButtonHeight = button.bounds.size.height / 2;
    CGFloat buttonWidth = button.bounds.size.width+1;
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    indicator.color = [UIColor blackColor];
    [button addSubview:indicator];
    [indicator startAnimating];
    
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"favorite/new?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&promo_id="];
        site = [site stringByAppendingString:[NSString stringWithFormat:@"%@",promo_ID]];

        if (dBUG) {
            NSLog(@"%@",site);
        }
    
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
        [request setTimeoutInterval:kTIME];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *response = responseObject;
            if ([response count]!=0) {
               // NSLog(@"%@",responseObject);
                NSString *status = [responseObject objectForKey:@"status"];
                NSString *message = [responseObject objectForKey:@"message"];
                if ([status isEqual:@"OK"]) {

                    
                    [CSNotificationView showInViewController:delegate
                                                       style:CSNotificationViewStyleSuccess
                                                     message:message];
                    UIImage *image = [[UIImage imageNamed:@"hearth_selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
                    [button setImage:image forState:UIControlStateNormal];
                    
                    [self performSelector:@selector(oldImageButton: ) withObject:button afterDelay:0.2];
                    NSArray *itens = delegate.tabBarController.tabBar.items;
                    UITabBarItem *tab = [itens objectAtIndex:3];
                    NSString *value = tab.badgeValue;
                    if ([message isEqualToString:@"Promoção incluida aos favoritos"]) {
                        if (!value) {
                            [tab setBadgeValue:@"1" ];
                        } else {
                            int valor = (int)[value integerValue];
                            [tab setBadgeValue:[NSString stringWithFormat:@"%d",valor+1]];
                        }
                        if ([cell isMemberOfClass:[HomeCell class]] ) {
                            HomeCell *tmp = (HomeCell *) cell;
                            NSInteger num = [tmp.count_fav.text integerValue];
                            num = num+1;
                            tmp.count_fav.text = [NSString stringWithFormat:@"%ld",(long)num];
                            [tmp.count_fav setNeedsDisplay];
                        } else if ([cell isMemberOfClass:[DetailCell class]]){
                            DetailCell *tmp = (DetailCell *) cell;
                            NSInteger num = [tmp.contFav.text integerValue];
                            num = num+1;
                            tmp.contFav.text = [NSString stringWithFormat:@"%ld",(long)num];
                            [tmp.contFav setNeedsDisplay];
                        }
                        
                    }
                }
            } else {
                // vazio
            }
            [self doneDownload];
            button.enabled = YES;
            [indicator stopAnimating];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", operation.responseString);
            [self showErrorInView:delegate];
            button.enabled = YES;
            [indicator stopAnimating];
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleError
                                             message:@"Falha na comunicação"];
            
            
        }];
        [manager.operationQueue addOperation:operation];
    } else {
        NSLog(@"Error = usuario nao logado");
        button.enabled = YES;
        [indicator stopAnimating];
        [self doneDownload];
        [CCAux setLoginStatus:YES];
        [delegate.tabBarController setSelectedIndex:4];
    }
}
- (void) unMarkStaredPromoID: (NSNumber *) promo_ID andDelegate: (StaredViewController *) delegate andCell: (HomeCell *) cell {
    [self startDownloadInView:delegate.view];
    cell.likeButton.enabled = NO;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat halfButtonHeight = cell.likeButton.bounds.size.height / 2;
    CGFloat buttonWidth = cell.likeButton.bounds.size.width;
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    indicator.color = [UIColor blackColor];
    [cell.likeButton addSubview:indicator];
    [indicator startAnimating];
    
    
    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    if ([CCAux shouldSkipLogIn]) {
      //  NSLog(@"Esta logado - favorite");
        site = [site stringByAppendingString:@"favorite/delete?user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&promo_id="];
        site = [site stringByAppendingString:[NSString stringWithFormat:@"%@",promo_ID]];
       // NSLog(@"promo id: %@",promo_ID);
        
        if (dBUG) {
            NSLog(@"%@",site);
        }
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
        [request setTimeoutInterval:kTIME];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *response = responseObject;
            if ([response count]!=0) {
              ///  NSLog(@"... ?? ?%@",responseObject);
                NSString *status = [responseObject objectForKey:@"status"];
                NSString *message = [responseObject objectForKey:@"message"];
                if ([status isEqual:@"OK"]) {
                    
                    
                    [CSNotificationView showInViewController:delegate
                                                       style:CSNotificationViewStyleSuccess
                                                     message:message];

                   NSIndexPath *cellIndexPath = [delegate.tableView indexPathForCell:cell];

                    [delegate.info removeObjectAtIndex:cellIndexPath.row];
                    [delegate.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

                }
                
                
                // delegate.info = [parse parseProductFromDic: infoArray];
                //[delegate.tableView reloadData];
                //[delegate.refreshControl endRefreshing];
            } else {
                // vazio
            }
            [self doneDownload];
            cell.likeButton.enabled = YES;
            [indicator stopAnimating];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", operation.responseString);
            [self showErrorInView:delegate];
            cell.likeButton.enabled = YES;
            [indicator stopAnimating];
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleError
                                             message:@"Falha na comunicação"];
            
            
        }];
        [manager.operationQueue addOperation:operation];
    } else {
        NSLog(@"Error = usuario nao logado");
        cell.likeButton.enabled = YES;
        [indicator stopAnimating];
        [self doneDownload];
        [CCAux setLoginStatus:YES];
        [delegate.tabBarController setSelectedIndex:4];
    }
}


- (void) oldImageButton: (UIButton *) likeButton {
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        likeButton.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [likeButton setImage:[UIImage imageNamed:@"hearth_unselected"] forState:UIControlStateNormal];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            likeButton.alpha = 1;
            
            [UIView commitAnimations];
        
        }
    }];
    
}

#pragma mark - Login
- (void) makeLogin: (UserLogin *) user andDelegate: (SetViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Baixando informações"];

    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    
    NSString *username = [self encodeURIComponent:user.name];
    NSString *social_id = user.social_id;
    NSString *city = [self encodeURIComponent:user.coordinate];
    NSString *city_id = [self encodeURIComponent:user.cityID];

    NSString *birthday = [self encodeURIComponent:user.age];
    NSString *email = user.email;
    
    if (!city) {
        city = kCity;
    }
    if (!city_id) {
        city_id = @"_null";
    }
    if (!birthday) {
        birthday = kBirthday;
    }
    if (!email) {
        email = @"user@user.com";
    }
    
    site = [site stringByAppendingString:@"login?source="];
    site = [site stringByAppendingString:user.source];
    site = [site stringByAppendingString:@"&username="];
    site = [site stringByAppendingString:username];
    site = [site stringByAppendingString:@"&gender="];
    site = [site stringByAppendingString:user.gender];
    site = [site stringByAppendingString:@"&birthday="];
    site = [site stringByAppendingString:birthday];
    site = [site stringByAppendingString:@"&city="];
    site = [site stringByAppendingString:city];
    site = [site stringByAppendingString:@"&city_id="];
    site = [site stringByAppendingString:city_id];
    site = [site stringByAppendingString:@"&social_id="];
    site = [site stringByAppendingString:social_id];
    site = [site stringByAppendingString:@"&email="];
    site = [site stringByAppendingString:email];
    
    site = [site stringByAppendingString:@"&social_token="];
    site = [site stringByAppendingString:user.accesTokenFB];

    NSString *pushToken = [CCAux getPushToken];
   // NSLog(@"PUSH TOKEN: %@",pushToken);

    if (![pushToken isEqualToString:@"null"]) {
        site = [site stringByAppendingString:@"&push_token="];
        site = [site stringByAppendingString:pushToken];
    }
    if (dBUG) {
        NSLog(@"%@",site);
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            NSString *status = [responseObject objectForKey:@"status"];
            NSString *message = [responseObject objectForKey:@"message"];
            NSString *user_id = [responseObject objectForKey:@"user_id"];
            [CCAux setUserID:user_id];

            if ([status isEqual:@"OK"]) {
                
                
                
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:message];
                
                [CCAux setShouldSkipLogIn:YES];
                delegate.notifyAction.enabled = YES;
                [delegate setTabBarItem];
                
            } else {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleError
                                                 message:message];
                [FBSession.activeSession closeAndClearTokenInformation];

            }
            
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
        [FBSession.activeSession closeAndClearTokenInformation];

///        [delegate.refreshControl endRefreshing];
        [self doneDownload];
    }];
    [manager.operationQueue addOperation:operation];
}
#pragma mark - NotifyEndPromo
- (void) notifyEndPromo: (NSString *) promo_id andDelegate: (DetailProductViewController *) delegate {
    [self startDownloadInView:delegate.view];
    [DejalBezelActivityView activityViewForView:delegate.view withLabel:@"Notificando.."];

    NSError *error;
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString *site = kLINK;
    site = [site stringByAppendingString:@"warn?"];

    if ([CCAux shouldSkipLogIn]) {
        site = [site stringByAppendingString:@"user_id="];
        site = [site stringByAppendingString:[CCAux getUserID]];
        site = [site stringByAppendingString:@"&"];

    } else {
        NSLog(@"Error = usuario nao logado");
    }
    site = [site stringByAppendingString:@"promo_id="];
    site = [site stringByAppendingString:promo_id];
    
    site = [site stringByAppendingString:@"&device_id="];
    site = [site stringByAppendingString:[CCAux getDeviceID]];
    
    if (dBUG) {
        NSLog(@"%@",site);
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:site relativeToURL:manager.baseURL] absoluteString] parameters:nil error:&error];
    [request setTimeoutInterval:kTIME];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject;
        if ([response count]!=0) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            NSString *message = [responseObject objectForKey:@"message"];
            
            if ([status isEqual:@"OK"]) {
     
                
                
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:message];
            } else {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleError
                                                 message:message];
            }
            
        } else {
            // vazio
        }
        [self doneDownload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
        [self showErrorInView:delegate];
        [self doneDownload];


    }];
    [manager.operationQueue addOperation:operation];
}

#pragma mark - Layout
- (void) startDownloadInView: (UIView *) view {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   // [DejalBezelActivityView activityViewForView:view withLabel:@"Atualizando"];
    //[ProgressHUD show:@"Atualizando.." Interaction:YES];

}

- (NSString *)encodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    return s;
}
- (void) doneDownload {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [DejalBezelActivityView removeViewAnimated:YES];
    //[ProgressHUD dismiss];
}
- (void) showErrorInView: (UIViewController *) view {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [DejalBezelActivityView removeViewAnimated:YES];    
    [CSNotificationView showInViewController:view
                                       style:CSNotificationViewStyleError
                                     message:@"Falha na comunicação"];
    
}

- (void) goHomeWithDelegate: (UINavigationController *)nav{
    [nav popToRootViewControllerAnimated:YES];
}
@end
