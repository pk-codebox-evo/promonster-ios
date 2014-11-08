//
//  TipCell.m
//  promonster
//
//  Created by Conrado on 18/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "TipCell.h"

@implementation TipCell
@synthesize tip;
- (void)awakeFromNib {
    // Initialization code
    [self setLayoutButton:tip];
    [tip.titleLabel setNumberOfLines:4];
    tip.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:18.f];
    self.bgrView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMeio"]];
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
}
- (void) setDetailButton: (UIButton *) button {
    button.titleLabel.font = [UIFont fontWithName:@"Rokkitt" size:15.f];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
