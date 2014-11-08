//
//  DetailCell.m
//  promonster
//
//  Created by Conrado on 18/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "DetailCell.h"
#import "MHFacebookImageViewer.h"
#import "SVModalWebViewController.h"

@implementation DetailCell
@synthesize name, viewBackgroundCell, delegate, promo_id, likeButton, price_mean;

- (void)awakeFromNib {
    [self setLayoutButton:name];
   // [self setBackgroud];
    self.viewBackgroundCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBackground"]];
   
    // Initialization code
    self.bgrView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMeio"]];
    [self displayImage:_img_url withImage:_img_url.image];

}
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void) setLayoutButton: (UIButton *)button {
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setUserInteractionEnabled:NO];
    button.autoresizesSubviews = YES;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button.titleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
    [button.titleLabel setNumberOfLines:3];
    [button setTitle:button.titleLabel.text forState:UIControlStateNormal];
    [self setDetailButton:button];
    
    [likeButton addTarget:self action:@selector(likeFunction) forControlEvents:UIControlEventTouchUpInside];
}
- (void) setStrikeLine {
    NSNumber *strikeSize = [NSNumber numberWithInt:1];
    
    NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                       forKey:NSStrikethroughStyleAttributeName];
    
    NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:price_mean attributes:strikeThroughAttribute];
    
    _oldPrice.attributedText = strikeThroughText;
}
- (void) setDetailButton: (UIButton *) button {
    button.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:15.f];
}
- (void) setBackgroud {
    self.viewBackgroundCell.backgroundColor = [UIColor redColor];
    viewBackgroundCell.layer.cornerRadius = CGRectGetHeight(viewBackgroundCell.bounds) / 18;
    viewBackgroundCell.layer.borderWidth = 0.6f;
    viewBackgroundCell.layer.borderColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f].CGColor;
    viewBackgroundCell.clipsToBounds = YES;
}
- (void) likeFunction {
    WebService *service = [[WebService alloc] init];
    [service markStaredPromoID:promo_id andDelegate:delegate andButton:likeButton andCell:self];
}
- (IBAction)sharedButton:(UIButton *)sender {
    [delegate showActionSheet];
}
- (IBAction)forumSiteButton:(id)sender {
    [self forumSite];
}
- (void) forumSite {
    NSURL *URL = [NSURL URLWithString:_link];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.barsTintColor = [UIColor blackColor];
    webViewController.title = @"Carregando...";
    webViewController.nameSiteGA = @"forum Screen";
    [delegate presentViewController:webViewController animated:YES completion:NULL];
}
@end
