//
//  Shared.m
//  promonster
//
//  Created by Conrado on 12/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "Shared.h"
#import <Social/Social.h>

@implementation Shared
@synthesize delegate;


#pragma mark - Social
- (void) sharedFacebookProduct: (Product *)produto {
    NSLog(@"sharedFacebookProduct");
	//  Create an instance of the Tweet Sheet
	SLComposeViewController *facebookSheet = [SLComposeViewController
											  composeViewControllerForServiceType:
											  SLServiceTypeFacebook];
	
	// Sets the completion handler.  Note that we don't know which thread the
	// block will be called on, so we need to ensure that any required UI
	// updates occur on the main queue
	facebookSheet.completionHandler = ^(SLComposeViewControllerResult result) {
		switch(result) {
				//  This means the user cancelled without sending the Tweet
			case SLComposeViewControllerResultCancelled: {

				break;
            }
			case SLComposeViewControllerResultDone: {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:@"Produto compartilhado no Facebook!"];
				break;
            }
		}
	};
	
	//  Set the initial body of the Tweet
    NSString *description = @"Confere essa promonster. \uf609";
	[facebookSheet setInitialText:description];
    
    NSString *promo_id = [NSString stringWithFormat:@"%@",produto.promo_id];
    NSString *site = [self getSiteWithPromoID:promo_id];
	
	if (![facebookSheet addURL:[NSURL URLWithString:site]]){
		NSLog(@"Unable to add the URL!");
	}
	
	[delegate presentViewController:facebookSheet animated:NO completion:^{
	}];
}

- (void) sharedTwitterProduct: (Product *)produto{
    SLComposeViewController *tweetSheet = [SLComposeViewController
										   composeViewControllerForServiceType:
										   SLServiceTypeTwitter];
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
		switch(result) {
				//  This means the user cancelled without sending the Tweet
			case SLComposeViewControllerResultCancelled:
				break;
				//  This means the user hit 'Send'
			case SLComposeViewControllerResultDone:{
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:@"Produto compartilhado no Twitter!"];
				break;
            }
		}
	};
	
    
	//  Set the initial body of the Tweet
    
    NSString *description = [self getDescription:produto];
    description = [description stringByAppendingString:@"\n"];
    
    
	[tweetSheet setInitialText:description];

    NSString *promo_id = [NSString stringWithFormat:@"%@",produto.promo_id];
    NSString *site = [self getSiteWithPromoID:promo_id];
    
	//  Add an URL to the Tweet.  You can add multiple URLs.
	if (![tweetSheet addURL:[NSURL URLWithString:site]]){
		NSLog(@"Unable to add the URL!");
	}
	
	//  Presents the Tweet Sheet to the user
	[delegate presentViewController:tweetSheet animated:NO completion:^{
	}];
}


- (void) sharedFacebookPromonster {
    NSLog(@"sharedFacebookProduct");
	//  Create an instance of the Tweet Sheet
	SLComposeViewController *facebookSheet = [SLComposeViewController
											  composeViewControllerForServiceType:
											  SLServiceTypeFacebook];
	
	// Sets the completion handler.  Note that we don't know which thread the
	// block will be called on, so we need to ensure that any required UI
	// updates occur on the main queue
	facebookSheet.completionHandler = ^(SLComposeViewControllerResult result) {
		switch(result) {
				//  This means the user cancelled without sending the Tweet
			case SLComposeViewControllerResultCancelled:
                
				break;
				//  This means the user hit 'Send'
                
			case SLComposeViewControllerResultDone: {
                [CSNotificationView showInViewController:delegate
                                                   style:CSNotificationViewStyleSuccess
                                                 message:@"Compartilhado com sucesso!"];
				break;
            }
		}
	};
	
	//  Set the initial body of the Tweet
    
    
    NSString *description = @"Estou usando o Promonster e achando preços incríveis!\nBaixe também!";
	[facebookSheet setInitialText:description];
    
    NSString *site = @"http://www.promonster.com.br";
	
	if (![facebookSheet addURL:[NSURL URLWithString:site]]){
		NSLog(@"Unable to add the URL!");
	}
	
	[delegate presentViewController:facebookSheet animated:NO completion:^{
	}];
}

#pragma mark - Aux
- (NSString *) getDescription: (Product*) produto  {
    NSString *text = produto.name;
    text = [text stringByAppendingString:@"\nPreço: R$ "];
    NSString *price = [NSString stringWithFormat:@"%@",produto.price];
    text = [text stringByAppendingString:price];
    return text;
}
- (NSString *) getSiteWithPromoID: (NSString *) promo_id {
    NSString *site = @"http://www.promonster.com.br/promo/";
    site = [site stringByAppendingString:promo_id];
    return site;
}

@end
