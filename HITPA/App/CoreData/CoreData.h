//
//  CoreData.h
//  HITPA
//
//  Created by Bhaskar C M on 12/21/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

+ (CoreData *)shareData;

#pragma mark-MyPolicy
- (void)setMyPolicyDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getPolicyDetail;

#pragma mark - MyPolicy History
- (void)setMyPolicyHistoryDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getPolicyHistoryDetail;

#pragma mark-Mcard
- (void)setMcardDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getMcardDetail;

#pragma mark-NearMeHospital
- (void)setNearMeHospitalDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getNearMeHospitalDetail;

#pragma mark-AllHospital
- (void)setAllHospitalDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getAllHospitalDetail;


#pragma mark-QuickConnectDetails
- (void)setQuickConnectDetailsWithResponse:(NSDictionary *)response;

- (NSDictionary *)getQuickConnectDetail;

#pragma mark-BranchLocator
- (void)setBranchLocationsDetailsWithResponse:(NSDictionary *)response;

- (NSArray *)getBranchLocationsDetails;

@end
