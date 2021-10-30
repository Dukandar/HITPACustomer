//
//  MyPolicy.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPolicyModel : NSObject

@property (strong, nonatomic) NSString *policyNumber;
@property (strong, nonatomic) NSString *policyFrom;
@property (strong, nonatomic) NSString *policyTo;
@property (strong, nonatomic) NSString *memberID;
@property (strong, nonatomic) NSString *memberName;
@property (strong, nonatomic) NSString *memberAge;
@property (strong, nonatomic) NSString *policyGender;
@property (strong, nonatomic) NSString *policyStatus;
@property (strong, nonatomic) NSString *employeeID;
@property (strong, nonatomic) NSString *policyCompany;
@property (strong, nonatomic) NSString *policyType;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *contactNo;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSString *membersEnrolled;
@property (strong, nonatomic) NSArray *memberDetails;
@property (strong, nonatomic) NSString *insuranceCompanyLogo;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *SI;
@property (strong, nonatomic) NSString *BSI;


@property (strong, nonatomic) NSString *claimNumber;
@property (strong, nonatomic) NSString *dateOfLoss;
@property (strong, nonatomic) NSString *product;
@property (strong, nonatomic) NSString *hospitalName;
@property (strong, nonatomic) NSString *policyMemberName;
@property (strong, nonatomic) NSString *claimType;
@property (strong, nonatomic) NSString *claimStatus;
@property (strong, nonatomic) NSString *dateOfIntimation;
@property (strong, nonatomic) NSString *paymentAmount;
@property (strong, nonatomic) NSString *totalRequestedAmount;

+ (MyPolicyModel *)getPolicyDetailsByResponse:(NSDictionary *)response;

+ (MyPolicyModel *)getPolicyHistoryDetailsByResponse:(NSDictionary *)response;

@end
