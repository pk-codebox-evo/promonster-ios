//
//  SetViewController.h
//  promonster
//
//  Created by Conrado on 03/09/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

#import "SVModalWebViewController.h"
#import "UserLogin.h"
#import "WebService.h"

@import CoreLocation;

@interface SetViewController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate, FBViewControllerDelegate, CLLocationManagerDelegate> {
    BOOL enableFB;
    BOOL firstTime;
    BOOL _viewDidAppear;
    BOOL _viewIsVisible;
}
@property(nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) UserLogin *userLogin;
@property (nonatomic, retain) WebService *service;

@property (strong, nonatomic) IBOutlet UIView *bgrView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet FBLoginView *loginFacebook;
@property (strong, nonatomic) IBOutlet UIButton *blackListButton;
@property (strong, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIButton *talkButton;

@property (strong, nonatomic) IBOutlet UISwitch *notifyAction;

/**
 *
 *  Layout and Settings
 *
 **/
- (void) setBorderInButton: (UIButton *) buttonTmp;
- (void) setBorderInView : (UIView *) viewTmp;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void) setTabBarItem;
- (void) defineLayout;

/**
 *
 *  Buttons
 *
 **/
- (void) blackListAction;
- (void) aboutAction;
- (void) termsAction;
- (void) talkAction;

/**
 *
 *  CoreLocation
 *
 **/
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void) requestAlwaysAuthorization;

/**
 *
 *  Facebook SDK
 *
 **/
- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user;
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void) closeFB;

@end
