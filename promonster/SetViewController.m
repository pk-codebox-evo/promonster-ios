//
//  SetViewController.m
//  promonster
//
//  Created by Conrado on 03/09/14.
//  Copyright (c) 2014 ConradoCarneiro. All rights reserved.
//


#import "SetViewController.h"
#import "CSNotificationView.h"
#define kSite @"http://www.promonster.com.br/"
#define kBlackList @"listanegra"
#define kSiteAbout @"sobre"
#define kSiteTerms @"termos"
#define kSiteTalk @"contato"
#import "CCAux.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SetViewController ()

@end

@implementation SetViewController
@synthesize scrollView, userLogin, notifyAction, service;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!service) {
        service = [[WebService alloc] init];
    }
    if (!userLogin) {
        userLogin = [[UserLogin alloc] init];
    }

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    [self.locationManager startUpdatingLocation];
    
    self.loginFacebook.readPermissions = @[@"public_profile", @"email", @"user_birthday", @"user_location"];
    
    // Initialization code
    if ([CCAux shouldSkipLogIn]) {
        enableFB = YES;
    } else {
        enableFB = NO;
        //SCSettings *settings = [SCSettings defaultSettings];
        if (_viewDidAppear) {
            _viewIsVisible = YES;
        } else {
            [FBSession openActiveSessionWithAllowLoginUI:NO];
            FBSession *session = [FBSession activeSession];
            if (session.isOpen) {
                //    [self performSegueWithIdentifier:@"appSegue" sender:nil];
            } else {
                _viewIsVisible = YES;
            }
            _viewDidAppear = YES;
        }
    }
    
    [self defineLayout];
    
    NSShadow *shadow = [NSShadow.alloc init];
    shadow.shadowColor = [UIColor redColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor],NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont fontWithName:@"Rokkitt" size:20.0], NSFontAttributeName, nil]];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"PERFIL";
    
    if ([CCAux getLoginStatus]) {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleSuccess
                                         message:@"Faça login!"];
        [CCAux setLoginStatus:NO];
    }

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goHomeWithDelegate) object:nil];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.notifyAction.enabled = [CCAux shouldSkipLogIn];
    [self.notifyAction setOn:![CCAux getNotifyEnable]];
}


#pragma mark - Layout
- (void) defineLayout {
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retractKeyboard)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    [scrollView setScrollEnabled:YES];
    
    bool isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    CGSize scrollViewContentSize;
    
    if (isiPhone5) {
        scrollViewContentSize = CGSizeMake(320, 590);
    } else {
        scrollViewContentSize = CGSizeMake(320, 680);
    }
    [self.scrollView setContentSize:scrollViewContentSize];
    
    [_blackListButton addTarget:self action:@selector(blackListAction) forControlEvents:UIControlEventTouchUpInside];
    _blackListButton.layer.cornerRadius = CGRectGetHeight(_blackListButton.bounds) / 14;
    
    [self setBorderInView:_bgrView];
    
    if ([CCAux shouldSkipLogIn]) {
        _blackListButton.enabled = YES;
    }
    
    [notifyAction addTarget: self
                     action: @selector(flip:)
           forControlEvents:UIControlEventValueChanged];
    [_termsButton addTarget:self action:@selector(termsAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBorderInButton:_termsButton];
    [_termsButton setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    
    [_aboutButton addTarget:self action:@selector(aboutAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBorderInButton:_aboutButton];
    [_aboutButton setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    
    [_talkButton addTarget:self action:@selector(talkAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBorderInButton:_talkButton];
    [_talkButton setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
}
- (void) setBorderInButton: (UIButton *) buttonTmp {
    buttonTmp.layer.borderWidth = 0.6f;
    buttonTmp.layer.borderColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f].CGColor;
}
- (void) setBorderInView : (UIView *) viewTmp {
    viewTmp.layer.borderWidth = 0.6f;
    viewTmp.layer.borderColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f].CGColor;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Button Action
- (IBAction)flip:(UISwitch *)sender {
    if (sender.on) {
        if (!userLogin.email) {
            [self alertEmail];
        } else {
            [service pushOnService:userLogin andDelegate:self];
        }
    }
    else {
        [service pushOffService:self];
    }
}

#pragma mark - Facebook
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        if (FBSession.activeSession.isOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 if (!error) {
                     NSString *accesTokenFB = [FBSession activeSession].accessTokenData.accessToken;
            
                     NSString *gender = [user objectForKey:@"gender"];
                     gender = [gender substringToIndex:1];
                     
                     userLogin.source = @"facebook";
                     userLogin.name = user.name;
                     userLogin.gender = gender;
                     userLogin.birthday = user.birthday;
                     userLogin.city = [user.location objectForKey:@"name"];
                     userLogin.cityID = [user.location objectForKey:@"id"];
                     userLogin.email = [user objectForKey:@"email"];
                     userLogin.social_id = user.objectID;
                     userLogin.accesTokenFB = accesTokenFB;
                     userLogin.pushToken = [CCAux getPushToken];
                     NSString *lat = [NSString stringWithFormat:@"%.8f",self.locationManager.location.coordinate.latitude];
                     NSString *longi = [NSString stringWithFormat:@"%.8f",self.locationManager.location.coordinate.longitude];
                     if (lat && longi) {
                         userLogin.coordinate = [NSString stringWithFormat:@"%@, %@",lat,longi];
                     } else {
                         userLogin.coordinate = @"0,0";
                     }                     
                     // Look up age range property and put min and max into string "min-max"
                     NSDictionary *ageRangeDict = [user objectForKey:@"age_range"];
                     NSString *age_range = @"";
                     NSString *min = [ageRangeDict objectForKey:@"min"];
                     if (min) {
                         age_range = min;
                     }
                     NSString *max = [ageRangeDict objectForKey:@"max"];
                     if (max) {
                         age_range = [age_range stringByAppendingString:max];
                     }
                     userLogin.age = age_range;
                     [CCAux setIDFacebook:user.objectID];
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                     if (!enableFB) {
                         [self sendInfoLoginBackEnd];
                         enableFB = YES;
                     }

                 }
             }];
    }
}
- (void) closeFB {
    [FBSession.activeSession closeAndClearTokenInformation];
}
- (void) sendInfoLoginBackEnd {
    if (!userLogin.email) {
        [self alertEmail];
    } else {
        [service makeLogin:userLogin andDelegate:self];
    }

}
- (void) alertEmail {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Cadastre seu e-mail"
                                                      message:@"Você poderá utilizar todas as funções do App"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancelar"
                                            otherButtonTitles:@"Enviar", nil];
    
    message.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* answerField = [message textFieldAtIndex:0];
    answerField.keyboardType = UIKeyboardTypeEmailAddress;
    answerField.placeholder = @"polvo@exemplo.com";
    message.tag = 101;
    
    [message show];
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [CCAux setShouldSkipLogIn:NO];
    if (enableFB) {
        enableFB = YES;
        [service makeLogOff:self];
        enableFB = NO;
    }
}

