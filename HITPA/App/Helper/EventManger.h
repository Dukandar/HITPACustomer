//
//  EventManger.h
//  EventKitExample
//
//  Created by Sunilkumar Basappa on 26/06/16.
//  Copyright © 2016 iNube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManger : NSObject
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventAccessGranded;
@property (nonatomic, strong) NSString *selectedCalendarIdentifier;
- (NSArray *)getLocalEventCalendars;
-(void)saveCustomCalendarIdentifier:(NSString *)identifier;
@property (nonatomic, strong) NSMutableArray *arrCustomCalendarIdentifiers;
- (BOOL)checkIfCalendarIsCustomeWithIdentifier:(NSString *)identifier;
- (void)removeCalendarIdentifier:(NSString *)identifier;

@end
