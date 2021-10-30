//
//  HITPAAPI.h
//  HITPA
//
//  Created by Bhaskar C M on 12/22/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APICompletionHandler)(NSDictionary *dictionary, NSError *error);

@interface HITPAAPI : NSObject

+ (HITPAAPI *)shareAPI;

#pragma mark - Login

- (void)loginWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apicompletionHandler;

- (void)forgotPasswordWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)changePasswordWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - My Policy

- (void)policyDetailsWithParams:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)postMCardDetailsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Updates

- (void)getUpdatesWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Quick Connect

- (void)getQuickConnectDetailsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiComletionHandler;

#pragma mark - Branch Locator

- (void)getBranchLocationsWithCompletionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Grievance

- (void)postGrievanceDetailsWithParams:(NSDictionary *)params callerType:(NSString *)callerType completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getGrievanceDetailWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)postGrievanceUpdateDetailWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)uploadGrievanceDocumentsWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Hospital Search

- (void)getSearchAllHopitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getSearchNearMeHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getSearchHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getSearchHospitalWithMultipleParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Claims Junction

- (void)postClaimsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getIntimationWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)getClaimSearchHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;


- (void)getClaimsHistoryWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Register DeviceToken
- (void)registerDeviceTokeWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Feedback
- (void)postFeedbackWithParams:(NSArray *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Registration
- (void)registrationWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apicompletionHandler;

- (void)emailDownloadForm:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

- (void)downloadPDFForm:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler;

#pragma mark - Wellness tips
- (void)getWellnessTipWithCompletionHandler:(APICompletionHandler)apiCompletionHandler;

@end
