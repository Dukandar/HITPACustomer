//
//  QuickConnet.h
//  HITPA
//
//  Created by Bhaskar C M on 1/6/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickConnet : NSObject

@property (strong, nonatomic) NSString *tollfreeNumber;
@property (strong, nonatomic) NSString *mailID;
@property (strong, nonatomic) NSString *address;

+ (QuickConnet *)getQuickConnectDetailsByResponse:(NSDictionary *)response;

@end
