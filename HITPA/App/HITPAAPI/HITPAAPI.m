//
//  HITPAAPI.m
//  HITPA
//
//  Created by Bhaskar C M on 12/22/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

// comment to test

#import "HITPAAPI.h"
#import "Configuration.h"
#import "UserManager.h"

NSString *const requestTypePost = @"POST";
NSString *const requestTypeGet  = @"GET";
NSString *const ContentType     = @"Content-Type";
NSString *const ContentLenght   = @"Content-Length";
NSString * const boundary = @"unique-consistent-string";

@implementation HITPAAPI

#pragma mark - ShareAPI

+ (HITPAAPI *)shareAPI
{
    static HITPAAPI *_shareAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareAPI = [[HITPAAPI alloc]init];
    });
    
    return _shareAPI;
}


#pragma mark - Login 

- (void)loginWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apicompletionHandler
{
    [self postUrlRequestWithParams:params withCompletionHandler:apicompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/GetLoginDetails?username=%@&password=%@", [params valueForKey:@"username"], [params valueForKey:@"password"]]];
//    [self getUrlRequestStringWithCompletionHandler:apicompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/GetLoginDetails?username=%@&password=%@", [params valueForKey:@"username"], [params valueForKey:@"password"]]];
    
}

#pragma mark - Forgot Password With Params
- (void)forgotPasswordWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestStringWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/GetNewPassword?username=%@", [params valueForKey:@"username"]]];
}

- (void)changePasswordWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestStringWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/validateChangePassword"]];
}

#pragma mark - Wellness tips
- (void)getWellnessTipWithCompletionHandler:(APICompletionHandler)apiCompletionHandler{
    [self getUrlRequestStringWithCompletionHandler:apiCompletionHandler url:@"Evidens/GetWellNessTipData"];
}

#pragma mark - Registration

- (void)registrationWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apicompletionHandler
{
    [self postUrlRequestWithParams:params withCompletionHandler:apicompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/RegisterDeviceDetails?UserName=%@",[params valueForKey:@"username"]]];
    //    [self getUrlRequestStringWithCompletionHandler:apicompletionHandler url:[NSString stringWithFormat:@"InterMediaryInfo/GetLoginDetails?username=%@&password=%@", [params valueForKey:@"username"], [params valueForKey:@"password"]]];
    
}

#pragma mark - Register DeviceToken
- (void)registerDeviceTokeWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"GrievanceStatus/InsertAPNGCMDetail?DeviceUniqueId=%@&UHID=%@",[param valueForKey:@"deviceuniqueid"],[param valueForKey:@"UHID"]]];
}

#pragma mark - My Policy
- (void)policyDetailsWithParams:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"EnrollmentInformation/GetMemberPolicyDetails?UHID=%@",[param valueForKey:@"UHID"]]];
}
- (void)postMCardDetailsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestWithParams:params withCompletionHandler:apiCompletionHandler url:@""];
}

#pragma mark - Updates

- (void)getUpdatesWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:@""];
}

#pragma mark - Quick Connect

- (void)getQuickConnectDetailsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiComletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiComletionHandler url:@"ProviderInfo/GetHITPADetail"];
}

#pragma mark - Branch Locator
- (void)getBranchLocationsWithCompletionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:@"MedSync/GetTPAOffices"];
    
}

#pragma mark - Grievance

- (void)postGrievanceDetailsWithParams:(NSDictionary *)params callerType:(NSString *)callerType completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"GrievanceStatus/Grievance?callerType=%@&UHID=%@", callerType, [[UserManager sharedUserManager] userName]]];
}

- (void)getGrievanceDetailWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"GrievanceStatus/GetGrievance?UHID=%@",[param valueForKey:@"userid"]]];
}

- (void)postGrievanceUpdateDetailWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestStringWithParams:param withCompletionHandler:apiCompletionHandler url:@"GrievanceStatus/UpdateRaisedGrievance"];
}

- (void)uploadGrievanceDocumentsWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestStringWithParams:param withCompletionHandler:apiCompletionHandler url:@"Inward/SaveDMSFiles"];
}

#pragma mark - Hospital Search

- (void)getSearchAllHopitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=&PageNo=%@&HospitalName=&City=", [params valueForKey:@"page"]]];
}

- (void)getSearchNearMeHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=%@&PageNo=%@", [params valueForKey:@"pincode"], [params valueForKey:@"page"]]];
}

//- (void)getSearchHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
//{
//    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=&PageNo=%@&HospitalName=%@&City=", [params valueForKey:@"page"],[[params valueForKey:@"hospitalname"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
//}

- (void)getSearchHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderDetailsBySingleParameter?SearchParameter=%@",[[params valueForKey:@"hospitalname"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
}

- (void)getSearchHospitalWithMultipleParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderListWithoutPageNumber?HospitalName=%@&City=%@&pincode=%@", [[params valueForKey:@"hospitalname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], [[params valueForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], [[params valueForKey:@"pinCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}
//curl -X GET --header 'Accept: application/json' 'http://223.30.163.104:91/api/ProviderInfo/GetProviderListWithoutPageNumber?pincode=560078&HospitalName=apollo&City=bangalore'

#pragma mark - Claims Junction

- (void)postClaimsWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestStringWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ClaimIntimation/IntimateClaim?ClaimType=%@&UHID=%@&PolicyNumber=",[params valueForKey:@"ClaimType"],[params valueForKey:@"UHID"]]];
    
}

- (void)getIntimationWithParam:(NSDictionary *)param completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ClaimIntimation/GetIntimationDetail?uhid=%@&StatusType=%@",[param valueForKey:@"userid"],[param valueForKey:@"statusType"]]];
    
}

- (void)getClaimSearchHospitalWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    
    if ([[params valueForKey:@"type"] integerValue] == 1)
    {
        [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=&PageNo=%@&HospitalName=%@&City=",[params valueForKey:@"page"],[params valueForKey:@"text"]]];
        
    }else if ([[params valueForKey:@"type"] integerValue] == 2)
    {
        
        [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=%@&PageNo=%@&HospitalName=&City=",[params valueForKey:@"text"],[params valueForKey:@"page"]]];
        
    }else if ([[params valueForKey:@"type"] integerValue] == 3)
    {
        
        [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"ProviderInfo/GetProviderList?pincode=&PageNo=%@&HospitalName=&City=%@",[params valueForKey:@"page"],[params valueForKey:@"text"]]];
    }
    
}

- (void)getClaimsHistoryWithParams:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self getUrlRequestWithCompletionHandler:apiCompletionHandler url:@"ClaimIntimation/GetIntimationDetail?uhid=1100000004261901"];
    
}

#pragma mark - Feedback
- (void)postFeedbackWithParams:(NSArray *)params completionHandler:(APICompletionHandler)apiCompletionHandler
{
    [self postUrlRequestStringWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"MedSync/AssignFeedBack"]];

    
}

#pragma mark - Email Download Form

- (void)emailDownloadForm:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler {
    
    [self postUrlRequestWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"EnrollmentInformation/SendMail"]];
}

#pragma mark - Download PDF Form

- (void)downloadPDFForm:(NSDictionary *)params completionHandler:(APICompletionHandler)apiCompletionHandler {
    
    [self postUrlRequestForDownloadFormWithParams:params withCompletionHandler:apiCompletionHandler url:[NSString stringWithFormat:@"EnrollmentInformation/DownloadPreAuthForm"]];
}

#pragma mark - URL get request

- (void)getUrlRequestWithCompletionHandler:(APICompletionHandler)apicompletionHandler url:(NSString *)url
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[[Configuration shareConfiguration] baseURL],url];
    NSLog(@"URL:%@", strUrl);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[[Configuration shareConfiguration] timeInterval] integerValue]];
    [request setHTTPMethod:requestTypeGet];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
       
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        if (error == nil && [dictionary count] > 0) {
            
            apicompletionHandler(dictionary, nil);
            
        }else{
            
            apicompletionHandler(nil, error);
        }
        
    }];
    
}

