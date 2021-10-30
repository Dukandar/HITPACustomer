//
//  QuickConnet.m
//  HITPA
//
//  Created by Bhaskar C M on 1/6/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "QuickConnet.h"

NSString * const kTollFreeNumber         = @"TollFreeNo";
NSString * const kMailID                 = @"MailID";
NSString * const kAddress                = @"Address";

@implementation QuickConnet

+ (QuickConnet *)getQuickConnectDetailsByResponse:(NSDictionary *)response
{
    
    if (response != nil || [response isKindOfClass:[NSDictionary class]]) {
        QuickConnet *details = [[QuickConnet alloc]init];
        
        NSString *tollFreeNo = [response valueForKey:kTollFreeNumber];
        
        if (tollFreeNo != nil || [tollFreeNo isKindOfClass:[NSString class]]) {
            
            details.tollfreeNumber = tollFreeNo;
        }
        
        NSString *mailID = [response valueForKey:kMailID];
        
        if (mailID != nil || [mailID isKindOfClass:[NSString class]]) {
            
            details.mailID = mailID;
        }
        
        NSString *address = [response valueForKey:kAddress];
        
        if (address != nil || [address isKindOfClass:[NSString class]]) {
            
            details.address = address;
        }
        
        return details;
        
    }
    
    return nil;
    
}


@end
