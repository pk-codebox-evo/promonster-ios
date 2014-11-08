//
//  ForumCell.m
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "ForumCell.h"
#import "SVModalWebViewController.h"


@implementation ForumCell
@synthesize urlpromoButton, promo_url, forum_url, urlForumButton, delegate;
- (void)awakeFromNib {
    [urlpromoButton addTarget:self action:@selector(sourceSite) forControlEvents:UIControlEventTouchUpInside];
    [self defineButton:urlpromoButton];
    
    [urlForumButton addTarget:self action:@selector(forumSite) forControlEvents:UIControlEventTouchUpInside];
    [self defineButton:urlForumButton];
    
    self.bgrView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMeio"]];
}

- (void) defineButton: (UIButton *) button {
    button.layer.cornerRadius = CGRectGetHeight(button.bounds) / 14;
    button.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:16.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) sourceSite {
    NSURL *URL = [NSURL URLWithString:promo_url];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.barsTintColor = [UIColor blackColor];
    webViewController.nameSiteGA = @"Source Screen";
    webViewController.title = @"Carregando...";
    [delegate presentViewController:webViewController animated:YES completion:NULL];
}

- (void) forumSite {
    NSURL *URL = [NSURL URLWithString:forum_url];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.barsTintColor = [UIColor blackColor];
    webViewController.nameSiteGA = @"Forum Screen";
    webViewController.title = @"Carregando...";
    [delegate presentViewController:webViewController animated:YES completion:NULL];
}

@end
