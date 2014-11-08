//
//  TabBarViewController.m
//  getupr
//
//  Created by Conrado on 27/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//


#import "TabBarViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
        Sets the first item to be displayed
     */
    [self setSelectedIndex:2];
  
    /**
     *  Custom Colors
     */
    colorBackground = [UIColor colorWithRed:92/255.0f
                                      green:202/255.0f
                                       blue:222/255.0f
                                      alpha:1.0f];
    
    colorSelected = [UIColor yellowColor];
    colorUnselected = [UIColor whiteColor];
    
    /**
        Custom settings for TabBarController
     */
    [self configTabBar];
    [self configFontTabBar];
    
    self.tabBar.barTintColor = colorBackground;
    
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.translucent = NO;
}


#pragma mark - Config TabBar
/**
 *  Customizes and configures the TabBarController
 */

- (void) configTabBar {
    UITabBar *tabBar = self.tabBar;
    
    for (UITabBarItem  *tab in tabBar.items) {
        tab.image = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
  
        if ([tab.title isEqual:@""]) {
            tab.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            tab.selectedImage = [[UIImage imageNamed:@"tab_promonster.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        }
    }
}
- (void) configFontTabBar {
    [[UITabBar appearance] setSelectedImageTintColor:colorSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       colorSelected, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:9.0f], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       colorUnselected, NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Helvetica" size:9.0f], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
