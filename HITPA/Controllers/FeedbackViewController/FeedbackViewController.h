//
//  FeedbackViewController.h
//  HITPA
//
//  Created by Kranthi B. on 11/9/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController<UITextFieldDelegate>

- (instancetype)initWithUpdateDetails:(NSDictionary *)updateDetails;

@end

