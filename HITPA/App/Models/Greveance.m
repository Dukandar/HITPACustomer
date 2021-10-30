//
//  Greveance.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "Greveance.h"

NSString * const kAssignFromUser                     = @"AssignFromUser";
NSString * const kAssignToTeam                       = @"AssignToTeam";
NSString * const kCallType                           = @"CallType";
NSString * const kChannel                            = @"Channel";
NSString * const kComplaint                          = @"Complaint";
NSString * const kGrievanceReqDate                   = @"GrievanceReqDate";
NSString * const kGrievanceType                      = @"GrievanceType";
NSString * const kPolicyNo                           = @"PolicyNo";
NSString * const kServiceRequestDetails              = @"ServiceRequestDetails";
NSString * const kServiceRequestId                   = @"ServiceRequestId";
NSString * const kServiceRequestStatus               = @"ServiceRequestStatus";
NSString * const kServiceRequestSubType              = @"ServiceRequestSubType";
NSString * const kServiceRequestType                 = @"ServiceRequestType";
NSString * const kTAT                                = @"TAT";

NSString * const kAssignTo                           = @"AssignTo";
NSString * const kGrvRequestId                       = @"GrvRequestId";
NSString * const kModifiedDateTIme                   = @"ModifiedDateTIme";
NSString * const kReferenceID                        = @"ReferenceID";
NSString * const kRemarks                            = @"Remarks";
NSString * const kRequestResponseType                = @"RequestResponseType";
NSString * const kStatus                             = @"Status";
NSString * const kUserName                           = @"UserName";

NSString * const kGrievanceHistory                   = @"GrievanceHistory";

@implementation Greveance


