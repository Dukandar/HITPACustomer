//
//  ClaimsJunction.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "ClaimsJunction.h"
#import "MyPolicyModel.h"
#import "CoreData.h"

NSString * const kClaimsDateOfAdmission           = @"DateOfAdmission";
NSString * const kClaimsDateOfDischarge           = @"DateOfDischarge";
NSString * const kClaimsDiagnosis                 = @"Diagnosis";
NSString * const kClaimsEstimatedExpense          = @"EstimatedExpense";
NSString * const kClaimsHospitalName              = @"HospitalName";
NSString * const kClaimsPatientName               = @"PatientName";
NSString * const kClaimsContactNumber             = @"Contactno";
NSString * const kClaimsEmail                     = @"Email";
NSString * const kClaimsDateTime                  = @"dateTime";
NSString * const kClaimsStatus                    = @"ClaimTransactionStatus";
NSString * const kClaimsConsumed                  = @"consumed";
NSString * const kClaimsCoverage                  = @"coverage";
NSString * const kClaimsPaymentAmount             = @"paymentAmount";
NSString * const kClaimsNumber                    = @"ClaimRefNumber";
NSString * const kClaimsType                      = @"ClaimType";
NSString * const kClaimsSubType                   = @"ClaimSubType";
NSString * const kclaimsUHID                      = @"UHID";
NSString * const kClaimsFeedbackStatus            = @"isFeedBackReceived";
NSString * const kClaimPolicyNumber               = @"policyNumber";
NSString * const kClaimRelationship               = @"relationship";
NSString * const kClaimPaidAmount                 = @"PaidAmount";
NSString * const kClaimPaidDate                   = @"PaidDate";
NSString * const kClaimBankName                   = @"BankName";
NSString * const kClaimAccountNumber              = @"AccountNumber";
NSString * const kClaimUTRNo                      = @"UTRNo";
NSString * const kTDSDeducted                     = @"TDSDeducted";
NSString * const kBranch                          = @"BranchName";


@implementation ClaimsJunction

