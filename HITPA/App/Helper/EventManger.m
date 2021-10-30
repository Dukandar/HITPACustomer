//
//  EventManger.m
//  EventKitExample
//
//  Created by Sunilkumar Basappa on 26/06/16.
//  Copyright © 2016 iNube. All rights reserved.
//

#import "EventManger.h"

@implementation EventManger

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.eventStore = [[EKEventStore alloc]init];
        self.arrCustomCalendarIdentifiers = [[NSMutableArray alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil)
        {
            self.eventAccessGranded = [[userDefaults valueForKey:@"eventkit_events_access_granted"] integerValue];
        }else
        {
            self.eventAccessGranded = NO;
        }
        
        //Load the  selected calendar identifier
        if ([userDefaults  valueForKey:@"eventkit_selected_calendar"] != nil)
        {
            self.selectedCalendarIdentifier = [userDefaults valueForKey:@"eventkit_selected_calendar"];
        }else
        {
            self.selectedCalendarIdentifier = @"";
        }
        
        //Custome identifier
        if ([userDefaults objectForKey:@"eventkit_cal_identifiers"]!= nil)
        {
            NSArray *identifiers = [userDefaults valueForKey:@"eventkit_cal_identifiers"];
            self.arrCustomCalendarIdentifiers = [identifiers mutableCopy];
        }
        
    }
    
    EKEventStore *es = [[EKEventStore alloc] init];
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    BOOL needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);

    if (needsToRequestAccessToEventStore) {
       [es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                // Access granted
            } else {
                // Denied
            }
        }];
    } else {
        BOOL granted = (authorizationStatus == EKAuthorizationStatusAuthorized);
        if (granted) {
            // Access granted
        } else {
            // Denied
        }
    }

    return self;
}

- (void)setEventAccessGranded:(BOOL)eventAccessGranded
{
    _eventAccessGranded = eventAccessGranded;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:eventAccessGranded] forKey:@"eventkit_events_access_granted"];
}

//Get local Events
- (NSArray *)getLocalEventCalendars
{
    EKSource *localSource;
    for (int i = 0; i < [self.eventStore.sources count]; i++) {
        EKSource *source = (EKSource *)[self.eventStore.sources objectAtIndex:i];
        EKSourceType currentSourceType = source.sourceType;
        if (currentSourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]) {
            localSource = source;
            break;
        }
        
    }
    
    NSArray *allCalnders = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc]init];
    for (int i = 0; i < [allCalnders count]; i++) {
        EKCalendar *currentCalendar = [allCalnders objectAtIndex:i];
        if (currentCalendar.type == (localSource == nil) ?  EKCalendarTypeLocal : EKCalendarTypeCalDAV)
        {
            [localCalendars addObject:currentCalendar];
        }
    }
    return (NSArray *)localCalendars;
}

//Indentifier
- (void)setSelectedCalendarIdentifier:(NSString *)selectedCalendarIdentifier
{
    _selectedCalendarIdentifier = selectedCalendarIdentifier;
    [[NSUserDefaults standardUserDefaults] setObject:selectedCalendarIdentifier forKey:@"eventkit_selected_calendar"];
}

-(void)saveCustomCalendarIdentifier:(NSString *)identifier
{
    if (!self.arrCustomCalendarIdentifiers || [self.arrCustomCalendarIdentifiers count] <=0 )
        self.arrCustomCalendarIdentifiers = [[NSMutableArray alloc]init];
    
    [self.arrCustomCalendarIdentifiers addObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}

//Check Identifier
- (BOOL)checkIfCalendarIsCustomeWithIdentifier:(NSString *)identifier
{
    BOOL isCustomeCalendar = NO;
    for (int i = 0; i < [self.arrCustomCalendarIdentifiers count]; i++) {
        if ([[self.arrCustomCalendarIdentifiers
              objectAtIndex:i] isEqualToString:identifier])
        {
            isCustomeCalendar = YES;
            break;
            
        }
    }
    return isCustomeCalendar;
}

- (void)removeCalendarIdentifier:(NSString *)identifier
{
    [self.arrCustomCalendarIdentifiers removeObject:identifier];
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
    
}

@end
