//
//  AddEventViewController.h
//  HITPA
//
//  Created by Selma D. Souza on 09/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventManger.h"

@interface AddEventViewController : UIViewController

@property (nonatomic, strong) EKCalendar *calender;
- (instancetype)initWithCalendar:(EKCalendar *)calendar eventDate:(NSDate *)eventDate event:(EKEvent *)event;
@property (nonatomic, readwrite) BOOL isMedReminder;

@end
