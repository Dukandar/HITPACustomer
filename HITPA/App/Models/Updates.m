//
//  Updates.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "Updates.h"

NSString * const kUpdateTime           = @"time";
NSString * const kUpdateDate           = @"date";
NSString * const kUpdateStatus         = @"status";
NSString * const kUpdateConsumed       = @"consumed";
NSString * const kUpdateCoverage       = @"coverage";

@implementation Updates

+ (Updates *)getUpdatesByResponse:(NSDictionary *)response
{
    if (response != nil || [response isKindOfClass:[NSDictionary class]]) {
        Updates *details = [[Updates alloc]init];
        
        NSArray *updateTime = [response valueForKey:kUpdateTime];
        
        if (updateTime != nil || [updateTime isKindOfClass:[NSArray class]]) {
            
            details.updateTime = updateTime;
        }
        
        NSArray *updateDate = [response valueForKey:kUpdateDate];
        
        if (updateDate != nil || [updateDate isKindOfClass:[NSArray class]]) {
            
            details.updateDate = updateDate;
        }
        
        NSArray *updateStatus = [response valueForKey:kUpdateStatus];
        
        if (updateStatus != nil || [updateStatus isKindOfClass:[NSArray class]]) {
            
            details.updateStatus = updateStatus;
        }
        
        NSArray *updateConsumed = [response valueForKey:kUpdateConsumed];
        
        if (updateConsumed != nil || [updateConsumed isKindOfClass:[NSArray class]]) {
            
            details.updateConsumed = updateConsumed;
        }
        
        NSArray *updateCoverage = [response valueForKey:kUpdateCoverage];
        
        if (updateCoverage != nil || [updateCoverage isKindOfClass:[NSArray class]]) {
            
            details.updateCovrage = updateCoverage;
        }
        
        return details;
        
    }
    
    return nil;
    
}

@end
