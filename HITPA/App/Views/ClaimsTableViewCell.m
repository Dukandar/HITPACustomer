//
//  ClaimsTableViewCell.m
//  HITPA
//
//  Created by Selma D. Souza on 07/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "ClaimsTableViewCell.h"
#import "Configuration.h"
#import "Gradients.h"
#import "Constants.h"
#import "HITPAUserDefaults.h"
#import "Helper.h"
#import "Utility.h"
#import "HITPAAPI.h"
#import "KeyboardConstants.h"
//#import "KeyboardHelper.h"
#import "CoreData.h"
#import "ClaimsJunction.h"
#import "MBProgressHUD.h"
#import "DocumentDirectory.h"


NSString * const kClaimCellIdentifier       = @"cellIdentifier";
NSString * const kNoHospitalFound           = @"No hospitals found";

NSInteger  const kDateOfAdmission           = 2000;
NSInteger  const kExpectedDateOfDischarge   = 3000;
NSInteger  const kSearchHospitalNameTag     = 4000;
NSInteger  const kSearchPincodeTag          = 5000;
NSInteger  const kSearchCityNameTag        = 6000;

@interface ClaimsTableViewCell () <UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSInteger selectedSegment;
}

@property (nonatomic, strong)   MBProgressHUD   *   progressHUD;
@property (nonatomic, strong)   ClaimsJunction   *  claimsResponse;

@end

NSMutableDictionary *search = @"";


@implementation ClaimsTableViewCell


- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath delegate:(id<claimsTableViewCell>)delegate segment:(NSInteger)segment response:(NSMutableDictionary *)response hospitalDetail:(NSMutableDictionary *)claimsDetail imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach selectedArray:(NSMutableArray *)selectedArray
{
    
    self.selectedArray = selectedArray;
    self.imagesArray = imagesArray;
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClaimCellIdentifier];
    selectedSegment =segment;
    search = [[NSMutableDictionary alloc]init];
    if (self)
    {
        self.delegate = delegate;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([response count] > 0 && segment == 1)
            self.claimsResponse = (ClaimsJunction *)[(NSArray *)response objectAtIndex:indexPath.section];
        if (segment == 0) {
            [self claimTypeWithIndexPath:indexPath hospitalDetail:claimsDetail imagesArray:self.imagesArray isAttach:isAttach];
        }else{
            [self createClaimHistoryDetailsWithIndexPath:indexPath response:response];
        }
    }
    return self;
}

- (void)claimTypeWithIndexPath:(NSIndexPath *)indexPath hospitalDetail:(NSMutableDictionary *)hospitalDetail imagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach
{
    
    switch (indexPath.section) {
        case HospitalSearch:
            [self createHospitalDetailsWithIndexPath:indexPath hospitalDetail:hospitalDetail];
            break;
        case PatientDetails:
            [self createPatientDetailsWithIndexPath:indexPath hospitalDetail:hospitalDetail];
            break;
        case HospitalizationDetails:
            [self createHospitalizationDetailsWithIndexPath:indexPath hospitalDetail:hospitalDetail];
            break;
        case 4:
            [self creatClaimRaiseMediaSecitionimagesArray:imagesArray isAttach:isAttach];
            break;
        default:
            break;
    }
}



-(void)creatClaimRaiseMediaSecitionimagesArray:(NSMutableArray *)imagesArray isAttach:(BOOL) isAttach{
     CGRect frame = [[UIScreen mainScreen] bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //        self.contentView.backgroundColor = [UIColor redColor];
           // if (indexPath.section == 1) {
                int isPosition=68;
                if([imagesArray count] > 0) {
                    
                    long int isDivison=[imagesArray count]/3,m=0;
                    isPosition=68;
                    NSMutableArray *array_height=[[NSMutableArray alloc]init];
                    for (int r=0; r< isDivison+1; r++) {
                        [array_height addObject:[NSString stringWithFormat:@"%d",isPosition]];
                        isPosition=isPosition+80;
                    }
                    
                    for (int k=0; k < isDivison+1; k++) {
                        
                        int i=0;
                        for (int t=0; t < 3; t++) {
                            if(m < [imagesArray count]) {
                                UIView *viewImages=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/3*i+20, [[array_height objectAtIndex:k] integerValue]-60, 80, 70)];
                                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 50, 50)];
                                UILabel * labelImageName = [[UILabel alloc]initWithFrame:CGRectMake(3, 52, 80, 18)];
    //                            labelImageName.textAlignment = NSTextAlignmentCenter;
                                labelImageName.numberOfLines = 0;
                                labelImageName.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaFontWithSize:14.0] : [[Configuration shareConfiguration] hitpaFontWithSize:8.0];
                                UIButton *btnsel=[[UIButton alloc]initWithFrame:CGRectMake(56, 2, 25, 18)];
                                btnsel.tag=m+1;
                                btnsel.layer.cornerRadius = 3.0f;
                                btnsel.layer.borderColor=[[UIColor grayColor]CGColor];
    //                            btnsel.layer.borderWidth=1.0f;
                                btnsel.layer.masksToBounds=YES;
                                [btnsel setBackgroundImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
                                [btnsel addTarget:self action:@selector(imgSel:) forControlEvents:UIControlEventTouchUpInside];
    //                            imageView.image=[[imagesArray objectAtIndex:m]valueForKey:[NSString stringWithFormat:@"Image_%ld",m+1]]; //OLD Code
                                NSString *imageName = [imagesArray objectAtIndex:m];
                                //To check Image Type
                                if ([imageName containsString:@".jpg"] || [imageName containsString:@".png"] || [imageName containsString:@".jpeg"]) {
                                    NSData *imageData = [[DocumentDirectory shareDocumentDirectory] getClaimImageOrPdfWithName:imageName];
                                    UIImage *image = [[UIImage alloc]initWithData:imageData];
                                    imageView.image = image;
                                    labelImageName.text = imageName;
                                } else {
                                    imageView.image = [UIImage imageNamed:@"doc_icon.png"];
                                    labelImageName.text = imageName;
                                }
                        
                                [viewImages addSubview:imageView];
                                [viewImages addSubview:labelImageName];
                                [viewImages addSubview:btnsel];
                                viewImages.backgroundColor=[UIColor clearColor];
    //                            viewImages.backgroundColor=[UIColor blueColor];
                                [self.contentView addSubview:viewImages];
                                i++;
                                m++;
                            }
                        }
                    }
                }
            //}
}

