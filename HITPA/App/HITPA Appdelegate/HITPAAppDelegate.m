//
//  AppDelegate.m
//  HITPA
//
//  Created by Bathi Babu on 26/11/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HITPAAppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UserManager.h"
#import "UIManager.h"
#import "HITPAUserDefaults.h"
#import "FeedbackViewController.h"
#import "IQKeyBoardManager.h"

@implementation HITPAAppDelegate


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UserManager sharedUserManager];
    
    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.eventManger = [[EventManger alloc]init];

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    [IQKeyboardManager sharedManager].enable = true;

    UINavigationController *navigationController;
    
    if ([[UserManager sharedUserManager] isValidUser])
    {
        
        HomeViewController *vctr = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        navigationController = [[UINavigationController alloc]initWithRootViewController:vctr];
        
    }else
    {
    
        LoginViewController *vctr = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];

        navigationController = [[UINavigationController alloc]initWithRootViewController:vctr];
        
    }
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    [UIManager sharedUIManger];
    
    [self locationServiceAuthorization];
    [self registerUserNotification:application];
    // Override point for customization after application launch.
    return YES;
    
    
}

- (void)registerUserNotification:(UIApplication *)application
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark - Core data

- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"HITPA.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)locationServiceAuthorization
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.distanceFilter  = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy     = kCLLocationAccuracyHundredMeters;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
}

#pragma mark - Device UDID
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSLog(@"My token is: %@", deviceToken);
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"DeviceToken"];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    [[NSUserDefaults standardUserDefaults] setValue:@"ASHERNDSGHRTHSNDERTHSJLKEHDJSNSWDERS" forKey:@"DeviceToken"];
}





@end
