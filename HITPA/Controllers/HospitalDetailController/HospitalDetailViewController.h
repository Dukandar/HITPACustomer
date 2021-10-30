//
//  HospitalDetailViewController.h
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"
#import "HospitalDetailTableViewCell.h"

@interface HospitalDetailViewController : BaseViewController<hospitalDetailsTableViewCell>

- (instancetype)initWithResponse:(NSMutableDictionary *)response;

@end