-(IBAction)imgSel:(id)sender {

    [(UIButton *)[self.contentView viewWithTag:[(id)sender tag]] setBackgroundImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
    [self.selectedArray addObject:[NSString stringWithFormat:@"%ld",(long)[(id)sender tag]]];
    
    if ([self.delegate respondsToSelector:@selector(getChoosedImages:)])
    {
        [self.delegate getChoosedImages:self.selectedArray];
    }
}

- (void)createHospitalDetailsWithIndexPath:(NSIndexPath *)indexPath hospitalDetail:(NSMutableDictionary *)hospitalDetail

{
    
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    
    HospitalModel *detail = (HospitalModel *)[hospitalDetail valueForKey:@"hospitaldetail"] ;
    
    if (detail.hospitalName != nil )
    {
        
        xPos = 0.0;
        yPos = 5.0;
        height = 150.0;
        width = frame.size.width;
        UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        viewMain.tag = indexPath.row;
        viewMain.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewMain];
        
        xPos = 6.0;
        yPos = 2.0;
        width = 150.0;
        height = 40.0;
        UILabel *hospitalName = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) text:@"Hospital Name :"];
        [viewMain addSubview:hospitalName];
        width = viewMain.frame.size.width - 12.0;
        height = 42.0;
        yPos = hospitalName.frame.size.height + 2.0;
        UITextField *textField  = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [textField setFont:[[Configuration shareConfiguration] hitpaFontWithSize:14.0]];
        textField.userInteractionEnabled = NO;
        textField.text = detail.hospitalName;
        [viewMain addSubview:textField];
        [textField.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [textField.layer setBorderWidth:0.5];
        [textField.layer setCornerRadius:5.0];
        [textField.layer setMasksToBounds:YES];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, textField.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        
        
        yPos = textField.frame.size.height + textField.frame.origin.y;
        UILabel * addressLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) text:@"Hosptial address : "];
        [viewMain addSubview:addressLbl];
        [addressLbl setTextColor:[UIColor grayColor]];
        yPos = addressLbl.frame.size.height + addressLbl.frame.origin.y;
        UILabel *address = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) text:detail.address];
        [address setTextColor:[UIColor grayColor]];
        [address setNumberOfLines:0];
        [address sizeToFit];
        [viewMain addSubview:address];
        
        
        width = 150.0;
        height = 38.0;
        yPos = address.frame.size.height + address.frame.origin.y + 6.0;
        xPos = roundf((frame.size.width - width)/2);
        
        UIButton *searchAgainButtonTapped = [self createButtonWithFrame:CGRectMake(xPos, yPos, width, height) title:NSLocalizedString(@"SEARCH AGAIN", @"")];
        [searchAgainButtonTapped addTarget:self action:@selector(searchAgianButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [viewMain addSubview:searchAgainButtonTapped];
        
        [viewMain setFrame:CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, hospitalName.frame.size.height + textField.frame.size.height + addressLbl.frame.size.height + address.frame.size.height + searchAgainButtonTapped.frame.size.height + searchAgainButtonTapped.frame.size.height - 20.0)];
        
        
        
        
    }else
    {
        
        NSAttributedString *attributedPlaceholder;
        
        switch (indexPath.row) {
            case 0:
                attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Hospital Name" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
                break;
            case 1:
                attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"or Pincode" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
                break;
            case 2:
                attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"or City" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
                break;
                
            default:
                break;
        }
        
        if (indexPath.row != 3)
        {
            xPos = 3.0;
            yPos = 15.0;
            height = 40.0;
            width = frame.size.width - 2 * xPos;
            
            UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor] tag:indexPath.row];
            [self.contentView addSubview:viewMain];
            
            xPos = 5.0;
            yPos = 5.0;
            width = viewMain.frame.size.width - 2 * xPos;
            height = 30.0;
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            textField.tag = (indexPath.row == 0)?kSearchHospitalNameTag:(indexPath.row == 1)?kSearchPincodeTag:kSearchCityNameTag;
            //            textField.tag = [[NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row]integerValue];
            textField.delegate = self;
            textField.attributedPlaceholder = attributedPlaceholder;
            textField.textColor = [UIColor blackColor];
            
            textField.font = [[Configuration shareConfiguration] hitpaFontWithSize:12.0];
