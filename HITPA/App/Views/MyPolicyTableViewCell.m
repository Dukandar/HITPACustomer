//
//  MyPolicyTableViewCell.m
//  HITPA
//
//  Created by Selma D. Souza on 09/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "MyPolicyTableViewCell.h"
#import "Configuration.h"
#import "DocumentDirectory.h"

NSString * const kPolicyCellIdentifier = @"cellIdentifier";

NSString * const kNewIndiaImage = @"icon_card_newindia.png";
NSString * const kOrientalImage = @"icon_card_oriental.png";
NSString * const kUnitedImage = @"icon_card_united.png";
NSString * const kNationalImage = @"icon_card_national.png";

NSString * const kUnitedIndia = @"United India Insurance Company Ltd";
NSString * const kOriental = @"The Oriental Insurance Company Ltd";
NSString * const kNewIndia = @"The New India Assurance Company Ltd";
NSString * const kNational = @"National Insurance Company Ltd";



@interface MyPolicyTableViewCell ()

@property(nonatomic, readwrite)CGFloat shiftForKeyboard;
@property (nonatomic, strong)       MyPolicyModel         * myPolicyDetails;

@end


@implementation MyPolicyTableViewCell

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath delegate:(id<myPolicyTableViewCell>)delegate policyDetail:(MyPolicyModel *)policyDetail policySectionType:(PolicySectionType)policySectionType cardDetails:(NSMutableDictionary *)cardDetails
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPolicyCellIdentifier];
    self.myPolicyDetails = policyDetail;
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (policySectionType == PolicyDetails) {
            
            [self myPolicyTypeWithIndexPath:indexPath policyDetail:policyDetail];

        }
        else if (policySectionType == MemberCard)
        {
            [self memberCardWithPolicyDetail:policyDetail indexPath:indexPath cardDetais:cardDetails];
        }
    }
    
    return self;
}

- (void)myPolicyTypeWithIndexPath:(NSIndexPath *)indexPath policyDetail:(MyPolicyModel *)policyDetail
{
    switch (indexPath.section) {
        case MembersEnrolled:
            [self createMembersEnrolledDetailsWithIndexPath:indexPath policyDetail:policyDetail];
            break;
        default:
            break;
    }
}

- (void)createWhatIsCoveredDetailsWithIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self bounds];
    CGFloat xPos = 50.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width - xPos - 5.0;
    CGFloat height = 310.0;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    textView.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.text = @"BASIC HEALTH COVER\n\nIf any insured Person suffers an illness or Accident during the Policy Period that Insured Person's Hospitalization as an inpatient, then Insurance company pay:\n1) Room rent, boarding expenses,\n2) Nursing,\n3) Intensive care unit,\n4) A Medical Practitioner,\n5) Anaesthesia, blood, oxygen, operation theatre charges, surgical appliances,\n6) Medicines, drugs and consumables,\n7) Diagnostic procedures,\n8) The cost of prosthetic and other devices or equipment if implanted internally during a Surgical Procedure.";
    [self.contentView addSubview:textView];
    
}

