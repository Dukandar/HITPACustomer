//
//  HITPAAppDelegate.h
//  HITPA
//
//  Created by Bathi Babu on 26/11/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "EventManger.h"

@interface HITPAAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,    strong)     CLLocationManager   *locationManager;
@property (nonatomic, strong) EventManger *eventManger;


@end