//            if ([textField.placeholder  isEqualToString:@"Hospital Name"])
//            {
//               [textField becomeFirstResponder];
//            }
            
            if ([textField.placeholder  isEqualToString:@"Pincode"])
            {
//                [textField setKeyboardType:[[KeyboardHelper sharedKeyboardHelper]keyValues:numberPadKeyboard]];
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            [viewMain addSubview:textField];
            
        }
        else
        {
            xPos = 0.0;
            yPos = 5.0;
            height = 40.0;
            width = frame.size.width - 2 * xPos;
            UIView *viewMain = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            viewMain.tag = indexPath.row;
            viewMain.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:viewMain];
            
            xPos = 10.0;
            yPos = 0.0;
            width = frame.size.width / 3.5;
            UIButton *nearMeButton = [self createButtonWithFrame:CGRectMake(xPos, yPos, width, height) title:@"NEAR ME"];
            [nearMeButton addTarget:self action:@selector(nearMeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [viewMain addSubview:nearMeButton];
            
            xPos = frame.size.width - width - 10.0;
            UIButton *searchButton = [self createButtonWithFrame:CGRectMake(xPos, yPos, width, height) title:@"SEARCH"];
            [searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [viewMain addSubview:searchButton];
            
        }
        
        
    }
    
    
}


- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setText:NSLocalizedString(text, @"")];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    return label;
    
}

- (void)createPatientDetailsWithIndexPath:(NSIndexPath *)indexPath hospitalDetail:hospitalDetail
{
    NSAttributedString *attributedPlaceholder;
    
    switch (indexPath.row) {
        case 0:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Patient Name" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
            break;
        case 1:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"UHID" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 2:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Policy Number" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 3:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Claim Type" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
            break;
        case 4:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Relationship" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 5:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 6:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        default:
            break;
    }
    

    
    CGRect frame = [self bounds];
    CGFloat xPos = 3.0;
//    CGFloat yPos = 10.0;
    CGFloat yPos = 5.0;
    CGFloat height = 30.0;
    CGFloat width = frame.size.width - 2 * xPos;
    CGFloat labelHeight = 25.0;
    
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height+height) backgroundColor:[UIColor whiteColor] tag:indexPath.row]; //white
    [viewMain setTag:23213];
    [self.contentView addSubview:viewMain];
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        
//        xPos = 5.0;
//        yPos = 10.0;
        width = (viewMain.frame.size.width - 2 * xPos) - 30.0;
        height = 30.0;
    }
    else
    {
//        xPos = 5.0;
//        yPos = 10.0;
        width = viewMain.frame.size.width - 2 * xPos;
        height = 30.0;
    }
//    xPos = 5.0;
//    yPos = 10.0;
//    width = viewMain.frame.size.width - 2 * xPos;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, labelHeight)];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, label.frame.size.height + yPos, width, height)];
//    label.backgroundColor = [UIColor redColor];
//    textField.backgroundColor = [UIColor greenColor];
//    viewMain.backgroundColor = [UIColor yellowColor];
    
    textField.attributedPlaceholder = attributedPlaceholder;
    [textField setUserInteractionEnabled:(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5)?NO:YES];

    if (indexPath.row == 0)
    {
        label.text = @"Select Patient Name";
        textField.text = [hospitalDetail valueForKey:@"patientName"];
        
    }else if (indexPath.row == 5)
    {
        label.text = @"Phone Number";
        textField.text = [hospitalDetail valueForKey:@"phoneNo"];
        textField.enabled = NO;
        
        
    }else if (indexPath.row == 6)
    {
        label.text = @"Email Address";
        textField.text = [hospitalDetail valueForKey:@"emailAddress"];
        textField.enabled = NO;
//        [[KeyboardHelper sharedKeyboardHelper]keyValues:emailKeyboard];
        textField.keyboardType = UIKeyboardTypeEmailAddress;

    }
    
    if(indexPath.row == 1 && [hospitalDetail valueForKey:@"UHID"])
    {
        label.text = @"UHID";
        textField.text = [hospitalDetail valueForKey:@"UHID"];
        textField.enabled = NO;
    }
    else if(indexPath.row == 2 && [hospitalDetail valueForKey:@"MemberPolicyNumber"])
    {
        label.text = @"Policy Number";
        textField.text = [hospitalDetail valueForKey:@"MemberPolicyNumber"];
        textField.enabled = NO;
    }
    else if(indexPath.row == 3 && [hospitalDetail valueForKey:@"claimType"])
    {
        label.text = @"Select Claim Type";
        textField.text = [hospitalDetail valueForKey:@"claimType"];
    }
    else if(indexPath.row == 4 && [hospitalDetail valueForKey:@"MemberRelationship"])
    {
        label.text = @"Relationship";
        textField.text = [hospitalDetail valueForKey:@"MemberRelationship"];
        textField.enabled = NO;
    }
    

    
    textField.tag = indexPath.row;//[[NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row]integerValue];
    textField.delegate = self;
    label.textColor = [UIColor blackColor];
    label.font = [[Configuration shareConfiguration] hitpaFontWithSize:12.0];
    [viewMain addSubview:label];
    textField.textColor = [UIColor blackColor];
    textField.font = [[Configuration shareConfiguration] hitpaFontWithSize:12.0];
    [viewMain addSubview:textField];
    if ([textField.placeholder isEqualToString:@"Phone Number"])
    {
//        [textField setKeyboardType:[[KeyboardHelper sharedKeyboardHelper]keyValues:numberPadKeyboard]];
        textField.keyboardType = UIKeyboardTypeNumberPad;

    }
    else if ([textField.placeholder isEqualToString:@"Email Address"])
    {
//        [textField setKeyboardType:[[KeyboardHelper sharedKeyboardHelper]keyValues:emailKeyboard]];
        textField.keyboardType = UIKeyboardTypeEmailAddress;

    }
    
    
    if (indexPath.row == 0 || indexPath.row == 3)
    {
        if (indexPath.row == 3) {
             label.text = @"Select Claim Type";
        }
        
       
        
        xPos = textField.frame.origin.x + textField.frame.size.width + 5.0;
        yPos = textField.frame.origin.y - 5.0;
        width = 25.0;
        height = 30.0;
        //claim dropdown imageview
        UIImageView *patientDropdown = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        patientDropdown.image = [UIImage imageNamed:@"icon_dropdown.png"];
        //        patientDropdown.backgroundColor = [UIColor blueColor];
        [viewMain addSubview:patientDropdown];

        
        CGFloat xPos = textField.frame.origin.x;
        CGFloat yPos = textField.frame.origin.y;
        CGFloat width = viewMain.frame.size.width;
        CGFloat height = textField.frame.size.height;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [button addTarget:self action:(indexPath.row == 0)?@selector(patientBtnTapped:):@selector(claimTypeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor clearColor];
//        button.backgroundColor = [UIColor redColor];
        [viewMain addSubview:button];
    }
    else if (indexPath.row == 5)
    {
//        xPos = 2.0;
//        yPos = 6.0;
        width = 25.0;//viewMain.frame.size.width - 2 * xPos;
        height = 30.0;
        
        UILabel *phoneLbl = [self createLabelWithFrame:CGRectMake(xPos, label.frame.size.height + yPos, width, height) text:@"+91"];
        phoneLbl.font = [[Configuration shareConfiguration] hitpaFontWithSize:12.0];

        [viewMain addSubview:phoneLbl];
        
        xPos = phoneLbl.frame.origin.x + phoneLbl.frame.size.width;
//        yPos  = 8.0;
//        height = 30.0;
        width = (viewMain.frame.size.width - 2 * xPos) - 20.0;
        textField.frame = CGRectMake(xPos, label.frame.size.height + yPos, width, height);
    }
    
}