- (void)createMembersEnrolledDetailsWithIndexPath:(NSIndexPath *)indexPath policyDetail:(MyPolicyModel *)policyDetail
{
    CGRect frame = [self bounds];
    CGFloat xPos = 10.0;
    CGFloat yPos = 5.0;
    CGFloat width = (frame.size.width * 0.3) - 5.0;
    CGFloat height = 20.0;
    
    NSArray *memberDetail = policyDetail.memberDetails;
    
    if ( [memberDetail count] > 0)
    {

        NSArray *heading,*values;
        if ([policyDetail.policyStatus isEqualToString:@"Floater"]) //&& [[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberRelationship"] isEqualToString:@"Self"])
        {
            heading = [[NSArray alloc]initWithObjects:@"Insured name",@"UHID",@"Age",@"Gender",@"Relationship",@"Address", nil];
            values = [[NSArray alloc]initWithObjects:[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberName"],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"UHID"],[NSString stringWithFormat:@"%@ years",[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberAge"]],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberGender"],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberRelationship"],policyDetail.address, nil];
        }else
        {
            heading = [[NSArray alloc]initWithObjects:@"Insured name",@"UHID",@"Age",@"Gender",@"Relationship",@"Address",@"SI",@"BSI", nil];
            values = [[NSArray alloc]initWithObjects:[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberName"],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"UHID"],[NSString stringWithFormat:@"%@ years",[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberAge"]],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberGender"],[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"MemberRelationship"],policyDetail.address,(![[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"sumInsured"] isKindOfClass:[NSNull class]] && [[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"sumInsured"] length] > 0)?[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"sumInsured"]:@"NA",(![[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"balanceSumInsured"] isKindOfClass:[NSNull class]] && [[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"balanceSumInsured"] length] > 0)?[[memberDetail objectAtIndex:indexPath.row] valueForKey:@"balanceSumInsured"]:@"NA", nil];
        }
        CGFloat y = yPos;
            for (int i = 0; i < [values count]; i++) {
            
            xPos = 10.0;
            width = (frame.size.width * 0.3) - 5.0;
//            UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height)];
            UILabel *labelName;
            //        labelName.text = @"Spouse :";
                //Height for Label
                if (i == 5) {
                    labelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height+20)];
                } else {
                    labelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height)];
                }
            labelName.text = [NSString stringWithFormat:@"%@ :",[heading objectAtIndex:i]] ;
            labelName.textAlignment = NSTextAlignmentRight;
            labelName.textColor = [UIColor grayColor];
            labelName.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0];
            [self.contentView addSubview:labelName];
            
            xPos = labelName.frame.origin.x + labelName.frame.size.width + 5.0;
            width = (frame.size.width * 0.7) - 15.0;
//            UILabel *labelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height)];
            UILabel *labelValue;
            //Height for Label
                if (i == 5) {
                    labelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height+20)];
                } else {
                    labelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, y, width, height)];
                }
                
            labelValue.text = (![[values objectAtIndex:i] isKindOfClass:[NSNull class]])?[values objectAtIndex:i]:@"NA";
            labelValue.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:13.0];
            labelValue.numberOfLines = 0;
            NSLog(@"Adderess: %@", labelValue.text);
            [self.contentView addSubview:labelValue];
                
            y = y + labelName.frame.size.height;
                
        }
        xPos = 0.0;
        yPos = y + 5.0;
        width = frame.size.width;
        height = 1.0;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        
    }else
    {
        CGFloat width = frame.size.width;
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        labelName.text = @"No members enrolled in family";
        labelName.textAlignment = NSTextAlignmentLeft;
        labelName.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
        [self.contentView addSubview:labelName];
    }
    
}

- (void)createPolicyConditiosDetailsWithIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self bounds];
    CGFloat xPos = 50.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width / 5.0;
    CGFloat height = 30.0;
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    labelName.text = @"Code";
    labelName.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [self.contentView addSubview:labelName];
    
    xPos = labelName.frame.origin.x + labelName.frame.size.width + 5.0;
    width = frame.size.width - xPos - 5.0;
    UILabel *labelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    labelValue.text = @"Details";
    labelValue.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [self.contentView addSubview:labelValue];
    
    xPos = 50.0;
    yPos = labelName.frame.origin.y + labelName.frame.size.height;
    width = frame.size.width / 5.0;
    UILabel *firstLabelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    firstLabelName.text = @"2D";
    firstLabelName.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:firstLabelName];
    
    xPos = firstLabelName.frame.origin.x + firstLabelName.frame.size.width + 5.0;
    width = frame.size.width - xPos - 5.0;
    UILabel *firstLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    firstLabelValue.text = @"PE exclusion waived for all";
    firstLabelValue.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:firstLabelValue];
    
    xPos = 50.0;
    yPos = firstLabelName.frame.origin.y + firstLabelName.frame.size.height;
    width = frame.size.width / 5.0;
    UILabel *secondLabelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    secondLabelName.text = @"2C";
    secondLabelName.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:secondLabelName];
    
    xPos = secondLabelName.frame.origin.x + secondLabelName.frame.size.width + 5.0;
    width = frame.size.width - xPos - 5.0;
    UILabel *secondLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    secondLabelValue.text = @"1st year exclusion waived for all";
    secondLabelValue.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:secondLabelValue];
    
    xPos = 50.0;
    yPos = secondLabelName.frame.origin.y + secondLabelName.frame.size.height;
    width = frame.size.width / 5.0;
    UILabel *thirdLabelName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    thirdLabelName.text = @"2B";
    thirdLabelName.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:thirdLabelName];
    
    xPos = thirdLabelName.frame.origin.x + thirdLabelName.frame.size.width + 5.0;
    width = frame.size.width - xPos - 5.0;
    height = 40.0;
    UILabel *thirdLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    thirdLabelValue.text = @"30 days waiting period waived for all members";
    thirdLabelValue.numberOfLines = 0;
    thirdLabelValue.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [self.contentView addSubview:thirdLabelValue];
    
}

