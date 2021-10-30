//
//  Helper.h
//  HITPA
//
//  Created by Selma D. Souza on 09/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (Helper *)shareHelper;

- (BOOL)validateClaimSearchAllEntriesWithError:(NSArray **)error params:(NSString *)searchText;

- (NSString *)getErrorStringFromErrorDescription:(NSArray *)error;

- (BOOL)validateSectionWithError:(NSArray **)error params:(NSMutableDictionary *)params;

- (BOOL)emailValidationWithEmail:(NSString *)emailString;

#pragma mark - Login
- (BOOL)validateLoginWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

#pragma mark - Forgot password
- (BOOL)validateForgotPasswordWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (BOOL)validateRiaseClaimWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (BOOL)validateGrievanceWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (BOOL)validateChangePasswordWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (NSString *)getUniqueDeviceIdentifierAsString;

-(BOOL)validateRegistrationWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (BOOL)validateBMIWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

- (BOOL)validateCalendarEventWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas;

@end
