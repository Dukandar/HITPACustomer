//
//  Greveance.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Greveance : NSObject

@property (nonatomic, strong) NSString * assignFromUser;
@property (nonatomic, strong) NSString * assignToTeam;
@property (nonatomic, strong) NSString * callType;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, strong) NSString * complaint;
@property (nonatomic, strong) NSString * grievanceReqDate;
@property (nonatomic, strong) NSString * grievanceType;
@property (nonatomic, strong) NSString * policyNo;
@property (nonatomic, strong) NSString * serviceRequestDetails;
@property (nonatomic, strong) NSString * serviceRequestId;
@property (nonatomic, strong) NSString * serviceRequestStatus;
@property (nonatomic, strong) NSString * serviceRequestSubType;
@property (nonatomic, strong) NSString * serviceRequestType;
@property (nonatomic, strong) NSString * tAT;

@property (nonatomic, strong) NSString * assignTo;
@property (nonatomic, strong) NSString * grvRequestId;
@property (nonatomic, strong) NSString * modifiedDateTIme;
@property (nonatomic, strong) NSString * referenceID;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, strong) NSString * requestResponseType;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * userName;

@property (nonatomic, strong) NSArray  * grievanceHistory;


+ (Greveance *)grivanceWithResponse:(NSDictionary *)response;

@end
