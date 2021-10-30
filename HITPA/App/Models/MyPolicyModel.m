//
//  MyPolicy.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "MyPolicyModel.h"


NSString * const kPolicyNumber           = @"PolicyNumber";
NSString * const kPolicyFrom             = @"PolicyEffectiveDate";
NSString * const kPolicyTo               = @"PolicyEndDate";
NSString * const kPolicyMemberID         = @"MemberID";
NSString * const kPolicyMemeberName      = @"CustomerName";
NSString * const kPolicyMemberAge        = @"MemberAge";
NSString * const kPolicyGender           = @"Gender";
NSString * const kPolicyEmployeeID       = @"EmployeeNumber";
NSString * const kPolicyCompany          = @"CompanyName";
NSString * const kMemberDetails          = @"MemberDetails";
NSString * const kPolicyType             = @"PolicyType";
NSString * const kEmail                  = @"EmailID";
NSString * const kContact                = @"ContactNumber_Mob";
NSString * const kRelationship           = @"Relationship";
NSString * const kPolicyStatus           = @"PolicyStatus";
NSString * const kMemberAddress          = @"Address";
NSString * const kBSI                    = @"BSI";
NSString * const kSI                     = @"SI";

NSString * const kClaimNumber            = @"ClaimNo";
NSString * const kDateOfLoss             = @"DateOfDischarge";
NSString * const kProductName            = @"ProductName";
NSString * const kClaimHospitalName      = @"HospitalName";
NSString * const kMemeberName            = @"PatientName";
NSString * const kClaimType              = @"ClaimType";
NSString * const kClaimStatus            = @"ClaimStatus";
NSString * const kDateOfIntimation       = @"DateOfIntimation";
NSString * const kPaymentAmount          = @"TotalApprovedAmount";
NSString * const kTotalRequestedAmount   = @"TotalRequestedAmount";
NSString * const kInsuranceCompanyLogo   = @"InsuranceCompanyLogo";

@implementation MyPolicyModel

