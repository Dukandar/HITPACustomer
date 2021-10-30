//
//  HospitalModel.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HospitalModel.h"

NSString * const kSearchHospitalName           = @"HospitalName";
NSString * const kSearchHospitalArea           = @"City";
NSString * const kSearchHospitalContact        = @"ContactNumber";
NSString * const kSearchHospitalSector         = @"ProviderType";
NSString * const kSearchHospitalAddress        = @"Address";
NSString * const kHospitalCode                 = @"HospitalCode";

@implementation HospitalModel

+ (HospitalModel *)getHospitalStringByResponse:(NSDictionary *)response
{
    
    if (response != nil || [response isKindOfClass:[NSDictionary class]]) {
        HospitalModel *details = [[HospitalModel alloc]init];
        
        NSString *hospitalName = [response valueForKey:kSearchHospitalName];
        
        if (hospitalName != nil || [hospitalName isKindOfClass:[NSString class]]) {
            
            details.hospitalName = hospitalName;
        }
        
        NSString *area = [response valueForKey:kSearchHospitalArea];
        
        if (area != nil || [area isKindOfClass:[NSString class]]) {
            
            details.searchHospitalCity = area;
        }
        
        NSString *contact = [response valueForKey:kSearchHospitalContact];
        
        if (contact != nil || [contact isKindOfClass:[NSString class]]) {
            
            details.hospitalContactNumber = contact;
        }
        
        NSString *sector = [response valueForKey:kSearchHospitalSector];
        
        if (sector != nil || [sector isKindOfClass:[NSString class]]) {
            
            details.hospitalProviderType = sector;
        }
        
        NSString *address = [response valueForKey:kSearchHospitalAddress];
        
        if (address != nil || [address isKindOfClass:[NSString class]]) {
            
            details.address = address;
        }
        
        NSString *hospitalCode = [response valueForKey:kHospitalCode];
        
        if (hospitalCode != nil || [hospitalCode isKindOfClass:[NSString class]]) {
            
            details.hospitalCode = hospitalCode;
        }
        
        return details;
        
    }
    
    return nil;
}

@end
