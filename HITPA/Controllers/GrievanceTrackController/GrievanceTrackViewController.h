//
//  GrievanceTrackViewController.h
//  HITPA
//
//  Created by Bhaskar C M on 12/23/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"
#import "Greveance.h"

@protocol GrievanceTrack <NSObject>
- (void)getGrievanceTrackDetails;
@end

@interface GrievanceTrackViewController : BaseViewController

@property (nonatomic, weak) id <GrievanceTrack>delegate;

- (instancetype)initWithResponse:(Greveance *)response delegate:(id<GrievanceTrack>)delegate;

@end
