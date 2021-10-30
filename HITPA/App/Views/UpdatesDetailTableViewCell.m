//
//  UpdatesDetailTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "UpdatesDetailTableViewCell.h"
#import "HITPAUserDefaults.h"
#import "Configuration.h"
#import "Constants.h"


NSString *  const kUpdatesDetailsReuseIdentifier    = @"details";
NSString *claimsFeedbackStatus;
ClaimsJunction *updateDetailss;

@implementation UpdatesDetailTableViewCell

#pragma mark -
- (instancetype)initWithDelegate:(id<updatesDetailsTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath updateDetails:(ClaimsJunction *)updateDetails
{
    
    self.details = [[NSMutableDictionary alloc]init];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUpdatesDetailsReuseIdentifier];
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self createUpdateDetailsListViewWithIndexPath:indexPath updateDetails:updateDetails];
    }
    return self;
}

- (void)createUpdateDetailsListViewWithIndexPath:(NSIndexPath *)indexPath updateDetails:(ClaimsJunction *)updateDetails
{
    
    NSArray *tableDetails = [[NSArray alloc]initWithObjects:@"Claim Ref Number :", @"UHID :",@"Policy Number :",@"Product :",@"Hospital Name :",@"Date of Admission :", @"Date of Discharge :",@"Date of Intimation :",@"Diagnosis :",@"Insured Name :",@"Relationship :",@"Claim Type :", @"Claim Status :",@"Payment Amount :", nil];
    
    NSString *strDateOfLoss = updateDetails.dateOfAdmission;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *dateOfLoss = [dateFormatter dateFromString:strDateOfLoss];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateOfLossString = [dateFormatter stringFromDate:dateOfLoss];
    
    NSString *strDateOfDischarge = updateDetails.dateOfDischarge;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *dateOfDischarge = [dateFormatter dateFromString:strDateOfDischarge];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateOfDischargeString = [dateFormatter stringFromDate:dateOfDischarge];
    
    NSArray *timedateArray = [updateDetails.dateTime componentsSeparatedByString:@" "];
    
    NSString *strDateOfIntimation = updateDetails.dateTime;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *dateOfIntimation = [dateFormatter dateFromString:strDateOfIntimation];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateOfIntimationString = [dateFormatter stringFromDate:dateOfIntimation];
    
    
    NSString *productName = [[HITPAUserDefaults shareUserDefaluts] valueForKey:@"productname"];
    
    
    NSArray *tableValues = [[NSArray alloc]initWithObjects:updateDetails.claimNumber, updateDetails.claimsUHID,updateDetails.policyNumber, (productName != nil)?productName:@"NA",updateDetails.hospitalName,dateOfLossString, dateOfDischargeString, dateOfIntimationString,updateDetails.diagnosis,updateDetails.patientName,updateDetails.relationship, ([updateDetails.claimType isEqualToString:@"Claim Intimation"]) ? [updateDetails.claimType stringByAppendingString:[NSString stringWithFormat:@" - %@",updateDetails.claimSubType]]:updateDetails.claimType , updateDetails.claimStatus, ([updateDetails.claimStatus isEqualToString:@"Approved"])?updateDetails.consumed:updateDetails.estimatedExpense, nil];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 40.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    if(indexPath.row == tableDetails.count) {
        
        yPos   = 5.0;
        height = 30.0;
        if ([updateDetails.claimStatus isEqualToString:@"Claim Settled"]) {
            
            UIButton *feedback = [[UIButton alloc] init];
            if ([updateDetails.claimsFeedbackStatus isEqualToString:@"True"]) {
                
                width = 250.0;
                xPos = (viewMain.frame.size.width - width) / 2.0;
//                yPos = 5.0;
                feedback = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
                [feedback setTitle:@"Feedback Already Submitted" forState:UIControlStateNormal];
                [feedback setUserInteractionEnabled:NO];
                [feedback setEnabled:FALSE];
                //[feedback setAlpha:0.4];
            }else {
                width = 150.0;
                xPos = (viewMain.frame.size.width - width) / 2.0;
                feedback = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
                [feedback setTitle:@"Send Feedback" forState:UIControlStateNormal];
            }
            
            [feedback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            feedback.layer.cornerRadius = 4.0;
            feedback.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
            feedback.layer.borderWidth = 1.0;
            feedback.layer.masksToBounds = YES;
            feedback.tag = indexPath.section;
            feedback.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
            [feedback setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            
            claimsFeedbackStatus = updateDetails.claimsFeedbackStatus;
            updateDetailss = [[ClaimsJunction alloc] init];
            updateDetailss = updateDetails;
            [feedback addTarget:self action: @selector(feedbackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            //            feedback.hidden = YES;  //Hide Feedback button
            [viewMain addSubview:feedback];
        }
    } else {
        xPos   = 0.0;
        yPos   = 7.0;
        width  = (frame.size.width * 0.45);
        height = viewMain.frame.size.height;
        UILabel *tableLabels = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        tableLabels.text = tableDetails[indexPath.row];
        tableLabels.textColor = [UIColor darkGrayColor];
        tableLabels.textAlignment = NSTextAlignmentRight;
        //    tableLabels.backgroundColor = [UIColor redColor];
        tableLabels.numberOfLines = 2;
        tableLabels.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
        //    [tableLabels sizeToFit];
        [viewMain addSubview:tableLabels];
        
        xPos = tableLabels.frame.origin.x + tableLabels.frame.size.width + 3.0;
        width = frame.size.width * 0.55;
        UILabel *claimHistory = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        claimHistory.text = (tableValues[indexPath.row] != nil && ![tableValues[indexPath.row] isKindOfClass:[NSNull class]])?tableValues[indexPath.row]:@"NA";
        claimHistory.textAlignment = NSTextAlignmentLeft;
        //    claimHistory.backgroundColor = [UIColor greenColor];
        claimHistory.numberOfLines = 2;
        claimHistory.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0];
        //    [claimHistory sizeToFit];
        [viewMain addSubview:claimHistory];
    }
}

#pragma mark - Button Delegate

- (void)feedbackButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(feedbackWithIndex:feedbackStatus: andUpdateDetails:)])
    {
                [self.delegate feedbackWithIndex:sender.tag feedbackStatus:claimsFeedbackStatus andUpdateDetails:updateDetailss];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