- (void)createHospitalizationDetailsWithIndexPath:(NSIndexPath *)indexPath hospitalDetail:hospitalDetail
{
    NSAttributedString *attributedPlaceholder;
    
    switch (indexPath.row) {
        case 0:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Diagnosis" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0]}];
            break;
        case 1:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Date of Admission" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 2:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Expected Date of Discharge" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        case 3:
            attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Approximate Claim Amount" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            break;
        default:
            break;
    }
    
    CGRect frame = [self bounds];
    CGFloat xPos = 3.0;
    CGFloat yPos = 15.0;
    CGFloat height = 40.0;
    CGFloat width = (indexPath.row == 2 || indexPath.row == 1)?frame.size.width - 2 * xPos - 45.0:frame.size.width - 2 * xPos;
    
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor] tag:indexPath.row];
    [self.contentView addSubview:viewMain];
    
    
    xPos = 5.0;
    yPos = 5.0;
    width = viewMain.frame.size.width - 2 * xPos;
    height = 30.0;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    if (indexPath.row == 0)
    {
        textField.text = [hospitalDetail valueForKey:@"diagnosis"];
        
    }else if (indexPath.row == 1)
    {
        textField.text = [hospitalDetail valueForKey:@"admissionDate"];
        
    }else if (indexPath.row == 2)
    {
        textField.text = [hospitalDetail valueForKey:@"dischargeDate"];
        
    }else if (indexPath.row == 3)
    {
        textField.text = [hospitalDetail valueForKey:@"claimAmount"];
        
    }
    textField.tag = [NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row].integerValue;
    textField.delegate = self;
    textField.attributedPlaceholder = attributedPlaceholder;
    textField.textColor = [UIColor blackColor];
    textField.font = [[Configuration shareConfiguration] hitpaFontWithSize:12.0];
    if ([textField.placeholder isEqualToString:@"Approximate Claim Amount"])
    {
//        [textField setKeyboardType:[[KeyboardHelper sharedKeyboardHelper]keyValues:numberPadKeyboard]];
        textField.keyboardType = UIKeyboardTypeNumberPad;

    }
    [viewMain addSubview:textField];
    
    if(indexPath.row == 2 || indexPath.row == 1)
    {
        textField.userInteractionEnabled = NO;
        
        xPos = viewMain.frame.origin.x + viewMain.frame.size.width + 5.0;
        yPos = 20.0;
        width = 30.0;
        height = 30.0;
        UIImageView *datePickImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        datePickImage.image = [UIImage imageNamed:@"icon_date.png"];
        [self.contentView addSubview:datePickImage];
        
        xPos = 0.0;
        yPos = 0.0;
        width = viewMain.frame.size.width + 80.0;
        height = 50.0;
        UIButton *datePickerButton = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [datePickerButton setBackgroundColor:[UIColor clearColor]];
        datePickerButton.tag = [[NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row]integerValue];
        [datePickerButton addTarget:self action:@selector(datePickerBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:datePickerButton];
    }
    
}


