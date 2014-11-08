//
//  ProsConsCell.m
//  promonster
//
//  Created by Conrado on 19/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "ProsConsCell.h"

@implementation ProsConsCell

- (void)awakeFromNib {
    // Initialization code
    self.bgrView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMeio"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