+ (Greveance *)grivanceWithResponse:(NSDictionary *)response
{
    
    if (response != nil && [response isKindOfClass:[NSDictionary class]])
    {
        Greveance *grievance = [[Greveance alloc]init];
        
        NSString *assignFromUser = ([[response valueForKey:kAssignFromUser] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kAssignFromUser];
        if (assignFromUser != nil && [assignFromUser length] > 0)
        {
            grievance.assignFromUser = assignFromUser;
        }
        
        NSString *assignToTeam = ([[response valueForKey:kAssignToTeam] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kAssignToTeam];
        if (assignToTeam != nil && [assignToTeam length] > 0)
        {
            grievance.assignToTeam = assignToTeam;
        }
        
        NSString *callType = ([[response valueForKey:kCallType] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kCallType];
        if (callType != nil && [callType length] > 0)
        {
            grievance.callType = callType;
        }
        
        NSString *channel = ([[response valueForKey:kChannel] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kChannel];
        if (channel != nil && [channel length] > 0)
        {
            grievance.channel = channel;
        }
        
        NSString *complaint = ([[response valueForKey:kComplaint] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kComplaint];
        if (complaint != nil && [complaint length] > 0)
        {
            grievance.complaint = complaint;
        }
        
        NSString *grievanceReqDate = ([[response valueForKey:kGrievanceReqDate] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kGrievanceReqDate];
        if (grievanceReqDate != nil && [grievanceReqDate length] > 0)
        {
            grievance.grievanceReqDate = grievanceReqDate;
        }
        
        NSString *grievanceType = ([[response valueForKey:kGrievanceType] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kGrievanceType];
        if (grievanceType != nil && [grievanceType length] > 0)
        {
            grievance.grievanceType = grievanceType;
        }
        
        NSString *policyNo = ([[response valueForKey:kPolicyNo] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kPolicyNo];
        if (policyNo != nil && [policyNo length] > 0)
        {
            grievance.policyNo = policyNo;
        }
        
        NSString *serviceRequestDetails = ([[response valueForKey:kServiceRequestDetails] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kServiceRequestDetails];
        if (serviceRequestDetails != nil && [serviceRequestDetails length] > 0)
        {
            grievance.serviceRequestDetails = serviceRequestDetails;
        }
        
        NSString *serviceRequestId = ([[response valueForKey:kServiceRequestId] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kServiceRequestId];
        if (serviceRequestId != nil && [serviceRequestId length] > 0)
        {
            grievance.serviceRequestId = serviceRequestId;
        }
        
        NSString *serviceRequestStatus = ([[response valueForKey:kServiceRequestStatus] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kServiceRequestStatus];
        if (serviceRequestStatus != nil && [serviceRequestStatus length] > 0)
        {
            grievance.serviceRequestStatus = serviceRequestStatus;
        }
        
        NSString *serviceRequestSubType = ([[response valueForKey:kServiceRequestSubType] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kServiceRequestSubType];
        if (serviceRequestSubType != nil && [serviceRequestSubType length] > 0)
        {
            grievance.serviceRequestSubType = serviceRequestSubType;
        }
        
        NSString *ServiceRequestType = ([[response valueForKey:kServiceRequestType] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kServiceRequestType];
        if (ServiceRequestType != nil && [ServiceRequestType length] > 0)
        {
            grievance.serviceRequestType = ServiceRequestType;
        }
        
        NSString *tAT = ([[response valueForKey:kTAT] isKindOfClass:[NSNull class]])?@"":[response valueForKey:kTAT];
        if (tAT != nil && [tAT length] > 0)
        {
            grievance.tAT = tAT;
        }
        
       
        
        NSString *assignTo =  [[[response valueForKey:kGrievanceHistory] valueForKey:kAssignTo] isKindOfClass:[NSNull class]] ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kAssignTo] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kAssignTo] objectAtIndex:0]);
        if (assignTo != nil && [assignTo length] > 0)
        {
            grievance.assignTo = assignTo;
        }
        
        NSNumber *myNumber = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kGrvRequestId] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kGrvRequestId] objectAtIndex:0]);
        
        NSString *grvRequestId = [myNumber stringValue];
        if (grvRequestId != nil && [grvRequestId length] > 0)
        {
            grievance.grvRequestId = grvRequestId;
        }
        
        NSString *modifiedDateTIme = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kModifiedDateTIme] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kModifiedDateTIme] objectAtIndex:0]);
        if (modifiedDateTIme != nil && [modifiedDateTIme length] > 0)
        {
            grievance.modifiedDateTIme = modifiedDateTIme;
        }
        
        NSString *referenceID = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA": (([[[[response valueForKey:kGrievanceHistory] valueForKey:kReferenceID] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kReferenceID] objectAtIndex:0]));
        if (referenceID != nil && [referenceID length] > 0)
        {
            grievance.referenceID = referenceID;
        }
        
        NSString *remarks = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kRemarks] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kRemarks] objectAtIndex:0]);
        if (remarks != nil && [remarks length] > 0)
        {
            grievance.remarks = remarks;
        }
        
        NSString *requestResponseType = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kRequestResponseType] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"":[[[response valueForKey:kGrievanceHistory] valueForKey:kRequestResponseType] objectAtIndex:0]);
        if (requestResponseType != nil && [requestResponseType length] > 0)
        {
            grievance.requestResponseType = requestResponseType;
        }
        
        NSString *status = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kStatus] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kStatus] objectAtIndex:0]);
        if (status != nil && [status length] > 0)
        {
            grievance.status = status;
        }
        
        NSString *userName = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[[[response valueForKey:kGrievanceHistory] valueForKey:kUserName] objectAtIndex:0] isKindOfClass:[NSNull class]])?@"NA":[[[response valueForKey:kGrievanceHistory] valueForKey:kUserName] objectAtIndex:0]);
        if (userName != nil && [userName length] > 0)
        {
            grievance.userName = userName;
        }
        
        NSArray *grievanceHistory = ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]) ? @"NA" : (([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]])?@"NA":[response valueForKey:kGrievanceHistory]);
        if ([[response valueForKey:kGrievanceHistory] isKindOfClass:[NSNull class]]){
            
        }else{
            if (grievanceHistory != nil && [grievanceHistory count] > 0)
                {
                    grievance.grievanceHistory = grievanceHistory;
                }
        }
        return grievance;
        
    }
    
    
    return nil;
    
}


@end