- (void)createClaimHistoryDetailsWithIndexPath:(NSIndexPath *)indexPath response:(NSMutableDictionary *)response
{
    NSArray *junction = (NSArray *)response;
    if(junction.count > 0) {

    ClaimsJunction *claimJunction = (ClaimsJunction *)[junction objectAtIndex:indexPath.section];
    
    CGRect frame = [self bounds];
    
    NSString *productName = [[HITPAUserDefaults shareUserDefaluts] valueForKey:@"productname"];
    
    NSString *strDischargeDate = claimJunction.dateOfDischarge;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *dischargeDate = [dateFormatter dateFromString:strDischargeDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateDischargeString = [dateFormatter stringFromDate:dischargeDate];
    
    NSString *strAdmissionDate = claimJunction.dateOfAdmission;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *admissionDate = [dateFormatter dateFromString:strAdmissionDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateAdmissionString = [dateFormatter stringFromDate:admissionDate];

    NSArray *timedateArray = [claimJunction.dateTime componentsSeparatedByString:@" "];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *intiDate = [dateFormatter dateFromString:[timedateArray objectAtIndex:0]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *dateIntiString = [dateFormatter stringFromDate:intiDate];
    NSString *paidDateIntiString;
    if ([claimJunction.paidDate isKindOfClass:[NSNull class]])
    {
        paidDateIntiString = @"NA";
    }else
    {
        /*
        NSArray *paidDate = [claimJunction.paidDate componentsSeparatedByString:@" "];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *paidDateIntiDate = [dateFormatter dateFromString:[paidDate objectAtIndex:0]];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        paidDateIntiString = [dateFormatter stringFromDate:paidDateIntiDate];
         */
        paidDateIntiString = claimJunction.paidDate;
    }
   
    
    NSArray *tableDetails, *tableValues;
    
    if([claimJunction.claimStatus isEqualToString:@"Claim Settled"] || [claimJunction.claimStatus isEqualToString:@"Settled"]) {
        
        tableDetails = [[NSArray alloc]initWithObjects:@"Claim Number :",@"UHID :",@"Date of Loss :",@"Product :",@"Hospital Name :",
                        @"Insured Name :",@"Cash Less",@"Claim Status :",@"Date of Intimation :",@"Payment Details :",@"PaymentAmount :", @"UTR No :",@"Bank Name :",@"Branch :",@"TDS Deducted",nil];
        
        tableValues = [[NSArray alloc]initWithObjects:(([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber),(([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID),((dateAdmissionString == nil)?@"NA":dateAdmissionString),productName,(([claimJunction.hospitalName isKindOfClass:[NSNull class]])?@"NA":claimJunction.hospitalName),(([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName),((claimJunction.claimSubType.length > 0) ? claimJunction.claimSubType : @"NA"),claimJunction.claimStatus,((dateIntiString == nil)?@"NA":dateIntiString),@"",(claimJunction.paymentAmount.length >0) ? claimJunction.paymentAmount : @"NA",(([claimJunction.UTRNo isKindOfClass:[NSNull class]])?@"NA":claimJunction.UTRNo),(([claimJunction.bankName isKindOfClass:[NSNull class]])?@"NA":claimJunction.bankName),(([claimJunction.branch isKindOfClass:[NSNull class]])?@"NA":claimJunction.branch),(claimJunction.TDSDeducted.length >0) ? claimJunction.TDSDeducted : @"NA",nil];
        
        
//        tableDetails = [[NSArray alloc]initWithObjects:@"Claim Number :", @"UHID :",@"Policy Number :",@"Product :",@"Hospital Name :",@"DOA :", @"DOD :", @"Date of Intimation :", @"Diagnosis :", @"Insured Name :", @"Relationship :", @"Claim Type :", @"Claim Status :", @"PaymentAmount :",@"Payment Details :", @"Paid Amount :", @"Paid Date :", @"Bank Name :", @"Account Number :", @"UTR No :", nil];
//
//        tableValues = [[NSArray alloc]initWithObjects:([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber,([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID,claimJunction.policyNumber,productName,([claimJunction.hospitalName isKindOfClass:[NSNull class]])?@"NA":claimJunction.hospitalName,(dateAdmissionString == nil)?@"NA":dateAdmissionString,(dateDischargeString == nil)?@"NA":dateDischargeString,(dateIntiString == nil)?@"NA":dateIntiString,( [claimJunction.diagnosis isKindOfClass:[NSNull class]])?@"NA": claimJunction.diagnosis,([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName,claimJunction.relationship,([claimJunction.claimType isEqualToString:@"Claim Intimation"]) ? [claimJunction.claimType stringByAppendingString:[NSString stringWithFormat:@" - %@",claimJunction.claimSubType]]:claimJunction.claimType ,claimJunction.claimStatus,([claimJunction.claimStatus isEqualToString:@"Settled"])?([claimJunction.consumed isEqualToString:@""] ? @"NA" : claimJunction.consumed):([claimJunction.estimatedExpense isEqualToString:@""]) ? @"NA" : claimJunction.estimatedExpense,@"",([claimJunction.paidAmount isKindOfClass:[NSNull class]])?@"NA":claimJunction.paidAmount, (paidDateIntiString == nil)?@"NA":paidDateIntiString, ([claimJunction.bankName isKindOfClass:[NSNull class]])?@"NA":claimJunction.bankName, ([claimJunction.accountNumber isKindOfClass:[NSNull class]])?@"NA":claimJunction.accountNumber,([claimJunction.UTRNo isKindOfClass:[NSNull class]])?@"NA":claimJunction.UTRNo,nil];

//        tableDetails = [[NSArray alloc]initWithObjects:@"Claim Ref Number :", @"UHID :", @"Patient Name :", @"Claim Status :", @"Payment Details :", @"Paid Amount :", @"Paid Date :", @"Bank Name :", @"Account Number :", @"UTR No :", nil];
//
//        tableValues = [[NSArray alloc]initWithObjects:([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber,([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID, ([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName, claimJunction.claimStatus, @"",([claimJunction.paidAmount isKindOfClass:[NSNull class]])?@"NA":claimJunction.paidAmount, (paidDateIntiString == nil)?@"NA":paidDateIntiString, ([claimJunction.bankName isKindOfClass:[NSNull class]])?@"NA":claimJunction.bankName, ([claimJunction.accountNumber isKindOfClass:[NSNull class]])?@"NA":claimJunction.accountNumber, ([claimJunction.UTRNo isKindOfClass:[NSNull class]])?@"NA":claimJunction.UTRNo, nil];
        
    }
    else {
        
//       tableDetails = [[NSArray alloc]initWithObjects:@"Claim Number :", @"UHID :",@"Policy Number :",@"Product :",@"Hospital Name :",@"DOA :", @"DOD :", @"Date of Intimation :", @"Diagnosis :", @"Insured Name :", @"Relationship :", @"Claim Type :", @"Claim Status :", @"PaymentAmount :",nil];
        
//        tableValues = [[NSArray alloc]initWithObjects:([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber,([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID,claimJunction.policyNumber,productName,([claimJunction.hospitalName isKindOfClass:[NSNull class]])?@"NA":claimJunction.hospitalName,(dateAdmissionString == nil)?@"NA":dateAdmissionString,(dateDischargeString == nil)?@"NA":dateDischargeString,(dateIntiString == nil)?@"NA":dateIntiString,( [claimJunction.diagnosis isKindOfClass:[NSNull class]])?@"NA": claimJunction.diagnosis,([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName,claimJunction.relationship,([claimJunction.claimType isEqualToString:@"Claim Intimation"]) ? [claimJunction.claimType stringByAppendingString:[NSString stringWithFormat:@" - %@",claimJunction.claimSubType]]:claimJunction.claimType,claimJunction.claimStatus,([claimJunction.claimStatus isEqualToString:@"Closed"] )?claimJunction.consumed:@"NA",nil];
        
        tableDetails = [[NSArray alloc]initWithObjects:@"Claim Number :",@"UHID :",@"Date of Loss :",@"Product :",@"Hospital Name :",
                        @"Insured Name :",@"Cash Less",@"Claim Status :",@"Date of Intimation :",nil];
        
        tableValues = [[NSArray alloc]initWithObjects:(([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber),(([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID),((dateAdmissionString == nil)?@"NA":dateAdmissionString),productName,(([claimJunction.hospitalName isKindOfClass:[NSNull class]])?@"NA":claimJunction.hospitalName),(([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName),((claimJunction.claimSubType.length > 0) ? claimJunction.claimSubType : @"NA"),claimJunction.claimStatus,((dateIntiString == nil)?@"NA":dateIntiString),nil];
        
        
//        tableDetails = [[NSArray alloc]initWithObjects:@"Claim Ref Number :", @"UHID :", @"Patient Name :", @"Claim Status :", nil];
//
//        tableValues = [[NSArray alloc]initWithObjects:([claimJunction.claimNumber isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimNumber,([claimJunction.claimsUHID isKindOfClass:[NSNull class]])?@"NA": claimJunction.claimsUHID,([claimJunction.patientName isKindOfClass:[NSNull class]])?@"NA":claimJunction.patientName,claimJunction.claimStatus,nil];

    }

    
    CGFloat xPos = 1.0;
    CGFloat yPos = 0.0;
    CGFloat height = 30.0;
    CGFloat width = frame.size.width - 2.0;
    
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor] tag:indexPath.row];
    [self.contentView addSubview:viewMain];

//    xPos = 1.0;
//    yPos = 0.0;
//    height = 10.0;
//    width = frame.size.width - 2.0;
//    UIView *lineView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:43.0/255.0 green:63.0/255.0 blue:98.0/255.0 alpha:1.0] tag:0];
//    [self.contentView addSubview:lineView];
        /*
        if(indexPath.row == tableDetails.count) {
            width = 100.0;
            height = 40.0;
            xPos = (viewMain.frame.size.width - width) / 2.0;
            yPos = 5.0;
            
            UIButton *feedback = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            if ([self.claimsResponse.claimsFeedbackStatus isEqualToString:@"True"]) {
                [feedback setTitle:@"Feedback Already Submitted" forState:UIControlStateNormal];
                [feedback setUserInteractionEnabled:YES];
            }else {
                [feedback setTitle:@"Feedback" forState:UIControlStateNormal];
            }
            
            [feedback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            feedback.layer.cornerRadius = 4.0;
            feedback.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
            feedback.layer.borderWidth = 1.0;
            feedback.layer.masksToBounds = YES;
            feedback.tag = indexPath.section;
            feedback.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
            [feedback setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            [feedback addTarget:self action:@selector(feedbackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//            feedback.hidden = YES;  //Hide Feedback button
//            [viewMain addSubview:feedback];
            
        }
        else {
       */
            if (indexPath.row == 9) {
                xPos   = 1.0;
                yPos   = 0.0;
                width  = viewMain.frame.size.width * 0.4;
                height = viewMain.frame.size.height;
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
                titleLabel.text = tableDetails[indexPath.row];
                NSLog(@"Details :%@", tableDetails);
                NSLog(@"Title: %@", titleLabel.text);
                titleLabel.textColor = [UIColor colorWithRed:45.0f/255.0f green:60.0f/255.0f blue:145.0f/255.0f alpha:1.0];
                //    tableLabels.backgroundColor = [UIColor redColor];
                titleLabel.textAlignment = NSTextAlignmentRight;
                titleLabel.numberOfLines = 2;
                titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
                //    [tableLabels sizeToFit];
                [viewMain addSubview:titleLabel];
                
                //Title Label Underline
                UILabel *titleUnderlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos+15, titleLabel.frame.origin.y+titleLabel.frame.size.height, viewMain.frame.size.width, 1)];
                NSLog(@"titleUnderlineLabel:%@", titleUnderlineLabel);
                titleUnderlineLabel.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:60.0f/255.0f blue:145.0f/255.0f alpha:1.0];
                [viewMain addSubview:titleUnderlineLabel];
            }
            else {
                xPos   = 1.0;
                yPos   = 0.0;
                width  = viewMain.frame.size.width * 0.4;
                height = viewMain.frame.size.height;
                UILabel *tableLabels = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
                tableLabels.text = tableDetails[indexPath.row];
                tableLabels.textColor = [UIColor darkGrayColor];
                //    tableLabels.backgroundColor = [UIColor redColor];
                tableLabels.textAlignment = NSTextAlignmentRight;
                tableLabels.numberOfLines = 2;
                tableLabels.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
                //    [tableLabels sizeToFit];
                [viewMain addSubview:tableLabels];
                
                xPos = tableLabels.frame.origin.x + tableLabels.frame.size.width + 3.0;
                width  = viewMain.frame.size.width * 0.6;
                
                UILabel *claimHistory = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
                claimHistory.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:12.0];
                NSLog(@"Values :%@", tableValues);
                /*  // Bank Name & Account Number values are Empty String, If responce is NA
                if ([tableValues[indexPath.row] isEqualToString:@"NA"]) {
                     claimHistory.text = @"";
                } else {
                    claimHistory.text = tableValues[indexPath.row];
                }
                */
                claimHistory.text = tableValues[indexPath.row];
                
                claimHistory.textAlignment = NSTextAlignmentLeft;
                claimHistory.numberOfLines = 2;
                //    claimHistory.backgroundColor = [UIColor greenColor];
                //    [claimHistory sizeToFit];
                [viewMain addSubview:claimHistory];
            }
//        }

    }
    
}


- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor tag:(NSInteger)tag
{
    UIView *view ;
    if (selectedSegment == 0)
    {
        view = [[UIView alloc]initWithFrame:frame];
        view.tag = tag;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.masksToBounds = YES;
        return view;
    }
    else
    {
        view = [[UIView alloc]initWithFrame:frame];
    }
    return view;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button.titleLabel setFont:[[Configuration shareConfiguration]hitpaFontWithSize:16.0]];
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.5;
    button.layer.shadowRadius = 2;
    button.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    return button;
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}



#pragma mark - TextField Delegate

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.keyboardType == numberPadKeyboard)
//    {
////        textField.inputAccessoryView = [[KeyboardHelper sharedKeyboardHelper]tollbar:self.superview];
//    }
//    
//}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(populateDictWithFieldText:tag:)])
    {
        [self.delegate populateDictWithFieldText:textField.text tag:textField.tag];
    }
    
    
    [self searchTextWithTag:textField.tag text:textField.text];
    
}

- (void)searchTextWithTag:(NSInteger)tag text:(NSString *)text
{
    switch (tag) {
        case kSearchHospitalNameTag:
            [search setValue:text forKey:@"searchtext"];
            [search setValue:[NSString stringWithFormat:@"%d",1] forKey:@"type"];
            break;
        case kSearchPincodeTag:
            [search setValue:text forKey:@"searchtext"];
            [search setValue:[NSString stringWithFormat:@"%d",2] forKey:@"type"];
            break;
        case kSearchCityNameTag:
            [search setValue:text forKey:@"searchtext"];
            [search setValue:[NSString stringWithFormat:@"%d",3] forKey:@"type"];
            break;
        default:
            break;
    }
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 20) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *alphabets = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789()-?'/''";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:alphabets] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return ([string isEqualToString:filtered]);
    }
    
    if (textField.tag == 11) {
        
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int length = [currentString length];
        if (length > 10) {
            return NO;
        }
        return YES;
    }else if (textField.tag == 23)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        int length = [currentString length];

        if (length == 1) {
            
            char str = [currentString characterAtIndex:0];


            if (str == '0')
            {
                NSLog(@"zero");
                return NO;
            }
            else
            {
                NSLog(@"not zero");
                
                return YES;
            }
            
        }else if(length > 11){
            return NO;
        }
        
        else
        {
            return YES;
        }
        
    }
    else if (textField.tag == kSearchHospitalNameTag) {
        if([string isEqualToString:@""] && textField.text.length == 1) {
            
            UITableView *tableView = (UITableView *)self.superview.superview;
            [self.dropDownViews removeFromSuperview];
            self.nIDropDown = nil;
        }
        return YES;

    }
    else
    {
        return YES;
    }
   
}
- (void)memberWithDetails:(NSDictionary *)details
{
    
    if([self.subviews[0].subviews[0].subviews[1] isKindOfClass:[UITextField class]]){
        UITextField *textField = self.subviews[0].subviews[0].subviews[1];
         [(UITextField *)textField setText:[details valueForKey:@"MemberName"]];
    }
   
    
    if ([self.delegate respondsToSelector:@selector(memberWithDetails:)])
    {
        [self.delegate memberWithDetails:details];
    }
    
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    
    
}

- (void)claimType:(NSString *)claimType{
    
    [(UITextField *)[self viewWithTag:3] setText:claimType];
    
    if ([self.delegate respondsToSelector:@selector(claimType:)])
    {
        [self.delegate claimType:claimType];
    }
    
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    
    
}


#pragma mark - Button Delegate

- (void)feedbackButtonTapped:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(feedbackWithIndex:feedbackStatus:)])
    {
        [self.delegate feedbackWithIndex:sender.tag feedbackStatus:self.claimsResponse.claimsFeedbackStatus];
    }

}

