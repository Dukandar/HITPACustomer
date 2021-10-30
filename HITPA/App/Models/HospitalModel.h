//
//  HospitalModel.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalModel : NSObject

@property (strong, nonatomic) NSString *hospitalName;
@property (strong, nonatomic) NSString *searchHospitalCity;
@property (strong, nonatomic) NSString *hospitalContactNumber;
@property (strong, nonatomic) NSString *hospitalProviderType;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *hospitalCode;

+ (HospitalModel *)getHospitalStringByResponse:(NSDictionary *)response;

@end
