//
//  HospitalDetailTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "HospitalDetailTableViewCell.h"
#import "Configuration.h"
#import "UIManager.h"
#import "Utility.h"

NSString *  const kHospitalDetailsReuseIdentifier    = @"details";
NSUInteger  const kHospitalDetailCallImageTag        = 1113;
NSUInteger  const kHospitalDetailMapImageTag         = 1114;
NSUInteger  const kHospitalDetailCallTag             = 1123;
NSUInteger  const kHospitalDetailMapTag              = 1124;

@implementation HospitalDetailTableViewCell


- (instancetype)initWithDelegate:(id<hospitalDetailsTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    
    self.details = [[NSMutableDictionary alloc]init];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHospitalDetailsReuseIdentifier];
    
    if (self)
    {
        self.details = response;
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self createHospitalSearchListViewWithIndexPath:indexPath response:response];
        
    }
    
    
    return self;
}

- (void)createHospitalSearchListViewWithIndexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 50.0;
    CGFloat width = frame.size.width;
    
    if (indexPath.row == 0) {
        
        UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 6.0;
        yPos = 0.0;
        width = viewMain.frame.size.width - 12.0;
        height = 50.0;
        UILabel *hospitalName = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[response  valueForKey:@"hospitalName"] fontSize:16.0 fontColor:[UIColor colorWithRed:(0.0/255.0) green:(66.0/255.0) blue:(166.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
        hospitalName.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:19.0];
        hospitalName.numberOfLines = 2;
        [viewMain addSubview:hospitalName];
        
    }else if (indexPath.row == 1){
     
        height = 100.0;
        UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 6.0;
        yPos = 0.0;
        width = viewMain.frame.size.width - 36.0;
        height = 40.0;
        UILabel *location = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Location" fontSize:17.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        location.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
        [viewMain addSubview:location];
        
        xPos = 6.0;
        yPos = 35.0;
        width = viewMain.frame.size.width - 66.0;
        height = 50.0;
        UILabel *hospitalArea = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[response valueForKey:@"address"] fontSize:17.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        hospitalArea.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
        hospitalArea.numberOfLines = 10;
        [hospitalArea sizeToFit];
        [viewMain addSubview:hospitalArea];
        
        
        xPos = frame.size.width - 50.0;
        yPos = 10.0;
        width = 40.0;
        height = 40.0;
        UIView *viewCall = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewCall.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(119.0/255.0) blue:(219.0/255.0) alpha:1.0f];
        viewCall.layer.cornerRadius = viewCall.frame.size.width/2;
        viewCall.layer.masksToBounds = YES;
        [viewMain addSubview:viewCall];
        
        
        yPos = viewCall.frame.size.height + 18.0;
        UIView *viewMap = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMap.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(119.0/255.0) blue:(219.0/255.0) alpha:1.0f];
        viewMap.layer.cornerRadius = viewMap.frame.size.width/2;
        viewMap.layer.masksToBounds = YES;
        [viewMain addSubview:viewMap];
        
        xPos = 6.0;
        yPos = 6.0;
        width = viewCall.frame.size.width - 12.0;
        height = viewCall.frame.size.height - 12.0;
        UIImageView *call = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        call.image = [UIImage imageNamed:@"icon_call"];
        viewCall.tag = kHospitalDetailCallImageTag;
        [viewCall addSubview:call];
        
        UIImageView *map = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        map.image = [UIImage imageNamed:@"icon_map"];
        viewMap.tag = kHospitalDetailMapImageTag;
        [viewMap addSubview:map];
        
        
        UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTapped:)];
        [viewCall addGestureRecognizer:callTap];
        
        UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapTapped:)];
        [viewMap addGestureRecognizer:mapTap];
        
        
    }else{
       
        
        height = 50.0;
        UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 6.0;
        yPos = 0.0;
        width = 100.0;
        height = 50.0;
        UILabel *city = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"City name :" fontSize:17.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        city.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
        [viewMain addSubview:city];
        
        xPos = city.frame.size.width + 8.0;
        width = frame.size.width - (city.frame.size.width + 12.0);
        UILabel *hospitalArea = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[response valueForKey:@"searchHospitalCity"] fontSize:17.0 fontColor:[UIColor grayColor] alignment:NSTextAlignmentLeft];
        hospitalArea.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:17.0];
        hospitalArea.numberOfLines = 2;
        [viewMain addSubview:hospitalArea];
        
        
    }
    
    
}


- (void)callTapped:(UITapGestureRecognizer *)gesture
{
    
    if ([self.details valueForKey:@"hospitalContactNumber"] == [NSNull null])
    {
        alertView(@"HITPA", @"This number not available", self, @"Ok", nil, kHospitalDetailCallTag);
    }
    else
    {
        alertView(@"Do you want to call?", [self.details valueForKey:@"hospitalContactNumber"], self, @"Yes", @"No", kHospitalDetailCallTag);
    }
    
    
}

- (void)mapTapped:(UITapGestureRecognizer *)gesture
{
    
    [[UIManager sharedUIManger]gotoMap:[self.details valueForKey:@"address"] hospitalName:[self.details valueForKey:@"hospitalName"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kHospitalDetailCallTag) {
        
        if (buttonIndex == 0)
        {
            if ([self.details valueForKey:@"hospitalContactNumber"] == [NSNull null]){
                
            }else{
                
                NSString *contactNumber = [self.details valueForKey:@"hospitalContactNumber"];
                contactNumber = [contactNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",contactNumber];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
                
                NSLog(@"phone call to %@", phoneCallNum);
                
            }
            
            
        }else
        {
            return;
        }
        
    }
    
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


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