- (IBAction)patientBtnTapped:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        
        view = [view superview];
    }
    
    
    UITableView *superView = (UITableView *)view;
    CGPoint center = button.center;
    CGPoint point = [button.superview convertPoint:center toView:superView.superview];
    
    
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        
        MyPolicyModel *myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:[[CoreData shareData] getPolicyDetail]];
        NSMutableArray *memeberDetails = [NSMutableArray arrayWithArray:myPolicyDetails.memberDetails];
        
        NSString *strDate = myPolicyDetails.policyFrom;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];

        
        NSDictionary *personalDetails = [NSDictionary dictionaryWithObjectsAndKeys:myPolicyDetails.memberAge,@"MemberAge",myPolicyDetails.policyGender, @"MemberGender",myPolicyDetails.memberName,@"MemberName",myPolicyDetails.policyNumber,@"MemberPolicyNumber",@"Self",@"MemberRelationship",myPolicyDetails.memberID,@"UHID",dateString,@"ValidTill", nil];
        
        //[memeberDetails addObject:personalDetails];
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if ([memeberDetails count] <= 0)
            return;
        if (self.nIDropDown == nil)
        {
            
            self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,point.y + 16.0,frame.size.width, 200.0)];
            //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
            self.dropDownViews.tag = 40000;
            UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
            CGRect btnFrame=locationBtn.frame;
            btnFrame.origin.y=0.0;
            btnFrame.origin.x = 0.0;
            btnFrame.size.height=0.0;
            locationBtn.frame=btnFrame;
            locationBtn.backgroundColor=[UIColor clearColor];
            
            CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
            self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:memeberDetails imgArr:nil direction:@"down" isIndex:50000];
            self.nIDropDown.delegate = self;
            [self.dropDownViews addSubview:self.nIDropDown];
            
            UITableView *tableView = (UITableView *)self.superview.superview;
            [tableView addSubview:self.dropDownViews];
            
        }else
        {
            [self.dropDownViews removeFromSuperview];
            self.nIDropDown = nil;
            
        }
        
        
    }
    
}


