//
//  NearMeViewController.h
//  MedSync
//
//  Created by Sunilkumar Basappa on 29/09/15.
//  Copyright © 2015 iNube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hospital.h"
#import "HospitalModel.h"

@protocol nearMe <NSObject>


- (void)hospitaWithDetail:(HospitalModel *)hospital;

@end

@interface NearMeViewController : UIViewController

- (instancetype)initWithDelegate:(id<nearMe>)delegate;

@property (nonatomic, readwrite) id <nearMe> delegate;


@end
