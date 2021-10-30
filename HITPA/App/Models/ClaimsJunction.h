//
//  ClaimsJunction.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClaimsJunction : NSObject

@property (strong, nonatomic) NSString *dateOfAdmission;
@property (strong, nonatomic) NSString *dateOfDischarge;
@property (strong, nonatomic) NSString *diagnosis;
@property (strong, nonatomic) NSString *estimatedExpense;
@property (strong, nonatomic) NSString *hospitalName;
@property (strong, nonatomic) NSString *patientName;
@property (strong, nonatomic) NSString *contactNumber;
@property (strong, nonatomic) NSString *emailID;
@property (strong, nonatomic) NSString *dateTime;
@property (strong, nonatomic) NSString *claimStatus;
@property (strong, nonatomic) NSString *coverage;
@property (strong, nonatomic) NSString *consumed;
@property (strong, nonatomic) NSString *claimNumber;
@property (strong, nonatomic) NSString *paymentAmount;
@property (strong, nonatomic) NSString *claimType;
@property (strong, nonatomic) NSString *claimSubType;
@property (strong, nonatomic) NSString *claimsFeedbackStatus;
@property (strong, nonatomic) NSString *claimsUHID;
@property (strong, nonatomic) NSString *policyNumber;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSString *paidAmount;
@property (strong, nonatomic) NSString *paidDate;
@property (strong, nonatomic) NSString *bankName;
@property (strong, nonatomic) NSString *accountNumber;
@property (strong, nonatomic) NSString *UTRNo;
@property (strong, nonatomic) NSString *TDSDeducted;
@property (strong, nonatomic) NSString *branch;


+ (ClaimsJunction *)getClaimsHistoryDetailsByResponse:(NSDictionary *)response;

@end