- (IBAction)claimTypeBtnTapped:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        
        view = [view superview];
    }
    
    
    UITableView *superView = (UITableView *)view;
    CGPoint center = button.center;
    CGPoint point = [button.superview convertPoint:center toView:superView.superview];
    
    CGRect frame = [[UIScreen mainScreen] bounds];

    if (self.nIDropDown == nil)
    {
        
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,point.y + 16.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:[NSArray arrayWithObjects:@"Pre-Auth", @"Reimbursement", nil] imgArr:nil direction:@"down" isIndex:70000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        
        UITableView *tableView = (UITableView *)self.superview.superview;
        [tableView addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
    
}


- (IBAction)searchAgianButtonTapped:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(searchAgain)])
    {
        [self.delegate searchAgain];
    }
    
}

- (IBAction)nearMeBtnTapped:(UIButton *)sender
{
    
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            
        }];
        
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(nearMeHospital)])
    {
        [self.delegate nearMeHospital];
    }
    
    
}


- (IBAction)patientNameButtonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(showDropDown)])
    {
        [self.delegate showDropDown];
    }
}

- (IBAction)datePickerBtnTapped:(UIButton *)sender
{
    
    UITableView * tableView = (UITableView *)self.superview.superview;
    [tableView endEditing:YES];
    CGPoint center = sender.center;
    CGPoint point = [sender.superview convertPoint:center toView:tableView];
    //NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    if (sender.tag == 22) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(createDatePickerView:indexPath:)])
    {
        
        [self.delegate createDatePickerView:sender indexPath:indexPath];
    }
    
    
    
}