#pragma mark - Alertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == 101) {
        if([title isEqualToString:@"Enviar"]) {
            NSString *emailTemp = [[alertView textFieldAtIndex:0]text];
            userLogin.email = emailTemp;
            [service makeLogin:userLogin andDelegate:self];
        } else {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Cadastro de e-mail obrigatório."];
            [self performSelector:@selector(closeFB) withObject:nil afterDelay:0.3];
        }
    }
}

- (void) setTabBarItem {
    [self performSelector:@selector(goHomeWithDelegate) withObject:nil afterDelay:1];
}
- (void) goHomeWithDelegate {
    [self.tabBarController setSelectedIndex:2];
}

- (void) retractKeyboard {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) blackListAction {
    if ([CCAux shouldSkipLogIn]) {
        NSString *site = kSite;
        site = [site stringByAppendingString:kBlackList];
        NSURL *URL = [NSURL URLWithString:site];
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
        webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        webViewController.barsTintColor = [UIColor blackColor];
        webViewController.title = @"Carregando...";

        [self presentViewController:webViewController animated:YES completion:NULL];
    } else {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleSuccess
                                         message:@"Para ter acesso, faça login!"];
    }
}
#pragma mark - Buttons
- (void) termsAction {
    NSURL *URL = [NSURL URLWithString:kSiteTerms];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc]
                                                   initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.title = @"Carregando...";
    webViewController.nameSiteGA = @"Termos Screen";
    webViewController.barsTintColor = [UIColor blackColor];
    [self presentViewController:webViewController animated:YES completion:NULL];
}

- (void) aboutAction {    
    NSURL *URL = [NSURL URLWithString:kSiteAbout];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc]
                                                   initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.barsTintColor = [UIColor blackColor];
    webViewController.nameSiteGA = @"Sobre Screen";
    webViewController.title = @"Carregando...";

    [self presentViewController:webViewController animated:YES completion:NULL];
}
- (void) talkAction{
    NSURL *URL = [NSURL URLWithString:kSiteTalk];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc]
                                                   initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.title = @"Carregando...";
    webViewController.nameSiteGA = @"Contato Screen";
    webViewController.barsTintColor = [UIColor blackColor];
    [self presentViewController:webViewController animated:YES completion:NULL];
}
#pragma mark - CLLocation
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}
- (void)requestAlwaysAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)dealloc {
    self.locationManager = nil;
}

@end
