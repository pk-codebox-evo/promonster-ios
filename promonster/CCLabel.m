//
//  CCLabel.m
//  promonster
//
//  Created by Conrado on 11/08/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "CCLabel.h"

@implementation CCLabel



- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setFont:[UIFont fontWithName:@"Rokkitt" size:self.font.pointSize]];
    }
    return self;
}
- (void) setSize {
    
}
@end