- (void)getUrlRequestStringWithCompletionHandler:(APICompletionHandler)apicompletionHandler url:(NSString *)url
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[[Configuration shareConfiguration] baseURL],url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[[Configuration shareConfiguration] timeInterval] integerValue]];
    [request setHTTPMethod:requestTypeGet];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:jsonString forKey:@"responseID"];
        
        if (error == nil && [dictionary count] > 0) {
            
            apicompletionHandler(dictionary, nil);
            
        }else{
            
            apicompletionHandler(nil, error);
        }
        
        
    }];
    
}


#pragma mark - URL post request

- (void)postUrlRequestWithParams:(NSDictionary *)params withCompletionHandler:(APICompletionHandler)apicompletionHandler url:(NSString *)postValue
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] baseURL],postValue];
    
    NSLog(@"URL:%@", url);
    NSLog(@"Post Body:%@", params);
    NSData *data;
    NSString *jsonString;
    NSData *postData;
    NSString *postLength = @"";
    
    
    if ([params count] > 0) {
        data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[[Configuration shareConfiguration] timeInterval] integerValue]];
    
    [request setHTTPMethod:requestTypePost];
    [request setValue:postLength forHTTPHeaderField:ContentLenght];
    [request setValue:@"application/json" forHTTPHeaderField:ContentType];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        if (dictionary == nil && error == nil)
        {
            dictionary = [[NSMutableDictionary alloc]init];
            [dictionary setValue:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] forKey:@"number"];
        }
        
        if (error == nil && [dictionary count] > 0) {
            apicompletionHandler(dictionary, nil);
        }else{
            apicompletionHandler(nil, error);
        }
        
    }];
    
}


#pragma mark - URL post request

- (void)postUrlRequestStringWithParams:(NSDictionary *)params withCompletionHandler:(APICompletionHandler)apicompletionHandler url:(NSString *)postValue
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] baseURL],postValue];
     NSLog(@"URL:%@", url);
    NSData *data;
    NSString *jsonString;
    NSData *postData;
    NSString *postLength = @"";
    
    
    if ([params count] > 0) {
        data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[[Configuration shareConfiguration] timeInterval] integerValue]];
    
    [request setHTTPMethod:requestTypePost];
    [request setValue:postLength forHTTPHeaderField:ContentLenght];
    [request setValue:@"application/json" forHTTPHeaderField:ContentType];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:jsonString forKey:@"successID"];
        
        if (error == nil && [dictionary count] > 0) {
            apicompletionHandler(dictionary, nil);
        }else{
            apicompletionHandler(nil, error);
        }
        
    }];
    
    
}

- (void)postUrlRequestForDownloadFormWithParams:(NSDictionary *)params withCompletionHandler:(APICompletionHandler)apicompletionHandler url:(NSString *)postValue
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] baseURL],postValue];
    NSData *data;
    NSString *jsonString;
    NSData *postData;
    NSString *postLength = @"";
    
    
    if ([params count] > 0) {
        data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[[Configuration shareConfiguration] timeInterval] integerValue]];
    
    [request setHTTPMethod:requestTypePost];
    [request setValue:postLength forHTTPHeaderField:ContentLenght];
    [request setValue:@"application/json" forHTTPHeaderField:ContentType];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        //NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        if (data.length > 0 && error == nil)
        {
            dictionary = [[NSMutableDictionary alloc]init];
            [dictionary setObject:data forKey:@"number"];
        }
        
        
        if (error == nil && data.length > 0 > 0) {
            apicompletionHandler(dictionary, nil);
        }else{
            apicompletionHandler(nil, error);
        }
        
    }];
    
    
}

@end
