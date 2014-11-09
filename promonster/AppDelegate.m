//
//  AppDelegate.m
//  promonster
//
//  Created by Conrado on 25/07/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UAAppReviewManager.h"
#import "SCErrorHandler.h"
#import "SCSettings.h"
#import "DetailProductViewController.h"
#import "NavigationViewController.h"
#import "TabBarViewController.h"
#import "CCAux.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kCOLOR [UIColor colorWithRed:91/255.0f green:201/255.0f blue:224/255.0f alpha:1.0f]
#define kDEBUG YES

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-54491220-1";
static NSString *const kAllowTracking = @"allowTracking";


@implementation AppDelegate
@synthesize tabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBLoginView class];
    [FBProfilePictureView class];
    [self definePushNotification: application];
    [self defineGoogleAnalytics];
    [self defineAppReview];
    
    NSDictionary *apnsBody = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (apnsBody) {
        if (kDEBUG) {
            NSLog(@"Launched from push notification: %@", apnsBody);
        }
        
        NSString *promoID = [apnsBody valueForKey:@"promo_id"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
         TabBarViewController *initViewController = (TabBarViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [initViewController setSelectedIndex:2];
        

        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initViewController;
        [self.window makeKeyAndVisible];
        
        
        DetailProductViewController *detailProduct = (DetailProductViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailProductViewController"];
        detailProduct.promo_id = promoID;
        detailProduct.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NavigationViewController *nav = [initViewController.viewControllers objectAtIndex:2];
                [nav pushViewController:detailProduct animated:YES];

    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    
    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }
            else {
                [self _handleAppLink:call.accessTokenData];
            }
        }
    }];
}

#pragma mark - Helper Methods

// Helper method to wrap logic for handling app links.
- (void)_handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    NSLog(@"\n\n\n PEGANDO PERMISSAO");
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:@[@"basic_info",@"email",@"user_location",@"user_birthday",@"user_hometown"]
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  SCHandleError(error);
                              }
                          }];
}
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


#pragma mark - Rater
/**
 *  UAppReviewManager
 *  Request Automatic Review for Apple Store
 */
- (void) defineAppReview {
    [UAAppReviewManager setAppID:@"919649318"];
    [UAAppReviewManager setAppName:@"Promonster"];
    
    [UAAppReviewManager setReviewTitle:@"Avaliar Promonster"];
    [UAAppReviewManager setReviewMessage:@"Curtiu as promonsters? Avalia lá na AppStore ;-) \nSeu review é muito importante para melhorar o App!"];
    
    [UAAppReviewManager setRateButtonTitle:@"Avaliar Promonster!"];
    [UAAppReviewManager setCancelButtonTitle:@"Não, obrigado."];
    [UAAppReviewManager setRemindButtonTitle:@"Me lembre depois! :)"];
    
    [UAAppReviewManager userDidSignificantEvent:YES];
    [UAAppReviewManager setSignificantEventsUntilPrompt:3];
    [UAAppReviewManager setDaysUntilPrompt:1];
   // [UAAppReviewManager showPrompt];
}

#pragma mark - Google Analytics
/**
 *  Google Analytics
 *  Analyzes user behavior within the application
 */
- (void) defineGoogleAnalytics {
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Promonster"
                                              trackingId:kTrackingId];
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
}


#pragma mark - Push Notification
/**
 *  Initializes and configures the push notification
 */
- (void) definePushNotification: (UIApplication *) application{
    /**** PUSH NOTIFY ****/
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CCAux setPushToken:[self stringWithDeviceToken:deviceToken]];
    if (kDEBUG) {
        NSLog(@"\n> Token Device PushNotification: %@",[CCAux getPushToken]);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (kDEBUG) {
        NSLog(@"\nERROR - push.");
        if (error.code == 3010) {
            NSLog(@"\nPush notifications are not supported in the iOS Simulator.");
        } else {
            // show some alert or otherwise handle the failure to register.
            NSLog(@"n\napplication:didFailToRegisterForRemoteNotificationsWithError: %@", error);
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    _promoID = [userInfo valueForKey:@"promo_id"];
    _userInfoTmp = userInfo;
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *alertMsg = [aps valueForKey:@"alert"];

    if (application.applicationState == UIApplicationStateActive) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        if (_promoID) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"O Polvo avisa:" message:alertMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.tag = 1;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"O Polvo avisa:" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
        }
    }else {
        [self goPromonster];
    }
}

/**
 *  Defines the device token
 *
 *  @param deviceToken Device Token NSData
 *
 *  @return Device Token String
 */
- (NSString*)stringWithDeviceToken:(NSData*) deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy];
}

- (void) goPromonster {    
    [[NSUserDefaults standardUserDefaults] setValue:_userInfoTmp forKey:@"promoIdPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:_userInfoTmp];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (alertView.tag == 1) {
        if([title isEqualToString:@"OK"]) {
            [self goPromonster];
        }
    }else if (alertView.tag ==2) {
        if([title isEqualToString:@"OK"]) {
            UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
            NSArray *itens = tabBar.tabBar.items;
            UITabBarItem *tab = [itens objectAtIndex:0];
            NSDictionary *aps = [_userInfoTmp valueForKey:@"aps"];
            NSString *badge = [NSString stringWithFormat:@"%@",[aps valueForKey:@"badge"]];
            
            [tab setBadgeValue: badge];
        }
    }
}

#pragma mark - Layout
- (void) customizeTabbar {
    tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.tabBar.barTintColor = kCOLOR;
    tabBarController.tabBar.selectedImageTintColor = [UIColor yellowColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor yellowColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:9.0f], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:9.0f], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
}
- (void) customizeNavigationBar {
    [[UINavigationBar appearance] setBarTintColor:kCOLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}
@end
