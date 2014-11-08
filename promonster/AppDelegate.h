//
//  AppDelegate.h
//  promonster
//
//  Created by Conrado on 25/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) UITabBarController *tabBarController;
@property (nonatomic, retain) NSString *promoID;
@property (nonatomic, retain) NSDictionary *userInfoTmp;
@property(nonatomic, strong) id<GAITracker> tracker;

@end
