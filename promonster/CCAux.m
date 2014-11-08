//
//  CCAux.m
//  uGuide UFOP
//
//  Created by Conrado on 23/01/14.
//  Copyright (c) 2014 Conrado. All rights reserved.
//

#import "CCAux.h"
@implementation CCAux

+ (BOOL) validateEmail:(NSString*) email {
    // Defining and allocating variables necessary
    NSString *regExPattern;
    NSRegularExpression *regEx = [NSRegularExpression alloc];
    NSUInteger regExMatches;
    
    // Checking if a string has content Email
    if(![email length]){
        return NO;
    }

    // Setting the standard regular expression
    regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    // Creating a regular expression pattern with the previously defined
    regEx =  [regEx initWithPattern:regExPattern
                            options:NSRegularExpressionCaseInsensitive
                              error:nil];
    // Check if email is set equal to the standard
    regExMatches = [regEx numberOfMatchesInString:email
                                          options:0
                                            range:NSMakeRange(0, [email length])];

    // If regExMatches equals 0 the e-mail is Invalid
    if (!regExMatches) {
        return NO;
    } else {
        return YES;
    }
}
+ (void) setUserID: (NSString *) userID andUsername: (NSString *) username {
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setIDFacebook: (NSString *) userFB_id {
    [[NSUserDefaults standardUserDefaults] setValue:userFB_id forKey:@"facebookID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *) getIDFacebook {
    NSString *result = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookID"];
    if (!result) {
        result = @"null";
    }
    return result;
}
+ (void) setPushToken: (NSString *) pushToken {
    [[NSUserDefaults standardUserDefaults] setValue:pushToken forKey:@"pushToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (NSString *) getPushToken {
    NSString *result = [[NSUserDefaults standardUserDefaults] valueForKey:@"pushToken"];
    if (!result) {
        result = @"null";
    }
    return result;
}

+ (void) setUserID: (NSString *)userid {
    [[NSUserDefaults standardUserDefaults] setValue:userid forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setShouldSkipLogIn:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"promonster"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *) getUserID {
    NSString *userID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]];
    if (!userID) {
        userID = @"342";
    }
    
    return [self encodeURIComponent:userID];
}
+ (NSString *) getUserName {
    NSString *username = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];

    if ([username isEqualToString:@"(null)"])  {
        username = @"Desconhecido";
    }
    return username;
}

+ (BOOL)shouldSkipLogIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"promonster"];
}

+ (void)setLoginStatus:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getLoginStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
}
+ (NSString *)encodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return s;
}


+ (NSString *)getDeviceID {
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
}

+ (void)setUpadte:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"update"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getUpdate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"update"];
}

+ (void)setNotifyEnable:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"notify"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getNotifyEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"notify"];
}

+ (NSInteger) setContEvent {
    NSInteger value = [[NSUserDefaults standardUserDefaults] integerForKey:@"contEvent1"];
    if (value<3) {
        [[NSUserDefaults standardUserDefaults] setInteger:value+1 forKey:@"contEvent1"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    return value;
}
@end
