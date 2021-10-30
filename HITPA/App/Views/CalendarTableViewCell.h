//
//  CalendarTableViewCell.h
//  HITPA
//
//  Created by Selma D. Souza on 11/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface CalendarTableViewCell : UITableViewCell

@property (nonatomic, readwrite) NSIndexPath *indexPath;
@property (nonatomic, strong) EKEvent *event;


- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath eventDetail:(EKEvent *)eventDetail;
@end
