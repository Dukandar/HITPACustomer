//
//  UpdatesDetailViewController.h
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"
#import "UpdatesDetailTableViewCell.h"
#import "MyPolicyModel.h"

@interface UpdatesDetailViewController : BaseViewController<updatesDetailsTableViewCell>

- (instancetype)initWithResponse:(MyPolicyModel *)response;

@end
