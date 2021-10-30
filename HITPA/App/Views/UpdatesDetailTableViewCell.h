//
//  UpdatesDetailTableViewCell.h
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimsJunction.h"

@protocol updatesDetailsTableViewCell <NSObject>

- (void)feedbackWithIndex:(NSInteger)index feedbackStatus:(NSString *)status andUpdateDetails:(ClaimsJunction *)updateDetails;
@end

@interface UpdatesDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id <updatesDetailsTableViewCell>delegate;

@property (nonatomic, strong)NSMutableDictionary *details;

- (instancetype)initWithDelegate:(id<updatesDetailsTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath updateDetails:(ClaimsJunction *)updateDetails;

@end
