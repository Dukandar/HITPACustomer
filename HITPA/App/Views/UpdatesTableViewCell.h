//
//  UpdatesTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimsJunction.h"

@protocol updatesSearchTableViewCell <NSObject>


@end

@interface UpdatesTableViewCell : UITableViewCell
@property (nonatomic, weak) id <updatesSearchTableViewCell>delegate;

- (instancetype)initWithDelegate:(id<updatesSearchTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableArray *)response;

@end
