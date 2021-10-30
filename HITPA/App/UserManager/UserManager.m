//
//  UserManager.m
//  HITPA
//
//  Created by Bathi Babu on 03/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "UserManager.h"
#import "HITPAUserDefaults.h"

NSString * const kUserPolicyNumber         = @"PolicyNo";
NSString * const kUserPolicyType           = @"PolicyType";
NSString * const kUserEmail                = @"Email";
NSString * const kUserContactNo            = @"PhoneNumber";
NSString * const kUserEmpId                = @"EmployeeID";
NSString * const kAuthToken                = @"AuthToken";

@implementation UserManager


#pragma mak - 

+ (UserManager *)sharedUserManager
{
    
    
    static UserManager *_sharedUserManager = nil;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
       
        _sharedUserManager = [[UserManager alloc]init];
        
    });
    
    
    return _sharedUserManager;
}


- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self getUserInfo];
    }
    
    return self;
    
}

- (BOOL) isValidUser
{
    return self.isSuccess;
}

- (void)populateUserInfoFromResponse:(NSDictionary *)response username:(NSString *)userName isSuccess:(BOOL)isSuccess authToken:(NSString *)authToken
{
    
    if (response != nil && [response isKindOfClass:[NSDictionary class]]) {
        
        self.userName = userName;
        self.isSuccess = isSuccess;

        NSString *policyNumber = [response valueForKey:kUserPolicyNumber];
        
        if (policyNumber != nil || [policyNumber isKindOfClass:[NSString class]]){
            
            self.policyNumber = (policyNumber == (id)[NSNull null]) ? @"" : policyNumber;
        }
        
        NSString *policyType = [response valueForKey:kUserPolicyType];
        
        if (policyType != nil || [policyType isKindOfClass:[NSString class]]) {
            
            self.policyType =  policyType;
        }

        NSString *contactNo = [response valueForKey:kUserContactNo];
        
        if (contactNo != nil || [contactNo isKindOfClass:[NSString class]]) {
            
            self.contactNo = contactNo;
        }

        NSString *email = [response valueForKey:kUserEmail];
        
        if (email != nil || [email isKindOfClass:[NSString class]]) {
            
            self.emailID = email;
        }

        NSString *empId = [response valueForKey:kUserEmpId];
        
        if (empId != nil || [empId isKindOfClass:[NSString class]]) {
            
            self.employeeId = empId;
        }
        
        NSString *authToken = [response valueForKey:kAuthToken];
        
        if (authToken != nil || [authToken isKindOfClass:[NSString class]]) {
            
            self.authToken = authToken;
        }

    }
    
    if (self.isSuccess) {
        [self saveUser];
    }
    
}


- (void)saveUser
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setValue:[NSNumber numberWithBool:self.isSuccess] forKey:@"success"];
    [userInfo setValue:self.userName forKey:@"username"];
    [userInfo setValue:self.policyNumber forKey:@"policyNumber"];
    [userInfo setValue:self.authToken forKey:@"authToken"];
    
    [[HITPAUserDefaults shareUserDefaluts] setValue:userInfo forKey:@"userinfo"];
    [[HITPAUserDefaults shareUserDefaluts] synchronize];
    
}

- (void)getUserInfo
{
    
    NSMutableDictionary *userInfo = [[HITPAUserDefaults shareUserDefaluts] valueForKey:@"userinfo"];
    self.isSuccess = [userInfo valueForKey:@"success"];
    self.userName = [userInfo valueForKey:@"username"];
    self.policyNumber = [userInfo valueForKey:@"policyNumber"];
    self.authToken = [userInfo valueForKey:@"authToken"];
    
}

- (void)clearUser
{
    self.isSuccess = NO;
    self.userName = @"";
    self.policyNumber = @"";
    self.authToken = @"";
    [[HITPAUserDefaults shareUserDefaluts] removeObjectForKey:@"userinfo"];
    [[HITPAUserDefaults shareUserDefaluts] synchronize];
    
}

@end