- (void)memberCardWithPolicyDetail:(MyPolicyModel *)policyDetail indexPath:(NSIndexPath *)indexPath cardDetais:(NSMutableDictionary *)cardDetails
{

    NSMutableArray *memberDetails = [NSMutableArray arrayWithArray:policyDetail.memberDetails];
    //policyDetail.memberDetails;
    
    NSString *strDate = policyDetail.policyFrom;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"]; //@"yyyy-MM-dd'T'HH:mm:ss"
    NSDate *date = [dateFormatter dateFromString:strDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    NSDictionary *personalDetails = [NSDictionary dictionaryWithObjectsAndKeys:policyDetail.memberAge,@"MemberAge",policyDetail.policyGender, @"MemberGender",policyDetail.memberName,@"MemberName",policyDetail.policyNumber,@"MemberPolicyNumber",@"Self",@"MemberRelationship",policyDetail.memberID,@"UHID",dateString,@"ValidTill", nil];
    
    //[memberDetails addObject:personalDetails];
    
    NSString *companyName = policyDetail.policyCompany;
    
    if ([[cardDetails valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue] == 0)
    {
        [self frontCardWithMemberDetails:memberDetails indexPath:indexPath companyName:companyName];
        
    }else  if ([[cardDetails valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue] == 1)
    {
        [self backCardIndexPath:indexPath];
        
    }
    
    
    CGRect frame = [self bounds];
    
    CGFloat xPos, yPos, width, height;
    xPos = 5.0;
    yPos = 240.0;
    width = frame.size.width - 10.0;
    height = 40.0;
    //Card Main View
    UIView *cardTrackingDetailView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardTrackingDetailView.backgroundColor = [UIColor whiteColor];
    cardTrackingDetailView.layer.borderWidth = 2.0;
    cardTrackingDetailView.layer.borderColor = [UIColor colorWithRed:15.0/255.0 green:144.0/255.0 blue:171.0/255.0 alpha:1.0].CGColor;
    cardTrackingDetailView.tag = indexPath.row;
    cardTrackingDetailView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:cardTrackingDetailView];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardTrackingDetailView.frame.size.width * 0.65;
    height = 20.0;
    
    UILabel *dispatchDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    dispatchDateLabel.text = @"MCard Dispatch Date :";
    dispatchDateLabel.textAlignment = NSTextAlignmentRight;
    //dispatchDateLabel.textColor = [UIColor whiteColor];
    dispatchDateLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [cardTrackingDetailView addSubview:dispatchDateLabel];
    
    NSString *strDispatchDate = [[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberCardDispatchDate"];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *dispatchDate = [dateFormatter dateFromString:([strDispatchDate isKindOfClass:[NSNull class]])?@"":strDispatchDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateDispatchString = [dateFormatter stringFromDate:dispatchDate];
    
    xPos = dispatchDateLabel.frame.origin.x + dispatchDateLabel.frame.size.width + 5.0;
    UILabel *dispatchDateValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    dispatchDateValue.text = (dateDispatchString == nil)?@"NA":dateDispatchString;
    //dispatchDateValue.textColor = [UIColor whiteColor];
    dispatchDateValue.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [cardTrackingDetailView addSubview:dispatchDateValue];
    
    xPos = 0.0;
    yPos = dispatchDateLabel.frame.size.height + dispatchDateLabel.frame.origin.y;
    width = cardTrackingDetailView.frame.size.width * 0.65;
    height = 20.0;
    
    UILabel *trackingReferenceNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    trackingReferenceNumLabel.text = @"Tracking Reference Number :";
    trackingReferenceNumLabel.textAlignment = NSTextAlignmentRight;
    //trackingReferenceNumLabel.textColor = [UIColor whiteColor];
    trackingReferenceNumLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [cardTrackingDetailView addSubview:trackingReferenceNumLabel];
    
    xPos = trackingReferenceNumLabel.frame.origin.x + trackingReferenceNumLabel.frame.size.width + 5.0;
    UILabel *trackingReferenceNumValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    trackingReferenceNumValue.text = ([[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"dispatchRefNumber"] isKindOfClass:[NSNull class]])?@"NA":[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"dispatchRefNumber"];
    //trackingReferenceNumValue.textColor = [UIColor whiteColor];
    trackingReferenceNumValue.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [cardTrackingDetailView addSubview:trackingReferenceNumValue];

    
}

- (void)frontCardWithMemberDetails:(NSArray *)memberDetails indexPath:(NSIndexPath *)indexPath companyName:(NSString *)companyName
{
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = [self bounds];
    
    // 4S font size
    CGFloat fontSize;
    fontSize = (frame.size.height == 480)?10.0 : 12.0;
    
    CGFloat xPos, yPos, width, height;
    xPos = 5.0;
    yPos = 0.0;
    width = frame.size.width - 10.0;
    height = 230.0;
    //Card Main View
    UIView *cardMainView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardMainView.backgroundColor = [UIColor clearColor];
    cardMainView.layer.borderWidth = 2.0;
    cardMainView.layer.borderColor = [UIColor colorWithRed:15.0/255.0 green:144.0/255.0 blue:171.0/255.0 alpha:1.0].CGColor;
    cardMainView.tag = indexPath.row;
    cardMainView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:cardMainView];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    xPos = 2.0;
    yPos = 1.0;
    width = cardMainView.frame.size.width - 4.0;
    height = 64.0;
    //Card Top View
    UIView *cardTopView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardTopView.backgroundColor = [UIColor whiteColor];
    cardTopView.tag = indexPath.row;
    [cardMainView addSubview:cardTopView];
    
    UITapGestureRecognizer *downloadGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadGuestureTapped:)];
    [cardMainView addGestureRecognizer:downloadGesture];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardTopView.frame.size.width;
    height = cardTopView.frame.size.height;
    //Top ImageView
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
   
    if ([companyName isEqualToString:kUnitedIndia]) {
        
        topImageView.image = [UIImage imageNamed:kUnitedImage];

    } else if ([companyName isEqualToString:kNational])
    {
        topImageView.image = [UIImage imageNamed:kNationalImage];
        
    } else if ([companyName isEqualToString:kOriental])
    {
        topImageView.image = [UIImage imageNamed:kOrientalImage];
        
    } else if ([companyName isEqualToString:kNewIndia])
    {
        topImageView.image = [UIImage imageNamed:kNewIndiaImage];

    }
  
        
    [cardTopView addSubview:topImageView];
    
    //Download image
    CGFloat widthHeight = 28.0;
    CGFloat padding = 2.0;
    UIImageView *downloadImage = [[UIImageView alloc]initWithFrame:CGRectMake(((cardTopView.frame.size.width - (widthHeight + padding))), 4.0, widthHeight, widthHeight)];
    [downloadImage setBackgroundColor:[UIColor clearColor]];
    [downloadImage setImage:[UIImage imageNamed:@"icon_blackdownload.png"]];
    [cardTopView addSubview:downloadImage];
    
    xPos = 2.0;
    yPos = cardTopView.frame.origin.y + cardTopView.frame.size.height;
    width = cardMainView.frame.size.width - 4.0;
    height = 100.0;
    //Card content View
    UIView *cardContentView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardContentView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    [cardMainView addSubview:cardContentView];
    
    width = cardContentView.frame.size.width * 0.75;
    height = 100.0;
    //Card Details View
    UIView *cardDetailView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardDetailView.backgroundColor = [UIColor clearColor];
    [cardMainView addSubview:cardDetailView];
    
    //Name Label
    xPos = 4.0;
    yPos = 5.0;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *nameLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Name" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:nameLbl];
    
    //Name Value
    xPos = nameLbl.frame.origin.x + nameLbl.frame.size.width;
    yPos = 5.0;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    UILabel *nameValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberName"] boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:nameValue];
    
    //Age Label
    xPos = 4.0;
    yPos = nameLbl.frame.origin.y + nameLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *ageLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Age" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:ageLbl];
    
    //Age Value
    xPos = ageLbl.frame.origin.x + ageLbl.frame.size.width;
    yPos = nameLbl.frame.origin.y + nameLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    UILabel *ageValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"%@ years",[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberAge"]] boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:ageValue];
    
    
    //Gender Label
    xPos = 4.0;
    yPos = ageLbl.frame.origin.y + ageLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *genderLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Gender" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:genderLbl];
    
    //Gender Value
    xPos = genderLbl.frame.origin.x + genderLbl.frame.size.width;
    yPos = ageLbl.frame.origin.y + ageLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    UILabel *genderValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberGender"] boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:genderValue];
    
    //UHID Label
    xPos = 4.0;
    yPos = genderLbl.frame.origin.y + genderLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *uhidLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"UHID" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:uhidLbl];
    
    //UHID Value
    xPos = uhidLbl.frame.origin.x + uhidLbl.frame.size.width;
    yPos = genderLbl.frame.origin.y + genderLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    UILabel *uhidValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"UHID"] boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:uhidValue];
    
    
    //policy no Label
    xPos = 4.0;
    yPos = uhidLbl.frame.origin.y + uhidLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *policyLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Policy No" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:policyLbl];
    
    //Policy No  Value
    xPos = policyLbl.frame.origin.x + policyLbl.frame.size.width;
    yPos = uhidLbl.frame.origin.y + uhidLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    UILabel *policyValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberPolicyNumber"] boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:policyValue];
    
    //Valid from Label
    xPos = 4.0;
    yPos = policyLbl.frame.origin.y + policyLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.3;
    height = 15.0;
    UILabel *validLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Valid from" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    validLbl.backgroundColor = [UIColor clearColor];
    [cardDetailView addSubview:validLbl];
    
    //Valid from  Value
    xPos = validLbl.frame.origin.x + validLbl.frame.size.width;
    yPos = policyLbl.frame.origin.y + policyLbl.frame.size.height;
    width = cardDetailView.frame.size.width * 0.7 - 4.0;
    height = 15.0;
    
    NSString *strDate = [[memberDetails objectAtIndex:indexPath.row] valueForKey:@"ValidTill"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSLog(@"%@", dateString);
    
    UILabel *validValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:(dateString != nil && [dateString length] > 0)?dateString:@"NA" boldFontSize:fontSize fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    [cardDetailView addSubview:validValue];
    
    /* //OLD Code
    //Member ImageView
    xPos = cardDetailView.frame.origin.x + cardDetailView.frame.size.width + 5.0;
    yPos = 5.0;
    width = (cardContentView.frame.size.width * 0.25) - 10.0;
    height = cardDetailView.frame.size.height - 10.0;
    UIImageView *memberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //    memberImageView.backgroundColor = [UIColor blackColor];
    memberImageView.image = [UIImage imageNamed:@"icon_userprofile.png"];
    memberImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardContentView addSubview:memberImageView];
    */
    
    //To check Image Type
    //NEW Code
    NSString *stringName = [[memberDetails objectAtIndex:indexPath.row] valueForKey:@"MemberName"];
    NSString *imageNamee = [stringName stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", imageNamee];
    
    //Member ImageView
    xPos = cardDetailView.frame.origin.x + cardDetailView.frame.size.width + 5.0;
    yPos = 5.0;
    width = (cardContentView.frame.size.width * 0.25) - 10.0;
    height = cardDetailView.frame.size.height - 10.0;
    UIImageView *memberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//    memberImageView.layer.cornerRadius = 15;
//    memberImageView.clipsToBounds = true;
    //    memberImageView.backgroundColor = [UIColor blackColor];
    
    
    NSData *imageData = [[DocumentDirectory shareDocumentDirectory] getImageOrPdfWithName:imageName];
    if (imageData != nil) {
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        memberImageView.image = image;
    } else {
        memberImageView.image = [UIImage imageNamed:@"doc_icon.png"];
    }

    memberImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardContentView addSubview:memberImageView];
    
    xPos = 2.0;
    yPos = cardContentView.frame.origin.y + cardContentView.frame.size.height;
    width = cardMainView.frame.size.width - 4.0;
    height = 64.0;
    //Card Bottom View
    UIView *cardBottomView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardBottomView.backgroundColor = [UIColor clearColor];
    [cardMainView addSubview:cardBottomView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardBottomView.frame.size.width;
    //Bottom ImageView
    UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    bottomImageView.image = [UIImage imageNamed:@"icon_card_front_footer.png"];
//    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cardBottomView addSubview:bottomImageView];
    
    
    xPos = cardBottomView.frame.size.width - 25.0;
    yPos = cardBottomView.frame.size.height - 30.0;
    width = 20.0;
    height = 20.0;
    //Button View
    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    buttonImageView.image = [UIImage imageNamed:@"icon_flip.png"];
    [cardBottomView addSubview:buttonImageView];
    
    xPos = cardBottomView.frame.size.width - 60.0;
    yPos = 0.0;
    width = 60.0;
    height = cardBottomView.frame.size.height;
    //Flip Button
    UIButton *flipBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [flipBtn setTitle:@"" forState:UIControlStateNormal];
    [flipBtn setBackgroundColor:[UIColor clearColor]];
    [flipBtn.layer setMasksToBounds:YES];
    [flipBtn addTarget:self action:@selector(flipBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardBottomView addSubview:flipBtn];

}


 //OLD Code
- (void)backCardIndexPath:(NSIndexPath *)indexPath
{
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = [self bounds];
    
    // 4S font size
    CGFloat fontSize;
    fontSize = (frame.size.height == 480)?10.0 : 12.0;
    
    CGFloat xPos, yPos, width, height;
    xPos = 5.0;
    yPos = 0.0;
    width = frame.size.width - 10.0;
    height = 230.0;
    //Card Main View
    UIView *cardMainView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardMainView.backgroundColor = [UIColor clearColor];
    cardMainView.layer.borderWidth = 2.0;
    cardMainView.layer.borderColor = [UIColor colorWithRed:15.0/255.0 green:144.0/255.0 blue:171.0/255.0 alpha:1.0].CGColor;
    cardMainView.layer.cornerRadius = 5.0;
    cardMainView.tag = indexPath.row;
    [self.contentView addSubview:cardMainView];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    xPos = 2.0;
    yPos = 1.0;
    width = cardMainView.frame.size.width - 4.0;
    height = 64.0;
    //Card Top View
    UIView *cardTopView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardTopView.backgroundColor = [UIColor whiteColor];
    cardTopView.tag = indexPath.row;
    [cardMainView addSubview:cardTopView];
    
    UITapGestureRecognizer *downloadGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadGuestureTapped:)];
    [cardMainView addGestureRecognizer:downloadGesture];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardTopView.frame.size.width;
    height = cardTopView.frame.size.height;
    //Top ImageView
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //    topImageView.backgroundColor = [UIColor blackColor];
    topImageView.image = [UIImage imageNamed:@"icon_card_back_header.png"];
    [cardTopView addSubview:topImageView];

    //Download image
    CGFloat widthHeight = 28.0;
    CGFloat padding = 6.0;
    UIImageView *downloadImage = [[UIImageView alloc]initWithFrame:CGRectMake(((cardTopView.frame.size.width - (widthHeight + padding))), 4.0, widthHeight, widthHeight)];
    [downloadImage setImage:[UIImage imageNamed:@"icon_blackdownload.png"]];
    [cardTopView addSubview:downloadImage];
    
    xPos = 2.0;
    yPos = cardTopView.frame.origin.y + cardTopView.frame.size.height;
    width = cardMainView.frame.size.width - 4.0;
    height = 105.0;
    //Card content View
    UIView *cardContentView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardContentView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    [cardMainView addSubview:cardContentView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardContentView.frame.size.width;
    //Content ImageView
    UIImageView *contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    contentImageView.image = [UIImage imageNamed:@"icon_card_back_content.png"];
    //    bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardContentView addSubview:contentImageView];
    
    xPos = 2.0;
    yPos = cardContentView.frame.origin.y + cardContentView.frame.size.height;
    width = cardMainView.frame.size.width - 4.0;
    height = 59.0;
    //Card Bottom View
    UIView *cardBottomView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    cardBottomView.backgroundColor = [UIColor clearColor];
    [cardMainView addSubview:cardBottomView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = cardBottomView.frame.size.width;
    //Bottom ImageView
    UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    bottomImageView.image = [UIImage imageNamed:@"icon_card_back_footer.png"];
    //    bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardBottomView addSubview:bottomImageView];
    
    xPos = cardBottomView.frame.size.width - 25.0;
    yPos = cardBottomView.frame.size.height - 30.0;
    width = 20.0;
    height = 20.0;
    //Button View
    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    buttonImageView.image = [UIImage imageNamed:@"icon_flip.png"];
    [cardBottomView addSubview:buttonImageView];
    
    xPos = cardBottomView.frame.size.width - 60.0;
    yPos = 0.0;
    width = 60.0;
    height = cardBottomView.frame.size.height;
    //Flip Button
    UIButton *flipBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [flipBtn setTitle:@"" forState:UIControlStateNormal];
    [flipBtn setBackgroundColor:[UIColor clearColor]];
    [flipBtn.layer setMasksToBounds:YES];
    [flipBtn addTarget:self action:@selector(flipBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardBottomView addSubview:flipBtn];

}

//New Code
//- (void)backCardIndexPath:(NSIndexPath *)indexPath
//{
//
//    self.backgroundColor = [UIColor clearColor];
//
//    CGRect frame = [self bounds];
//
//    // 4S font size
//    CGFloat fontSize;
//    fontSize = (frame.size.height == 480)?10.0 : 12.0;
//
//    CGFloat xPos, yPos, width, height;
//    xPos = 5.0;
//    yPos = 0.0;
//    width = frame.size.width - 10.0;
//    height = 230.0;
//    //Card Main View
//    UIView *cardMainView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//    cardMainView.backgroundColor = [UIColor clearColor];
//    cardMainView.layer.borderWidth = 2.0;
//    cardMainView.layer.borderColor = [UIColor colorWithRed:15.0/255.0 green:144.0/255.0 blue:171.0/255.0 alpha:1.0].CGColor;
//    cardMainView.layer.cornerRadius = 5.0;
//    cardMainView.tag = indexPath.row;
//    [self.contentView addSubview:cardMainView];
//    [self.contentView setBackgroundColor:[UIColor clearColor]];
//
//    xPos = cardMainView.frame.origin.x-5;
//    yPos = cardMainView.frame.origin.y-1;
//    width = cardMainView.frame.size.width;
//    height = cardMainView.frame.size.height+1;
//    //Top ImageView
//    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//    //    topImageView.backgroundColor = [UIColor blackColor];
//    topImageView.image = [UIImage imageNamed:@"E-Card_back.jpg"];
//    topImageView.layer.cornerRadius = 5.0;
//    [cardMainView addSubview:topImageView];
//
//    xPos = cardMainView.frame.size.width - 30.0;
//    yPos = cardMainView.frame.size.height - 30.0;
//    width = 20.0;
//    height = 20.0;
//    //Button View
//    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//    buttonImageView.image = [UIImage imageNamed:@"icon_flip.png"];
//    [cardMainView addSubview:buttonImageView];
//
//    xPos = buttonImageView.frame.origin.x-5;
//    yPos = buttonImageView.frame.origin.y-5;
//    width = buttonImageView.frame.size.width+10;
//    height = buttonImageView.frame.size.height+10;
//    //Flip Button
//    UIButton *flipBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//    [flipBtn setTitle:@"" forState:UIControlStateNormal];
//    [flipBtn setBackgroundColor:[UIColor clearColor]];
//    [flipBtn.layer setMasksToBounds:YES];
//    [flipBtn addTarget:self action:@selector(flipBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [cardMainView addSubview:flipBtn];
//}

#pragma mark - Button delegate
//- (void)callGuestureTapped:(UITapGestureRecognizer *)gesture
- (void)downloadGuestureTapped:(UITapGestureRecognizer *)gesture{
    NSDictionary *dictionary = (NSDictionary*)self.myPolicyDetails.memberDetails[gesture.view.tag];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dictionary valueForKey:@"EcartURL"]]];
}
- (IBAction)flipBtnTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO)
    {
        view = [view superview];
    }
    UITableView *superView = (UITableView *)view;
    CGPoint center = button.center;
    CGPoint point = [button.superview convertPoint:center toView:superView];
    
    NSIndexPath *indexPath = [superView indexPathForRowAtPoint:point];
    
//    if ([self.delegate respondsToSelector:@selector(cardTypeWithIndexPath:)]) {
//        [self.delegate cardTypeWithIndexPath:indexPath];
//    }
    
    UIView *flipView = (UIView *)[self viewWithTag:indexPath.row];
    
       
    [UIView transitionWithView:flipView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

        
    }completion:^(BOOL finished){
        
            if ([self.delegate respondsToSelector:@selector(cardTypeWithIndexPath:)]) {
                [self.delegate cardTypeWithIndexPath:indexPath];
            }

    }];
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title boldFontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
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

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
