//
//  UpdatesTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "UpdatesTableViewCell.h"
#import "Configuration.h"
#import "Utility.h"
#import "Updates.h"
#import "HITPAUserDefaults.h"

NSString * const kUpdatesReuseIdentifier     = @"search";

@implementation UpdatesTableViewCell


- (instancetype)initWithDelegate:(id<updatesSearchTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableArray *)response
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUpdatesReuseIdentifier];
    
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self updatesTableViewCellWithType:response indexPath:indexPath];
        
    }
    
    
    return self;
}

- (void)updatesTableViewCellWithType:(NSMutableArray *)response
                           indexPath:(NSIndexPath *)indexPath
{
    
    [self createUpdatesListViewWithIndexPath:indexPath response:response];
    
}


- (void)createUpdatesListViewWithIndexPath:(NSIndexPath *)indexPath response:(NSMutableArray *)response
{
    
    ClaimsJunction *updateDetails = (ClaimsJunction *)[response objectAtIndex:indexPath.row];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 107.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = indexPath.row;
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 0.0;
    yPos = 0.0;
    width = 5.0;
    height = viewMain.frame.size.height;
    UIView *leftLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    leftLine.backgroundColor = [UIColor colorWithRed:(189.0/255.0) green:(55.0/255.0) blue:(52.0/255.0) alpha:1.0f];
    [viewMain addSubview:leftLine];
    
    xPos = 5.0;
    width = 100.0;
    UIView *logoAndTime = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    logoAndTime.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:logoAndTime];
    
    yPos = 7.0;
    width = 53.0;
    height = 50.0;
    xPos = ((logoAndTime.frame.size.width - width)/2) - 5.0;
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    logo.image = [UIImage imageNamed:@"icon_hitpalogo"];
    [logoAndTime addSubview:logo];
    
    
    NSDate *timeDate = [NSDate date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *fromDate = [timeFormatter dateFromString:updateDetails.dateTime];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [timeFormatter stringFromDate:fromDate];
    
    timeFormatter.dateFormat = @"hh:mm a";
    NSString *timeString = [timeFormatter stringFromDate:fromDate];

    NSString *strIntiDate = updateDetails.dateTime;
    NSArray *timedateArray = [strIntiDate componentsSeparatedByString:@" "];

    xPos = 0.0;
    yPos = logo.frame.size.height;
    width = logoAndTime.frame.size.width;
    height = 30.0;
    UILabel *time = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"%@ %@",[timedateArray objectAtIndex:1],[timedateArray objectAtIndex:2]] fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    time.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0];
    [logoAndTime addSubview:time];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *intiDate = [dateFormatter dateFromString:strIntiDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateIntiString = [dateFormatter stringFromDate:intiDate];
    

    yPos = time.frame.origin.y + 20.0;
    height = 40.0;
    UILabel *date = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:dateIntiString fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    date.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0];
    [logoAndTime addSubview:date];
    
    xPos = logoAndTime.frame.size.width + 9.0;
    yPos = 8.0;
    width = viewMain.frame.size.width - logoAndTime.frame.size.width;
    height = 25.0;
    UILabel *status = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:updateDetails.claimStatus fontSize:14.0 fontColor:[UIColor colorWithRed:(200.0/255.0) green:(78.0/255.0) blue:(89.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
    status.font = frame.size.width>320?[[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0]:[[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
    [status sizeToFit];
    status.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize requiredSize = [status sizeThatFits:maxSize];
    status.frame = CGRectMake(xPos, yPos, requiredSize.width, requiredSize.height);
    [viewMain addSubview:status];
    
    if (requiredSize.height > 30.0) {
        yPos = status.frame.size.height + 4.0;
    }else{
        yPos = status.frame.size.height + 15.0;
    }
    
    width = 100.0;
    height = 20.0;
    UILabel *consumed = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Consumed:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
    consumed.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
    [viewMain addSubview:consumed];
    
    if (requiredSize.height > 30.0) {
        yPos = status.frame.size.height + consumed.frame.size.height - 2.0;
    }else{
        yPos = consumed.frame.origin.y + consumed.frame.size.height + 2.0;
    }
    
    width = 88.0;
    height = 20.0;
    UILabel *coverage = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Coverage:" fontSize:14.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
    coverage.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
    [viewMain addSubview:coverage];
    
    yPos = consumed.frame.origin.y;
    xPos = consumed.frame.origin.x + consumed.frame.size.width;
    width = viewMain.frame.size.width - xPos;
    height = 20.0;
    UILabel *consumedAmount = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height)
                                                   title:(([updateDetails.consumed  isEqual: @""]) ? @"NA" : updateDetails.consumed) fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    consumedAmount.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
    [viewMain addSubview:consumedAmount];
    
    yPos = coverage.frame.origin.y;
    xPos = coverage.frame.origin.x + coverage.frame.size.width;
    width = viewMain.frame.size.width - xPos;
    height = 20.0;
    UILabel *coverageAmount = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height)
                                                   title:updateDetails.coverage fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    coverageAmount.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
    [viewMain addSubview:coverageAmount];
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration
                   shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