- (UITableView *)getTableView
{
    //Remove drop view from super view
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        
        view = [view superview];
    }
    
    
    UITableView *superView = (UITableView *)view;
    
    return superView;
    
}

- (IBAction)searchButtonTapped:(UIButton *)sender
{
    [[self getTableView] endEditing:YES];
    
    NSArray *error = nil;
    BOOL isValidate = [[Helper shareHelper] validateClaimSearchAllEntriesWithError:&error params:[search valueForKey:@"searchtext"]];
    if (!isValidate)
    {
        

        NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
        alertView(@"ErrorMessage", errorMessage, nil, @"Ok", nil, 0);
        return;
        
    }
    
    [self searchHospitalWithText:search];
    
}

- (void)searchHospitalWithText:(NSDictionary *)search
{
    [self showHUDWithMessage:@""];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setValue:[search valueForKey:@"searchtext"] forKey:@"text"];
    [params setValue:[search valueForKey:@"type"] forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)1] forKey:@"page"];
    
    [[HITPAAPI shareAPI] getClaimSearchHospitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
        
        [self didReceiveNearMeHospitalsWithResponse:response error:error];
        
    }];
    
}


- (void)didReceiveNearMeHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];

    
    NSMutableArray * hospitals = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in response) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
            [hospitals addObject:home];
            
        }
        
    }
    if ( hospitals.count <= 0 ) {
        alertView([[Configuration shareConfiguration] appName], kNoHospitalFound, nil, @"Ok", nil, 0);
        return;

    }
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ([hospitals count] <= 0)
        return;
    if (self.nIDropDown == nil)
    {
        
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,90.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:hospitals imgArr:nil direction:@"down" isIndex:20000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        
        UITableView *tableView = (UITableView *)self.superview.superview;
        [tableView addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
    
    
}


- (void)searchhospitaWithDetail:(HospitalModel *)hospitalDetail
{
    if ([self.delegate respondsToSelector:@selector(hospitaWithDetail:)])
    {
        [self.delegate hospitaWithDetail:hospitalDetail];
    }
    
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - HUD

- (void)showHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.superview];
    [self.superview.superview addSubview:self.progressHUD];
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    [self.progressHUD show:YES];
    
}

- (void)hideHUD
{
    [self.progressHUD hide:YES];
}

@end
