//
//  CalendarViewController.h
//  HITPA
//
//  Created by Selma D. Souza on 09/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventManger.h"

@interface CalendarViewController : UIViewController

@property (nonatomic, strong) EventManger *eventManger;
@property (nonatomic, readwrite) BOOL isMedReminder;


@end
