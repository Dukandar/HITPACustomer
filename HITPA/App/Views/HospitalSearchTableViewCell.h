//
//  HospitalSearchTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 12/7/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalModel.h"

typedef enum{
    
    allHopitalsEnum = 1234567,
    nearMeHospitalsEnum,
    searchHospital
    
}HospitalType;

@protocol hospitalSearchTableViewCell <NSObject>


@end

@interface HospitalSearchTableViewCell : UITableViewCell<UIAlertViewDelegate>

@property (nonatomic, weak) id <hospitalSearchTableViewCell>delegate;

@property (nonatomic, readwrite)HospitalType hospitalType;
@property (nonatomic, readwrite)NSIndexPath *indexPath;
@property (nonatomic, strong)       NSMutableDictionary         *response;

- (instancetype)initWithDelegate:(id<hospitalSearchTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response;

@end
