//
//  Helper.m
//  HITPA
//
//  Created by Selma D. Souza on 09/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "Helper.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import <UIKit/UIKit.h>
#import "UserManager.h"

@implementation Helper

+ (Helper *)shareHelper
{
    
    static Helper *_shareHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareHelper = [[Helper alloc]init];
        
    });
    
    return _shareHelper;
    
}

#pragma mark - Raise grievance

- (BOOL)validateGrievanceWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    if ([[parmas valueForKey:@"GrievanceType"] length] <=0)
    {
        [errorMessage addObject:@"Enter complaint type"];
    }
    if ([[parmas valueForKey:@"Complaint"] length] <=0)
    {
        [errorMessage addObject:@"Enter complaint sub-type"];
    }
    if (([[parmas valueForKey:@"ClaimNo"] length] <=0) && ([[parmas valueForKey:@"GrievanceType"] isEqualToString:@"Claims Related"]))
    {
        [errorMessage addObject:@"Enter claim number"];

    }
    if ([[parmas valueForKey:@"ServiceRequestDetails"] length] <=0)
    {
        [errorMessage addObject:@"Enter complaint remark"];
    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
}

#pragma mark- Raise Claim

- (BOOL)validateRiaseClaimWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    if ([[parmas valueForKey:@"ProviderName"] length] <=0)
    {
        [errorMessage addObject:@"Enter hospital name"];
    }
    if ([[parmas valueForKey:@"HospitalCode"] length] <=0)
    {
        [errorMessage addObject:@"Enter hospital code"];
        
    }
    if ([[parmas valueForKey:@"PatientName"] length] <=0)
    {
        [errorMessage addObject:@"Enter patient name"];
    }
    
    if ([[parmas valueForKey:@"Contactno"] length] <=0)
    {
        [errorMessage addObject:@"Enter contact number"];
    }
    
    if ([[parmas valueForKey:@"Email"] length] <=0)
    {
        [errorMessage addObject:@"Enter email"];
    }
    
    if ([[parmas valueForKey:@"ClaimType"] length] <=0)
    {
        [errorMessage addObject:@"Enter claim type"];
    }
    
    if ([[parmas valueForKey:@"Ailment"] length] <=0)
    {
        [errorMessage addObject:@"Enter diagnosis"];
    }
    
    if ([[parmas valueForKey:@"DateOfAdmission"] length] <=0)
    {
        [errorMessage addObject:@"Enter date of admission"];
    }
    
    if ([[parmas valueForKey:@"DateOfDischarge"] length] <=0)
    {
        [errorMessage addObject:@"Enter date of discharge"];
    }
    
    if ([[parmas valueForKey:@"EstimatedExpense"] length] <=0)
    {
        [errorMessage addObject:@"Enter estimated expense"];
    }
    
//    if ([[parmas valueForKey:@"Remarks"] length] <=0)
//    {
//        [errorMessage addObject:@"Enter remarks"];
//    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
    
}

#pragma mark - Login

- (BOOL)validateLoginWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    
    if ([[parmas valueForKey:@"username"] length] <=0)
    {
        [errorMessage addObject:@"Please enter username"];
        
    }
    if ([[parmas valueForKey:@"password"] length] <=0)
    {
        [errorMessage addObject:@"Please enter password"];
    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
}

#pragma mark - Change Password

- (BOOL)validateChangePasswordWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    if ([[parmas valueForKey:@"OldPassword"] length] <=0)
        [errorMessage addObject:@"Enter old password"];
    
    if([[parmas valueForKey:@"NewPassword"] length] <= 0){
        [errorMessage addObject:@"Enter new password"];
    }
    
    if([[parmas valueForKey:@"ConfirmPassword"] length] <= 0){
        [errorMessage addObject:@"Enter confirm password"];
    }
    
    if (errorMessage.count == 1 && [[parmas valueForKey:@"ConfirmPassword"] length] <=0) {
        if([[parmas valueForKey:@"NewPassword"] length] != 0 && [[parmas valueForKey:@"NewPassword"] length] < 6) {
            [errorMessage removeAllObjects];
            [errorMessage addObject:@"Password must contain atleast 6 characters"];
            *error = errorMessage;
        }
    }
    else if (errorMessage.count == 0) {
        if([[parmas valueForKey:@"NewPassword"] length] != 0 && [[parmas valueForKey:@"NewPassword"] length] < 6) {
            [errorMessage addObject:@"Password must contain atleast 6 characters"];
            *error = errorMessage;
        }
        else
        {
            if(![[parmas valueForKey:@"NewPassword"] isEqualToString:[parmas valueForKey:@"ConfirmPassword"]]){
                [errorMessage addObject:@"New password and confirm password do not match"];
            }
            *error = errorMessage;
        }
    }
    else
        *error = errorMessage;
    
   /* if ([[parmas valueForKey:@"OldPassword"] length] <=0) {
        [errorMessage addObject:@"Enter old password"];
        if([[parmas valueForKey:@"NewPassword"] length] <= 0){
            [errorMessage addObject:@"Enter new password"];
        }
        if([[parmas valueForKey:@"NewPassword"] length] <= 0){
            [errorMessage addObject:@"Enter confirm password"];
        }
    }
    else{
        if([[parmas valueForKey:@"NewPassword"] length] <= 0){
            [errorMessage addObject:@"Enter new password"];
        }
        if([[parmas valueForKey:@"NewPassword"] length] <= 0){
            [errorMessage addObject:@"Enter confirm password"];
        }
        
        
    }
    if ([[parmas valueForKey:@"NewPassword"] length] >=1 && [[parmas valueForKey:@"NewPassword"] length] <= 5){
        [errorMessage addObject:@"New Password length is minimum 6 characters"];
    }
    if([[parmas valueForKey:@"NewPassword"] length]>=6 && [[parmas valueForKey:@"ConfirmPassword"] length] <= 0){
        [errorMessage addObject:@"Enter confirm password"];
        
    }
    else if([[parmas valueForKey:@"NewPassword"] length]>=6)
    {
        if([parmas valueForKey:@"NewPassword"] != [parmas valueForKey:@"ConfirmPassword"]){
            [errorMessage addObject:@"New Password and Confirm Password are different"];
        }
    }*/
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
}

