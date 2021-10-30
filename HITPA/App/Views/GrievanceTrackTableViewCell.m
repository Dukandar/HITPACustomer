//
//  GrievanceTrackTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 12/23/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "GrievanceTrackTableViewCell.h"
#import "Configuration.h"
#import "Utility.h"


NSString * const kGriveanceTrackReuseIdentifier     = @"griveanceTrack";

@implementation GrievanceTrackTableViewCell

- (instancetype)initWithDelegate:(id<griveanceTrackTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath complaint:(NSString *)complaint
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGriveanceTrackReuseIdentifier];
    
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self createGriveanceListViewWithIndexPath:indexPath complaint:complaint];
        
    }
    
    
    return self;
    
}

- (void)createGriveanceListViewWithIndexPath:(NSIndexPath *)indexPath complaint:(NSString *)complaint
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat height = 60.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = indexPath.row;
    viewMain.layer.cornerRadius = 5.0;
    viewMain.layer.masksToBounds = YES;
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 15.0;
    width = frame.size.width - xPos;
    height = 30.0;
    UILabel *remark = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:@"Complaint remark" fontSize:16.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [viewMain addSubview:remark];
    
    height = 28.0;
    yPos = remark.frame.size.height;
    UILabel *remarkDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:complaint fontSize:14.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    remarkDetails.font = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    [viewMain addSubview:remarkDetails];

    xPos = 5.0;
    yPos = viewMain.frame.size.height - 2.0;
    width = frame.size.width;
    height = 2.0;
    UIView *viewline = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewline.backgroundColor = [UIColor grayColor];
    [viewMain addSubview:viewline];
    
    xPos = 0.0;
    yPos = 0.0;
    width = 6.0;
    height = viewMain.frame.size.height;
    UIView *viewLeftLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewLeftLine.backgroundColor = [UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f];
    [viewMain addSubview:viewLeftLine];
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:fontSize];
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
