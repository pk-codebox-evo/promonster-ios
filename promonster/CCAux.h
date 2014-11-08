//
//  CCAux.h
//  uGuide UFOP
//
//  Created by Conrado on 23/01/14.
//  Copyright (c) 2014 Conrado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAux : NSObject

+ (BOOL) validateEmail:(NSString*) email;
+ (void) setUserID: (NSString *) userID andUsername: (NSString *) username;
+ (void) setIDFacebook: (NSString *) userFB_id;
+ (NSString *) getIDFacebook;
+ (NSString *) getUserID;
+ (NSString *) getUserName;
+ (void) setUserID: (NSString *)userid;
+ (void)setShouldSkipLogIn:(BOOL)skip;
+ (BOOL)shouldSkipLogIn;
+ (NSString *)getDeviceID;
+ (void)setLoginStatus:(BOOL)skip;
+ (BOOL)getLoginStatus;

+ (void)setUpadte:(BOOL)skip;
+ (BOOL)getUpdate;

+ (void) setPushToken: (NSString *) pushToken;
+ (NSString *) getPushToken;

+ (void)setNotifyEnable:(BOOL)skip;
+ (BOOL)getNotifyEnable;
+ (NSInteger) setContEvent;
@end