#pragma mark - Forgot password
- (BOOL)validateForgotPasswordWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    
    if ([[parmas valueForKey:@"username"] length] <=0)
    {
        [errorMessage addObject:@"Please enter username"];
        
    }
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;

}

#pragma mark -

- (BOOL)validateClaimSearchAllEntriesWithError:(NSArray **)error params:(NSString *)searchText
{
    
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    
    if (searchText == nil || [searchText  length] <=0)
    {
        [errorMessage addObject:@"Enter hospital name"];
        [errorMessage addObject:@"or Enter pincode"];
        [errorMessage addObject:@"or Enter city"];
    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
    
}

- (NSString *)getErrorStringFromErrorDescription:(NSArray *)error
{
    
    __block NSString *errorString = @"";
    
    [error enumerateObjectsUsingBlock:^(id obj,NSUInteger idex,BOOL *stop){
        
        if ([obj isKindOfClass:[NSString class]])
        {
            errorString = [errorString stringByAppendingFormat:@"- %@\n",(NSString *)obj];
        }
        
    }];
    
    return NSLocalizedString(errorString, @"");
    
}

- (BOOL)validateSectionWithError:(NSArray **)error params:(NSMutableDictionary *)params
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    if ([params objectForKey:@"hospitalName"] == nil || [[params objectForKey:@"hospitalName"] length] <=0)
    {
        if (([params objectForKey:@"pincode"] == nil || [[params objectForKey:@"pincode"] length] <=0) && ([params objectForKey:@"city"] == nil || [[params objectForKey:@"city"] length] <=0))
        {
            [errorMessage addObject:@"Please fill hospital details before proceeding"];
        }
        
    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
    
}


#pragma mark - Email Validation

- (BOOL)emailValidationWithEmail:(NSString *)emailString
{
    if (emailString != nil)
    {
        NSString *emailRegEx = @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-"
        @"zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        return [regExPredicate evaluateWithObject:emailString];
    }
    
    return NO;
    
}

#pragma mark - Email validation
- (BOOL)validateRegistrationWithWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    if ([[parmas valueForKey:@"Type"] isEqualToString:@"Retail"])
    {
        //** Old Code **//
        /*
         if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length]<= 0) {
         [errorMessage addObject:@"Enter valid Policy Number"];
         [errorMessage addObject:@"or UHID"];
         }
         
         if (errorMessage.count == 0) {
         
         if(![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]] && ![[parmas valueForKey:@"PolicyNumber"] isEqualToString:@""] && ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
         [errorMessage addObject:@"Enter valid policy number"];
         
         if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]] && ![[parmas valueForKey:@"Uhid"] isEqualToString:@""]) {
         [errorMessage addObject:@"or UHID"];
         *error = errorMessage;
         }
         *error = errorMessage;
         }
         else {
         if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]] && ![[parmas valueForKey:@"Uhid"] isEqualToString:@""] && ![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]]) {
         [errorMessage addObject:@"Enter valid policy number or UHID"];
         *error = errorMessage;
         }
         }
         }
         */
        //** Policy Number or UHID **//
        if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length]<= 0) {
            [errorMessage addObject:@"Enter valid Policy Number or UHID"];
        }
        else if ([[parmas valueForKey:@"PolicyNumber"]length] > 0 && [[parmas valueForKey:@"Uhid"]length] > 0) {
            
            if(![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]] || ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
                [errorMessage addObject:@"Enter valid Policy Number or UHID"];
            }
        }
        else if ([[parmas valueForKey:@"PolicyNumber"]length] > 0 && ![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]]) {
            [errorMessage addObject:@"Enter valid Policy Number"];
        }
        else if([[parmas valueForKey:@"Uhid"]length] > 0 && ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
            [errorMessage addObject:@"Enter valid UHID"];
        }
    }
    
    else if ([[parmas valueForKey:@"Type"] isEqualToString:@"Corporate"])
    {
        //** Old Code **//
        /*
         if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0 && [[parmas valueForKey:@"EmployeeId"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length] <= 0) {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         else if ([[parmas valueForKey:@"PolicyNumber"]length] > 0 && [[parmas valueForKey:@"EmployeeId"]length] > 0 && [[parmas valueForKey:@"Uhid"]length] > 0) {
         
         if((![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]] && ![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]]) || ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         else if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0 && [[parmas valueForKey:@"EmployeeId"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length] > 0) {
         if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         else if ([[parmas valueForKey:@"PolicyNumber"]length] > 0) {
         if([[parmas valueForKey:@"EmployeeId"]length] > 0) {
         if(![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]] && ![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]]) {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         else if([[parmas valueForKey:@"Uhid"]length] > 0) {
         if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]){
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         else {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         } else if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0) {
         if([[parmas valueForKey:@"Uhid"]length] > 0) {
         if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         else {
         [errorMessage addObject:@"Enter valid policy number and employee ID or UHID"];
         }
         }
         */
        //** Policy Number is Mandatory and either employee ID or UHID **//
        if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0 && [[parmas valueForKey:@"EmployeeId"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length] <= 0) {
            [errorMessage addObject:@"Enter valid Policy Number and Employee ID or UHID"];
        } else if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0) {
            [errorMessage addObject:@"Enter valid Policy Number"];
        }
        else if ([[parmas valueForKey:@"PolicyNumber"]length] > 0) {
            
            if(![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]]) {
                [errorMessage addObject:@"Enter valid Policy Number "];
            }
            else if ([[parmas valueForKey:@"EmployeeId"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length] <= 0) {
                [errorMessage addObject:@"Enter valid Employee ID or UHID"];
            }
            else if([[parmas valueForKey:@"EmployeeId"]length] > 0 && ![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]]) {
                    [errorMessage addObject:@"Enter valid Employee ID"];
            } else if([[parmas valueForKey:@"Uhid"]length] > 0 && ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
                    [errorMessage addObject:@"Enter valid UHID"];
            }  else if ([[parmas valueForKey:@"EmployeeId"]length] > 0 && [[parmas valueForKey:@"Uhid"]length] > 0) {
                  if(![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]] || ![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]) {
                      [errorMessage addObject:@"Enter valid Employee ID or UHID"];
                  }
              }
        }
    }
    
    
    /*if ([[parmas valueForKey:@"PolicyNumber"]length] <= 0) {
     [errorMessage addObject:@"Enter valid policy Number"];
     }
     if ([[parmas valueForKey:@"EmployeeId"]length] <= 0 && [[parmas valueForKey:@"Uhid"]length] <= 0) {
     [errorMessage addObject:@"Enter employee ID"];
     [errorMessage addObject:@"or UHID"];
     }
     
     if (errorMessage.count == 0) {
     if(![[parmas valueForKey:@"PolicyNumber"] isEqualToString:[[UserManager sharedUserManager] policyNumber]]) {
     [errorMessage addObject:@"Enter valid policy number"];
     *error = errorMessage;
     }
     
     if(![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]] && ![[parmas valueForKey:@"EmployeeId"] isEqualToString:@""] && (![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]]|| [[parmas valueForKey:@"Uhid"] isEqualToString:@""])) {
     [errorMessage addObject:@"Enter valid employee ID"];
     
     if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]] && ![[parmas valueForKey:@"Uhid"] isEqualToString:@""]) {
     [errorMessage addObject:@"or UHID"];
     *error = errorMessage;
     }
     *error = errorMessage;
     }
     else {
     if(![[parmas valueForKey:@"Uhid"] isEqualToString:[[UserManager sharedUserManager] userName]] && ![[parmas valueForKey:@"Uhid"] isEqualToString:@""] && ![[parmas valueForKey:@"EmployeeId"] isEqualToString:[[UserManager sharedUserManager] employeeId]]) {
     [errorMessage addObject:@"Enter valid Employee ID or UHID"];
     *error = errorMessage;
     }
     }
     
     }
     
     }*/
    
    
    *error = errorMessage;
    return [errorMessage count]>0?NO:YES;
}


- (BOOL)validateBMIWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    
    if ([[parmas valueForKey:@"weight"] length] <=0)
    {
        [errorMessage addObject:@"Please enter weight"];
        
    }
    
    if ([[parmas valueForKey:@"cms"] length] <=0 && [[parmas valueForKey:@"feet"] length] <=0 && [[parmas valueForKey:@"inches"] length] <=0)
    {
        [errorMessage addObject:@"Please enter height"];
        
    }
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
}

- (BOOL)validateCalendarEventWithError:(NSArray **)error parmas:(NSMutableDictionary *)parmas
{
    NSMutableArray *errorMessage = [[NSMutableArray alloc]init];
    
    
    if ([[parmas valueForKey:@"eventTitle"] length] <=0)
    {
        [errorMessage addObject:@"Please enter event title"];
        
    }
    
    *error = errorMessage;
    
    return [errorMessage count] > 0 ? NO : YES;
    
}

#pragma mark - DeviceUDID
-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    
    return strApplicationUUID;
}


@end
