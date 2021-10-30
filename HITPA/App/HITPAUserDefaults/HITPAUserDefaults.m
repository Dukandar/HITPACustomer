//
//  HITPAUserDefaults.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HITPAUserDefaults.h"
#import "Configuration.h"

@implementation HITPAUserDefaults

+ (NSUserDefaults *)shareUserDefaluts
{
    static NSUserDefaults *_shareUserDefaluts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareUserDefaluts = [[NSUserDefaults alloc] initWithSuiteName:[Configuration appGroupName]];
    });
    
    return _shareUserDefaluts;
    
}

@end
