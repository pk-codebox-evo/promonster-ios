//
//  NavigationViewController.m
//  promonster
//
//  Created by Conrado on 28/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:92/255.0f green:202/255.0f blue:222/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    
    self.navigationBar.backIndicatorImage =  [[UIImage imageNamed:@"backButton"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorTransitionMaskImage =  [[UIImage imageNamed:@"backButton"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
