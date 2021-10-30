//
//  Updates.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Updates : NSObject

@property (strong, nonatomic) NSArray *updateTime;
@property (strong, nonatomic) NSArray *updateDate;
@property (strong, nonatomic) NSArray *updateStatus;
@property (strong, nonatomic) NSArray *updateConsumed;
@property (strong, nonatomic) NSArray *updateCovrage;

+ (Updates *)getUpdatesByResponse:(NSDictionary *)response;

@end