+ (MyPolicyModel *)getPolicyDetailsByResponse:(NSDictionary *)response
{
    
    if (response != nil && [response isKindOfClass:[NSDictionary class]]) {
        MyPolicyModel *details = [[MyPolicyModel alloc]init];
        
        NSString *policyNumber = ([[response valueForKey:kPolicyNumber] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyNumber];
        
        if (policyNumber != nil && [policyNumber isKindOfClass:[NSString class]]) {
            
            details.policyNumber = policyNumber;
        }
        
        NSString *from = ([[response valueForKey:kPolicyFrom] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyFrom];
        
        if (from != nil && [from isKindOfClass:[NSString class]]) {
        
            
            details.policyFrom = from;
        }
        
        NSString *to = ([[response valueForKey:kPolicyTo] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyTo];
        
        if (to != nil && [to isKindOfClass:[NSString class]]) {
        
            
            details.policyTo = to;
        }
        
        NSString *memberID = ([[response valueForKey:kPolicyMemberID] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyMemberID];
        
        if (memberID != nil && [memberID isKindOfClass:[NSString class]]) {
            
            details.memberID = memberID;
        }
        
        NSString *memberName = ([[response valueForKey:kPolicyMemeberName] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyMemeberName];
        
        if (memberName != nil && [memberName isKindOfClass:[NSString class]]) {
            
            details.memberName = memberName;
        }
        
        NSString *address = ([[response valueForKey:kMemberAddress] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kMemberAddress];
        
        if (address != nil && [address isKindOfClass:[NSString class]]) {
            
            details.address = address;
        }
        
        NSString *relationship = ([[response valueForKey:kRelationship] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kRelationship];
        
        if (relationship != nil && [relationship isKindOfClass:[NSString class]]) {
            
            details.relationship = relationship;
        }
        
        NSString *email = ([[response valueForKey:kEmail] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kEmail];
        
        if (email != nil && [email isKindOfClass:[NSString class]]) {
            
            details.email = email;
        }
        
        NSString *contactNo = ([[response valueForKey:kContact] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kContact];
        
        if (contactNo != nil && [contactNo isKindOfClass:[NSString class]]) {
            
            details.contactNo = contactNo;
        }
        
        NSString *policyType = ([[response valueForKey:kPolicyType] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyType];
        
        if (policyType != nil && [policyType isKindOfClass:[NSString class]]) {
            
            details.policyType = policyType;
        }

        
        NSString *age = ([[response valueForKey:kPolicyMemberAge] isKindOfClass:[NSNull class]])?@"NA":[NSString stringWithFormat:@"%@ years",[response valueForKey:kPolicyMemberAge]];
        
        if (age != nil && [age isKindOfClass:[NSString class]]) {
            
            details.memberAge = age;
        }
        
        
        NSString *gender = ([[response valueForKey:kPolicyGender] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyGender];
        
        if (gender != nil && [gender isKindOfClass:[NSString class]]) {
            
            details.policyGender = gender;
        }
        
        NSString *employeeID = ([[response valueForKey:kPolicyEmployeeID] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyEmployeeID];
        
        if (employeeID != nil && [employeeID isKindOfClass:[NSString class]]) {
            
            details.employeeID = employeeID;
        }
        
        NSString *productName = ([[response valueForKey:kProductName] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kProductName];
        
        if (productName != nil && [productName isKindOfClass:[NSString class]]) {
            
            details.product = productName;
            
        }
        
        NSString *company = ([[response valueForKey:kPolicyCompany] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyCompany];
        
        if (company != nil && [company isKindOfClass:[NSString class]]) {
            
            details.policyCompany = company;
        }
        
        NSArray *memberDetails = ([[response valueForKey:kMemberDetails] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kMemberDetails];
        
        if (memberDetails != nil && [memberDetails isKindOfClass:[NSArray class]]) {
            
            details.memberDetails = memberDetails;
        }
        
        NSString *insuranceCompanyLogo = ([[response valueForKey:kInsuranceCompanyLogo] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kInsuranceCompanyLogo];
        
        if (insuranceCompanyLogo != nil && [insuranceCompanyLogo isKindOfClass:[NSString class]]) {
            
            details.insuranceCompanyLogo = insuranceCompanyLogo;
        }

        NSString *policyStatus = ([[response valueForKey:kPolicyStatus] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyStatus];
        if (policyStatus != nil && [policyStatus isKindOfClass:[NSString class]])
        {
            details.policyStatus = policyStatus;
        }
        
        NSString *SI = ([[response valueForKey:kSI] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kSI];
        if (SI != nil && [SI isKindOfClass:[NSString class]])
        {
            details.SI = SI;
        }
        
        NSString *BSI = ([[response valueForKey:kBSI] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kBSI];
        if (BSI != nil && [BSI isKindOfClass:[NSString class]])
        {
            details.BSI = BSI;
        }
        
        return details;
        
    }
    
    return nil;
}


+ (MyPolicyModel *)getPolicyHistoryDetailsByResponse:(NSDictionary *)response
{
    if (response != nil && [response isKindOfClass:[NSDictionary class]]) {
        MyPolicyModel *details = [[MyPolicyModel alloc]init];
        
        NSString *claimNumber = ([[response valueForKey:kClaimNumber] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kClaimNumber];
        
        if (claimNumber != nil && [claimNumber isKindOfClass:[NSString class]]) {
            
            details.claimNumber = claimNumber;
        }
        
        NSString *dateOfLoss = ([[response valueForKey:kDateOfLoss] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kDateOfLoss];
        
        if (dateOfLoss != nil && [dateOfLoss isKindOfClass:[NSString class]]) {
            
            details.dateOfLoss = dateOfLoss;
        }
        
        NSString *hospitalName = ([[response valueForKey:kClaimHospitalName] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kClaimHospitalName];
        
        if (hospitalName != nil && [hospitalName isKindOfClass:[NSString class]]) {
            
            details.hospitalName = hospitalName;
        }
        
        NSString *memberName = ([[response valueForKey:kMemeberName] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kMemeberName];
        
        if (memberName != nil && [memberName isKindOfClass:[NSString class]]) {
            
            details.policyMemberName = memberName;
        }
        
        NSString *claimType = ([[response valueForKey:kClaimType] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kClaimType];
        
        if (claimType != nil && [claimType isKindOfClass:[NSString class]]) {
            
            details.claimType = claimType;
        }
        
        
        NSString *claimStatus = ([[response valueForKey:kClaimStatus] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kClaimStatus];
        
        if (claimStatus != nil && [claimStatus isKindOfClass:[NSString class]]) {
            
            details.claimStatus = claimStatus;
        }
        
        NSString *dateOfIntimation = ([[response valueForKey:kDateOfIntimation] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kDateOfIntimation];
        
        if (dateOfIntimation != nil && [dateOfIntimation isKindOfClass:[NSString class]]) {
            
            details.dateOfIntimation = dateOfIntimation;
        }
        
        NSString *paymentAmount = ([[response valueForKey:kPaymentAmount] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kPaymentAmount];
        
        if (paymentAmount != nil && [paymentAmount isKindOfClass:[NSString class]]) {
            
            details.paymentAmount = paymentAmount;
        }
        
        NSString *totalRequestedAmount = ([[response valueForKey:kTotalRequestedAmount] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kTotalRequestedAmount];
        
        if (totalRequestedAmount != nil && [totalRequestedAmount isKindOfClass:[NSString class]]) {
            
            details.totalRequestedAmount = totalRequestedAmount;
        }
        
        return details;
        
    }
    
    return nil;
}



@end
