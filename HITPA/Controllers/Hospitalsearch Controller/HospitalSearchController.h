//
//  HospitalSearchController.h
//  HITPA
//
//  Created by Bhaskar C M on 12/4/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"
#import "HospitalSearchTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
@interface HospitalSearchController : BaseViewController<hospitalSearchTableViewCell,CLLocationManagerDelegate, UISearchBarDelegate>

@end
