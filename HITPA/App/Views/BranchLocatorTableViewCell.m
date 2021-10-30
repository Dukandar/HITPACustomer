//
//  BranchLocatorTableViewCell.m
//  HITPA
//
//  Created by Selma D. Souza on 08/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "BranchLocatorTableViewCell.h"
#import "Configuration.h"

NSString * const kBranchLocatorReuseIdentifier     = @"branchsearch";

@implementation BranchLocatorTableViewCell

- (instancetype)initWithDelegate:(id<branchLocatorTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBranchLocatorReuseIdentifier];
    
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self branchLocatorViewWithResponse:response indexPath:indexPath];
        
    }
    
    
    return self;
}

- (void)branchLocatorViewWithResponse:(NSDictionary *)response indexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 110.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = indexPath.row;
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 6.0;
    yPos = 0.0;
    width = viewMain.frame.size.width - 6.0;
    height = 20.0;
    UILabel *branchName = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[response valueForKey:@"OfficeName"] fontSize:14.0 fontColor:[UIColor colorWithRed:(0.0/255.0) green:(66.0/255.0) blue:(166.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
    branchName.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [viewMain addSubview:branchName];

    xPos = 6.0;
    yPos = branchName.frame.origin.y + branchName.frame.size.height + 3.0;
    width = viewMain.frame.size.width - 6.0;
    height = 70.0;
    UILabel *branchAddress = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",[response valueForKey:@"AddressAvailable"],[response valueForKey:@"City"],[response valueForKey:@"District"],[response valueForKey:@"State"],[response valueForKey:@"Pincode"]] fontSize:14.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
    branchAddress.numberOfLines = 3;
    branchAddress.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [branchAddress sizeToFit];
    [viewMain addSubview:branchAddress];
    
    yPos = branchAddress.frame.origin.y + branchAddress.frame.size.height + 3.0;
    height = 20.0;
    width =  viewMain.frame.size.width - 40.0;
    UILabel *branchPhoneNo = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[response valueForKey:@"PhoneNo"]  fontSize:17.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
    branchPhoneNo.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [viewMain addSubview:branchPhoneNo];
    
    height = 20.0;
    width = 20.0;
    yPos = branchPhoneNo.frame.origin.y;
    xPos = viewMain.frame.size.width - width - 20.0;
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    phoneImageView.image = [UIImage imageNamed:@"icon_call_us.png"];
    phoneImageView.userInteractionEnabled = YES;
    [viewMain addSubview:phoneImageView];
    
    UITapGestureRecognizer *callGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callGestureTapped:)];
    [phoneImageView addGestureRecognizer:callGesture];
    
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

#pragma mark - Gesture Recognizer

- (void)callGestureTapped:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(callTappedWithNumber:)]) {
        NSArray *subviews = gesture.view.superview.subviews;
        UILabel *phone = (UILabel *)[subviews objectAtIndex:2];
        [ self.delegate callTappedWithNumber:phone.text];
    }
}



@end