+ (ClaimsJunction *)getClaimsHistoryDetailsByResponse:(NSDictionary *)response
{
 
    if (response != nil || [response isKindOfClass:[NSDictionary class]]) {
        ClaimsJunction *details = [[ClaimsJunction alloc]init];
        
        NSString *dateOfAdmission = [response valueForKey:kClaimsDateOfAdmission];
        
        if (dateOfAdmission != nil || [dateOfAdmission isKindOfClass:[NSString class]]) {
            
            details.dateOfAdmission = dateOfAdmission;
        }
        
        NSString *dateTime = [response valueForKey:kClaimsDateTime];
        
        if (dateTime != nil || [dateTime isKindOfClass:[NSString class]]) {
            
            details.dateTime = dateTime;
        }
        
        NSString *consumed = [response valueForKey:kClaimsConsumed];
        
        if (consumed != nil || [consumed isKindOfClass:[NSString class]]) {
            
            details.consumed = consumed;
        }
        
        NSString *uhid = [response valueForKey:kclaimsUHID];
        
        if (uhid != nil || [uhid isKindOfClass:[NSString class]]) {
            
            details.claimsUHID = uhid;
        }
        
        NSString *paymentAmount = [response valueForKey:kClaimsPaymentAmount];

        if (paymentAmount != nil || [paymentAmount isKindOfClass:[NSString class]]) {
            
            details.paymentAmount = paymentAmount;
        }
        
        NSString *coverage = [response valueForKey:kClaimsCoverage];
        
        if (coverage != nil || [coverage isKindOfClass:[NSString class]]) {
            
            details.coverage = coverage;
        }
        
        NSString *claimsFeedbackStatus = [response valueForKey:kClaimsFeedbackStatus];
        
        if (claimsFeedbackStatus != nil || [claimsFeedbackStatus isKindOfClass:[NSString class]]) {
            
            details.claimsFeedbackStatus = claimsFeedbackStatus;
        }
        
        NSString *claimNumber = [response valueForKey:kClaimsNumber];
        
        if (claimNumber != nil || [claimNumber isKindOfClass:[NSString class]]) {
            
            details.claimNumber = claimNumber;
        }

        NSString *claimStatus = [response valueForKey:kClaimsStatus];
        
        if (claimStatus != nil || [claimStatus isKindOfClass:[NSString class]]) {
            
            details.claimStatus = claimStatus;
        }
        
        NSString *claimType = [response valueForKey:kClaimsType];
        
        if (claimType != nil || [claimType isKindOfClass:[NSString class]]) {
            
            details.claimType = claimType;
        }
        
        NSString *claimSubType = [response valueForKey:kClaimsSubType];
        
        if (claimSubType != nil || [claimSubType isKindOfClass:[NSString class]]) {
            
            details.claimSubType = claimSubType;
        }
        
        NSString *dateOfDischarge = [response valueForKey:kClaimsDateOfDischarge];
        
        if (dateOfDischarge != nil || [dateOfDischarge isKindOfClass:[NSString class]]) {
            
            details.dateOfDischarge = dateOfDischarge;
        }
        
        NSString *diagnosis = [response valueForKey:kClaimsDiagnosis];
        
        if (diagnosis != nil || [diagnosis isKindOfClass:[NSString class]]) {
            
            details.diagnosis = diagnosis;
        }
        
        NSString *estimatedExpense = [response valueForKey:kClaimsEstimatedExpense];
        
        if (estimatedExpense != nil || [estimatedExpense isKindOfClass:[NSString class]]) {
            
            details.estimatedExpense = estimatedExpense;
        }
        
        NSString *hospitalName = [response valueForKey:kClaimsHospitalName];
        
        if (hospitalName != nil || [hospitalName isKindOfClass:[NSString class]]) {
            
            details.hospitalName = hospitalName;
        }
        
        NSString *patientName = [response valueForKey:kClaimsPatientName];
        
        if (patientName != nil || [patientName isKindOfClass:[NSString class]]) {
            
            details.patientName = patientName;
        }
        
        
        NSString *contactNumber = [response valueForKey:kClaimsContactNumber];
        
        if (contactNumber != nil || [contactNumber isKindOfClass:[NSString class]]) {
            
            details.contactNumber = contactNumber;
        }
        
        NSString *email = [response valueForKey:kClaimsEmail];
        
        if (email != nil || [email isKindOfClass:[NSString class]]) {
            
            details.emailID = email;
        }
        
        NSString *paidAmount = [response valueForKey:kClaimPaidAmount];
        
        if (paidAmount != nil || [paidAmount isKindOfClass:[NSString class]]) {
            
            details.paidAmount = paidAmount;
        }
        
        NSString *paidDate = [response valueForKey:kClaimPaidDate];
        
        if (paidDate != nil || [paidDate isKindOfClass:[NSString class]]) {
            
            details.paidDate = paidDate;
        }
        
        NSString *bankName = [response valueForKey:kClaimBankName];
        
        if (bankName != nil || [bankName isKindOfClass:[NSString class]]) {
            
            details.bankName = bankName;
        }
        
        NSString *accountNumber = [response valueForKey:kClaimAccountNumber];
        
        if (accountNumber != nil || [accountNumber isKindOfClass:[NSString class]]) {
            
            details.accountNumber = accountNumber;
        }
        
        NSString *utrNo = [response valueForKey:kClaimUTRNo];
        
        if (utrNo != nil || [utrNo isKindOfClass:[NSString class]]) {
            
            details.UTRNo = utrNo;
        }

        NSString *tdsDeducted = [response valueForKey:kTDSDeducted];
               
        if (tdsDeducted != nil || [tdsDeducted isKindOfClass:[NSString class]]) {
               
            details.TDSDeducted = tdsDeducted;
        }
        
        NSString *branch = [response valueForKey:kBranch];
               
        if (branch != nil || [branch isKindOfClass:[NSString class]]) {
               
            details.branch = branch;
        }
        
        if ([[ClaimsJunction getPolicyNumberWithPatientName:details.patientName] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictioanry = [ClaimsJunction getPolicyNumberWithPatientName:details.patientName];
            details.policyNumber = [dictioanry valueForKey:@"policyNumber"];
            details.relationship = [dictioanry valueForKey:@"relationship"];
        }
        
        return details;
        
    }
    
    return nil;
    
}


//TODO : Need to change

+ (NSDictionary *)getPolicyNumberWithPatientName:(NSString *)patientName
{
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        
        MyPolicyModel *myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:[[CoreData shareData] getPolicyDetail]];
        NSString *predicateFormate = @"%K CONTAINS[cd] %@";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormate,@"MemberName",patientName];
        NSArray *memberDetails = myPolicyDetails.memberDetails;
        memberDetails = [memberDetails filteredArrayUsingPredicate:predicate];
        return [[NSDictionary alloc]initWithObjectsAndKeys:myPolicyDetails.policyNumber,@"policyNumber",([memberDetails count] > 0)?[[memberDetails objectAtIndex:0] valueForKey:@"MemberRelationship"]:@"NA",@"relationship", nil];
    }
    return nil;
}


@end
