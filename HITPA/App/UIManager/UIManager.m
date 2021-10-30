//
//  UIManager.m
//  HITPA
//
//  Created by Bathi Babu on 03/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "UIManager.h"
#import "LoginViewController.h"
#import "HITPAAppDelegate.h"
#import "AboutViewController.h"
#import "MyprivacyPolicyViewController.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "BMICalculatorViewController.h"
#import "CalendarViewController.h"
#import "ServicesOfferedViewController.h"
#import "MedReminderViewController.h"
#import "WellnessTipViewController.h"

@interface UIManager()
@property (strong, nonatomic) UINavigationController *navigationController;


@end

@implementation UIManager



+ (UIManager *)sharedUIManger
{
    
    
    static UIManager *_sharedUIManger = nil;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        
        _sharedUIManger = [[UIManager alloc]init];
        
    });
    
    
    return _sharedUIManger;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        HITPAAppDelegate *appDelegate = (HITPAAppDelegate *)[UIApplication sharedApplication].delegate;
        self.navigationController = (UINavigationController *)appDelegate.window.rootViewController;
        
        
    }
    
    return self;
    
}


#pragma mark - Menu

- (void)hideLoginViewController
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)gotoLoginPageWitnMenuAnimated:(BOOL)animated
{
    
    LoginViewController *vctr = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vctr animated:YES];
    
}

- (void)gotoHomePageWitnMenuAnimated:(BOOL)animated
{
    
    if (self.navigationController)
    {
        HomeViewController *vctr = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
    
}

- (void)gotoBMICalculatorWitnMenuAnimated:(BOOL)animated
{
    if (self.navigationController)
    {
        
        BMICalculatorViewController *vctr = [[BMICalculatorViewController alloc]initWithNibName:@"BMICalculatorViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
    }
}

- (void)gotoCalendarWitnMenuAnimated:(BOOL)animated isMedReminder:(BOOL)isMedReminder
{
    if (self.navigationController)
    {
        CalendarViewController *vctr = [[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
        vctr.isMedReminder = isMedReminder;
        [self.navigationController pushViewController:vctr animated:YES];
    }
}

- (void)gotoAboutusWitnMenuAnimated:(BOOL)animated
{
    
    if (self.navigationController)
    {
        AboutViewController *vctr = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
}

- (void)gotoServicesOfferedWitnMenuAnimated:(BOOL)animated
{
    if (self.navigationController)
    {
        ServicesOfferedViewController *vctr = [[ServicesOfferedViewController alloc]initWithNibName:@"ServicesOfferedViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
}

- (void)medReminderdWitnMenuAnimated:(BOOL)animated
{
    
    if (self.navigationController)
    {
        MedReminderViewController *vctr = [[MedReminderViewController alloc]initWithNibName:@"MedReminderViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
}

- (void)wellnessTipViewControllerMenuAnimated:(BOOL)animated
{
    
    if (self.navigationController)
    {
        WellnessTipViewController *vctr = [[WellnessTipViewController alloc]initWithNibName:@"WellnessTipViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
}

- (void)gotogotoMyprivacyWitnMenuAnimated:(BOOL)animated
{
    
    if (self.navigationController)
    {
        MyprivacyPolicyViewController *vctr = [[MyprivacyPolicyViewController alloc]initWithNibName:@"MyprivacyPolicyViewController" bundle:nil];
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
    
    
}

- (void)gotoMap:(NSString *)address hospitalName:(NSString *)hospitalName
{
    
    if (self.navigationController)
    {
        MapViewController *vctr = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        vctr.addreses = address;
        vctr.hospitalName = hospitalName;
        [self.navigationController pushViewController:vctr animated:YES];
        
        
    }
    
    
}



@end
