//
//  SharedCell.m
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "SharedCell.h"
#import "WebService.h"
#import "CSNotificationView.h"

#import "Shared.h"
@implementation SharedCell
@synthesize delegate,promo_id;
- (void)awakeFromNib {
    [self defineButton:_notifyOutlet];
    [self defineButton:_sharedOutlet];
}

- (void) defineButton: (UIButton *) button {
    button.layer.cornerRadius = CGRectGetHeight(button.bounds) / 14;
    button.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:16.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)notifyEndPromo:(UIButton *)sender {
    WebService *service = [[WebService alloc] init];
    [service notifyEndPromo:promo_id andDelegate:delegate];
}

- (IBAction)sharedButton:(UIButton *)sender {
    [delegate showActionSheet];
}

@end
