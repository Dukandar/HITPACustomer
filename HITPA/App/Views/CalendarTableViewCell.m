//
//  CalendarTableViewCell.m
//  HITPA
//
//  Created by Selma D. Souza on 11/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "Configuration.h"

@implementation CalendarTableViewCell

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath eventDetail:(EKEvent *)eventDetail
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    
    if (self)
    {
        self.indexPath = indexPath;
        self.event = eventDetail;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self calendarTableViewCellWithEvent:eventDetail indexPath:indexPath];
        
    }
    
    
    return self;
}

- (void)calendarTableViewCellWithEvent:(EKEvent *)eventDetail indexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat height = 50.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = indexPath.row;
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 10.0;
    yPos = 0.0;
    width = 80.0;
    height = 50.0;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    NSDate *startDate = eventDetail.startDate;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"hh:mm a"];
    NSString *time = [dateformat stringFromDate:startDate];
    timeLabel.text = time;
    timeLabel.numberOfLines = 0;
    timeLabel.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [viewMain addSubview:timeLabel];
    
    xPos = timeLabel.frame.origin.x + timeLabel.frame.size.width + 10.0;
    height = 40.0;
    yPos = (viewMain.frame.size.height - height)/2.0;
    width = frame.size.width - xPos - 10.0;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    titleView.backgroundColor = [UIColor colorWithRed:202/255.0 green:204/255.0 blue:183/255.0 alpha:1.0];
    titleView.layer.cornerRadius = 5.0;
    [viewMain addSubview:titleView];
    
    xPos = 5.0;
    yPos = 0.0;
    width = titleView.frame.size.width - 2 * xPos;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    titleLabel.text = eventDetail.title;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [[Configuration shareConfiguration] hitpaFontWithSize:18.0];
    [titleView addSubview:titleLabel];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
