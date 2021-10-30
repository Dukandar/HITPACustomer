//
//  HospitalSearchTableViewCell.m
//  HITPA
//
//  Created by Bhaskar C M on 12/7/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HospitalSearchTableViewCell.h"
#import "Configuration.h"
#import "UIManager.h"
#import "Utility.h"

NSUInteger  const kHospitalOpenAndCloseTag  = 700000;
NSUInteger  const kHospitalDetailsTag       = 800000;
NSUInteger  const kHospitalCallTag          = 101;
NSUInteger  const kHospitalMapTag           = 102;
NSUInteger  const kHospitalCallImageTag     = 103;
NSUInteger  const kHospitalMapImageTag      = 104;
NSArray *contact;
NSArray *mapAddress;
NSString * const kHospitalSearchReuseIdentifier     = @"search";

@implementation HospitalSearchTableViewCell

- (instancetype)initWithDelegate:(id<hospitalSearchTableViewCell>)delegate indexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHospitalSearchReuseIdentifier];
    
    if (self)
    {
        self.indexPath = indexPath;
        self.response = response;
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self hospitalSearchTableViewCellWithType:response indexPath:indexPath];
        
    }
    
    
    return self;
}


- (void)hospitalSearchTableViewCellWithType:(NSMutableDictionary *)response indexPath:(NSIndexPath *)indexPath
{
    
    [self createHospitalSearchListViewWithIndexPath:indexPath response:response];
    
}


- (void)createHospitalSearchListViewWithIndexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 5.0;
    CGFloat height = 125.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = indexPath.row;
    viewMain.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewMain];
    
    xPos = 6.0;
    yPos = 0.0;
    width = viewMain.frame.size.width - 6.0;
    height = 50.0;
    UILabel *hospitalName = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[response  valueForKey:@"hospitalName"] objectAtIndex:indexPath.row] fontSize:16.0 fontColor:[UIColor colorWithRed:(0.0/255.0) green:(66.0/255.0) blue:(166.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
    hospitalName.numberOfLines = 2;
    hospitalName.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
    [viewMain addSubview:hospitalName];
    
    yPos = hospitalName.frame.size.height;
    height = 20.0;
    UILabel *hospitalArea = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[response valueForKey:@"searchHospitalCity"] objectAtIndex:indexPath.row] fontSize:17.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
    hospitalArea.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [viewMain addSubview:hospitalArea];
    
    yPos = hospitalName.frame.size.height + hospitalArea.frame.size.height + 5.0;
    UILabel *hospitalType = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[response valueForKey:@"hospitalProviderType"] objectAtIndex:indexPath.row] fontSize:17.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
    hospitalType.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0];
    [viewMain addSubview:hospitalType];
    
    height = 25.0;
    width = 25.0;
    xPos = 10.0;
    yPos = viewMain.frame.size.height - 32.0;
    UIView *viewStars = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //[viewMain addSubview:viewStars];
    
    height = 20.0;
    width = 20.0;
    xPos = 0.0;
    yPos = 0.0;
    UIImageView *ratingStar;
    
    int count = 2;
    
    for (int i = 1; i < count + 1; i++) {
        ratingStar = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        ratingStar.image = [UIImage imageNamed:@"icon_star.png"];
        [viewStars addSubview:ratingStar];
        xPos = (ratingStar.frame.size.width + 5.0) * i;
    }
    
    xPos = frame.size.width - 50.0;
    yPos = viewMain.frame.size.height - 57.0;
    width = 100.0;
    height = 50.0;
    UIView *viewDetails = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewDetails.backgroundColor = [UIColor clearColor];
    viewDetails.tag = kHospitalDetailsTag;
    [viewMain addSubview:viewDetails];
    
    xPos = 0.0;
    yPos = 0.0;
    width = viewDetails.frame.size.width/2;
    height = viewDetails.frame.size.height;
    UIView *viewCall = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewCall.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(119.0/255.0) blue:(219.0/255.0) alpha:1.0f];
    viewCall.layer.cornerRadius = viewCall.frame.size.width/2;
    viewCall.layer.masksToBounds = YES;
    contact = [response valueForKey:@"hospitalContactNumber"];
    [viewDetails addSubview:viewCall];
    
    xPos = viewCall.frame.size.width + 5.0;
    UIView *viewMap = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMap.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(119.0/255.0) blue:(219.0/255.0) alpha:1.0f];
    viewMap.layer.cornerRadius = viewMap.frame.size.width/2;
    viewMap.layer.masksToBounds = YES;
    mapAddress = [response valueForKey:@"address"];
    [viewDetails addSubview:viewMap];
    
    xPos = frame.size.width - 60.0;
    yPos = viewMain.frame.size.height - 57.0;
    width = 130.0;
    height = 50.0;
    UIView *viewOpenAndCloseBackGround = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewOpenAndCloseBackGround.backgroundColor = [UIColor whiteColor];
    viewOpenAndCloseBackGround.layer.cornerRadius = 25;
    viewOpenAndCloseBackGround.layer.masksToBounds = YES;
    [viewMain addSubview:viewOpenAndCloseBackGround];
    
    xPos = viewMain.frame.size.width - 60.0;
    yPos = viewMain.frame.size.height - 57.0;
    height = 50.0;
    width = 50.0;
    UIImageView *openAndClose = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    openAndClose.image = [UIImage imageNamed:@"icon_opened.png"];
    openAndClose.tag = kHospitalOpenAndCloseTag;
    openAndClose.userInteractionEnabled = YES;
    [viewMain addSubview:openAndClose];
    
    UITapGestureRecognizer *openAndCloseViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAndCloseView:)];
    [openAndClose addGestureRecognizer:openAndCloseViewTap];
    
    
    xPos = 8.0;
    yPos = 8.0;
    width = viewCall.frame.size.width - 16.0;
    height = viewCall.frame.size.height - 16.0;
    UIImageView *call = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    call.image = [UIImage imageNamed:@"icon_call"];
    call.tag = kHospitalCallImageTag;
    [viewCall addSubview:call];
    
    UIImageView *map = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    map.image = [UIImage imageNamed:@"icon_map"];
    map.tag = kHospitalMapImageTag;
    [viewMap addSubview:map];
    
    xPos = viewCall.frame.size.width - 1.0;
    yPos = 0.0;
    width = 1.0;
    height = viewCall.frame.size.height;
    UIView *callLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    callLine.backgroundColor = [UIColor colorWithRed:(167.0/255.0) green:(165.0/255.0) blue:(166.0/255.0) alpha:1.0f];
    //[viewCall addSubview:callLine];
    
    xPos = viewMap.frame.size.width - 1.0;
    yPos = 0.0;
    width = 1.0;
    height = viewCall.frame.size.height;
    UIView *mapLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    mapLine.backgroundColor = [UIColor colorWithRed:(167.0/255.0) green:(165.0/255.0) blue:(166.0/255.0) alpha:1.0f];
    //[viewMap addSubview:mapLine];
    
    UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTapped:)];
    viewCall.tag = indexPath.row;
    [viewCall addGestureRecognizer:callTap];
    
    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapTapped:)];
    viewMap.tag = indexPath.row;
    [viewMap addGestureRecognizer:mapTap];
    
    
}

- (void)callTapped:(UITapGestureRecognizer *)gesture
{
    if ([contact objectAtIndex:gesture.view.tag] == [NSNull null])
    {
        alertView(@"Do you want to call?", @"This number not available", self, @"Ok", nil, kHospitalCallTag);
    }
    else
    {
        alertView(@"Do you want to call?", [contact objectAtIndex:gesture.view.tag], self, @"Yes", @"No", kHospitalCallTag);
    }
    
}

