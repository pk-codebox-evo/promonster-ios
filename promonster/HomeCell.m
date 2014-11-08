//
//  HomeCell.m
//  promonster
//
//  Created by Conrado on 29/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "HomeCell.h"
#import "WebService.h"
#import "MainViewController.h"
#import "CCAux.h"
#import "Shared.h"
#import "MHFacebookImageViewer.h"

@implementation HomeCell
@synthesize viewBackgroundCell, name, delegate, delegate2, likeButton;
@synthesize produto, price_mean, count_fav;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    
    [self.imageView setUserInteractionEnabled:YES];
    [self addGestureRecognizer:_longPressRecognizer];
    
    [self setBackgroud];
    [self setNameButton];
}


- (void) setStrikeLine {
    NSNumber *strikeSize = [NSNumber numberWithInt:1];
    
    NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                       forKey:NSStrikethroughStyleAttributeName];
    
    NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:price_mean attributes:strikeThroughAttribute];
    
    _oldPrice.attributedText = strikeThroughText;
}
- (void) setNameButton {
    [name setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [name setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [name setUserInteractionEnabled:NO];
    name.autoresizesSubviews = YES;
    name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [name.titleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
    [name.titleLabel setNumberOfLines:3];
    
    [name setTitle:name.titleLabel.text forState:UIControlStateNormal];
    self.name.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:15.f];
}
- (void) setBackgroud {
    self.viewBackgroundCell.backgroundColor = [UIColor whiteColor];
    viewBackgroundCell.layer.cornerRadius = CGRectGetHeight(viewBackgroundCell.bounds) / 18;
    viewBackgroundCell.layer.borderWidth = 0.6f;
    viewBackgroundCell.layer.borderColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f].CGColor;
    viewBackgroundCell.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)paperplanButton:(UIButton *)sender {
    [self showActionSheet];
}

- (NSInteger) numberOfMenuItems {
    return 4;
}

#pragma mark - GHContextMenu Delegate
-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"facebook-white";
            break;
        case 1:
            imageName = @"twitter-white";
            break;
        case 2:
            imageName = @"hearth-white";
            break;
        case 3:
            imageName = @"email-white";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    Shared *share = [[Shared alloc] init];
    share.delegate = delegate;

    switch (selectedIndex) {
        case 0:
            [share sharedFacebookProduct:produto];

            break;
        case 1:
            [share sharedTwitterProduct:produto];
            break;
        case 2:
        {
            [self likeFunction];
            break;
        }
        case 3:
        {
            [delegate sharedEmailProduct:produto];
            break;
        }
        default:
            break;
    }
    
    
}
- (void) setProduto: (Product *)prod {
    produto = prod;
}

#pragma mark - Functions Like and Unlike

- (void) likeFunction {
    WebService *service = [[WebService alloc] init];
    [service markStaredPromoID:produto.promo_id andDelegate:delegate andButton:likeButton andCell:self];
}
- (void) unLikeFunction {
    WebService *service = [[WebService alloc] init];
    [service unMarkStaredPromoID:produto.promo_id andDelegate:delegate2 andCell:self];
}
- (void) setUnlike {
    [likeButton addTarget:self action:@selector(unLikeFunction) forControlEvents:UIControlEventTouchUpInside];
    
    [likeButton setImage:[UIImage imageNamed:@"trash_selected"] forState:UIControlStateHighlighted];
}
- (void) setLike {
    [likeButton addTarget:self action:@selector(likeFunction) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setImage:[UIImage imageNamed:@"s2_selected"] forState:UIControlStateHighlighted];
}

#pragma mark - Delegate
- (void) setDelegate: (MainViewController *) tempDelegate {
    delegate = tempDelegate;
}
- (void) setStaredDelegate: (StaredViewController *) tempDelegate {
    delegate2 = tempDelegate;
}

#pragma mark - UIActionSheet
- (void) showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"COMPARTILHAR"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancelar"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook",@"Twitter",@"E-mail", @"Copiar Link", nil];
    

    [actionSheet showFromTabBar:delegate.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Shared *share = [[Shared alloc] init];
    share.delegate = delegate;
    
    switch (buttonIndex) {
        case 0: {
            [share sharedFacebookProduct:produto];
        }
        break;
        case 1: {
            [share sharedTwitterProduct:produto];
        }
        break;
        case 2: {
            [delegate sharedEmailProduct: produto];
        }
            break;
        case 3: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *promoID = [NSString stringWithFormat:@"%@",produto.promo_id];
            NSString *site = @"www.promonster.com.br/promo/";
            site = [site stringByAppendingString:promoID];
            pasteboard.string = site;
            [CSNotificationView showInViewController:delegate
                                               style:CSNotificationViewStyleSuccess
                                             message:@" Copiado para área de transferencia"];
            break;
        }
        default:
            break;
    }
}
- (void) tapDetected:(UIGestureRecognizer*) gestureRecognizer {

}
@end
