//
//  UIManager.h
//  HITPA
//
//  Created by Bathi Babu on 03/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIManager : NSObject

+ (UIManager *)sharedUIManger;
- (void)gotoLoginPageWitnMenuAnimated:(BOOL)animated;
- (void)gotoBMICalculatorWitnMenuAnimated:(BOOL)animated;
- (void)gotoAboutusWitnMenuAnimated:(BOOL)animated;
- (void)gotogotoMyprivacyWitnMenuAnimated:(BOOL)animated;
- (void)gotoHomePageWitnMenuAnimated:(BOOL)animated;
- (void)hideLoginViewController;
- (void)gotoMap:(NSString *)address hospitalName:(NSString *)hospitalName;
- (void)gotoCalendarWitnMenuAnimated:(BOOL)animated isMedReminder:(BOOL)isMedReminder;
- (void)gotoServicesOfferedWitnMenuAnimated:(BOOL)animated;
- (void)medReminderdWitnMenuAnimated:(BOOL)animated;
- (void)wellnessTipViewControllerMenuAnimated:(BOOL)animated;
@end