- (void)mapTapped:(UITapGestureRecognizer *)gesture
{
    
    [[UIManager sharedUIManger]gotoMap:[mapAddress objectAtIndex:gesture.view.tag] hospitalName:[[self.response valueForKey:@"hospitalName"] objectAtIndex:gesture.view.tag]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kHospitalCallTag) {
        
        if (buttonIndex == 0)
        {
            
            if ([[self.response  valueForKey:@"hospitalContactNumber"] objectAtIndex:self.indexPath.row] != nil){
                NSString *contactNumber = [[self.response  valueForKey:@"hospitalContactNumber"] objectAtIndex:self.indexPath.row];
                contactNumber = [contactNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",contactNumber];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
                
                NSLog(@"phone call to %@", phoneCallNum);

            }

            
            
        }else
        {
            return;
        }
        
    }else if (alertView.tag == kHospitalMapTag){
        if (buttonIndex == 0)
        {
            
            
        }else
        {
            return;
        }
    }
    
}

- (void)openAndCloseView:(UITapGestureRecognizer *)gesture
{
    UIImageView *rotate = (UIImageView *)[self viewWithTag:kHospitalOpenAndCloseTag];
    UIImageView *rotateCall = (UIImageView *)[self viewWithTag:kHospitalCallImageTag];
    UIImageView *rotateMap = (UIImageView *)[self viewWithTag:kHospitalMapImageTag];
    
    UIView *profileView = (UIView *)[self viewWithTag:kHospitalDetailsTag];
    CGRect newProfile =  [(UIView *)[self viewWithTag:kHospitalDetailsTag] frame];
    if(profileView.frame.origin.x == self.frame.size.width - 50.0)
    {
        newProfile.origin.x = self.frame.size.width - 170.0;
        [UIView animateWithDuration:1.0 animations:^(void){
            profileView.frame = newProfile;
            NSTimeInterval duration = 1.0f;
            CGFloat angle = M_PI ;
            CGAffineTransform rotateTransform = CGAffineTransformRotate(rotate.transform, angle);
            CGAffineTransform rotateTransformCall = CGAffineTransformRotate(rotateCall.transform, angle);
            CGAffineTransform rotateTransformMap = CGAffineTransformRotate(rotateMap.transform, angle);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                rotate.transform = rotateTransform;
                rotateCall.transform = rotateTransformCall;
                rotateMap.transform = rotateTransformMap;
            } completion:nil];
        }];
        
        
        [UIView animateWithDuration:1.0 animations:^(void){
            NSTimeInterval duration = 1.0f;
            CGFloat angle = M_PI ;
            CGAffineTransform rotateTransformCall = CGAffineTransformRotate(rotateCall.transform, angle);
            CGAffineTransform rotateTransformMap = CGAffineTransformRotate(rotateMap.transform, angle);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                rotateCall.transform = rotateTransformCall;
                rotateMap.transform = rotateTransformMap;
            } completion:nil];
        }];
        
    }else{
        
        newProfile.origin.x = self.frame.size.width - 50.0;
        [UIView animateWithDuration:1.0 animations:^(void){
            profileView.frame = newProfile;
            NSTimeInterval duration = 1.0f;
            CGFloat angle = M_PI;
            CGFloat angle1 = M_PI;
            CGAffineTransform rotateTransform = CGAffineTransformRotate(rotate.transform, angle);
            CGAffineTransform rotateTransformCall = CGAffineTransformRotate(rotateCall.transform, angle1);
            CGAffineTransform rotateTransformMap = CGAffineTransformRotate(rotateMap.transform, angle1);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                rotate.transform = rotateTransform;
                rotateCall.transform = rotateTransformCall;
                rotateMap.transform = rotateTransformMap;
            } completion:nil];
        }];
        
        [UIView animateWithDuration:1.0 animations:^(void){
            NSTimeInterval duration = 1.0f;
            CGFloat angle = M_PI ;
            CGAffineTransform rotateTransformCall = CGAffineTransformRotate(rotateCall.transform, angle);
            CGAffineTransform rotateTransformMap = CGAffineTransformRotate(rotateMap.transform, angle);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                rotateCall.transform = rotateTransformCall;
                rotateMap.transform = rotateTransformMap;
            } completion:nil];
        }];
        
        
    }
    
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}

- (void)viewDetailsTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(([title isKindOfClass:[NSNull class]] ? @"" : title),@"");
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
