//
//  UserManager.h
//  HITPA
//
//  Created by Bathi Babu on 03/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject


+ (UserManager *)sharedUserManager;

- (BOOL) isValidUser;

@property (nonatomic, readwrite) BOOL isSuccess;

@property (nonatomic, strong) NSString *userName, *type;
@property (strong, nonatomic) NSString *policyNumber;
@property (strong, nonatomic) NSString *policyType;
@property (strong, nonatomic) NSString *emailID;
@property (strong, nonatomic) NSString *contactNo;
@property (strong, nonatomic) NSString *employeeId;
@property (strong, nonatomic) NSString *authToken;

- (void)populateUserInfoFromResponse:(NSDictionary *)response username:(NSString *)userName isSuccess:(BOOL)isSuccess authToken:(NSString *)authToken;

- (void)clearUser;

@end
