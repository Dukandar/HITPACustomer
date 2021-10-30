//
//  HospitalDetailTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalModel.h"

@protocol hospitalDetailsTableViewCell <NSObject>


@end

@interface HospitalDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id <hospitalDetailsTableViewCell>delegate;

@property (nonatomic, strong)NSMutableDictionary *details;

- (instancetype)initWithDelegate:(id<hospitalDetailsTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response;

@end
