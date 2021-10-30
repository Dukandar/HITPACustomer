//
//  RegistrationViewController.m
//  HITPA
//
//  Created by Kranthi B. on 11/30/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Configuration.h"
#import "Constants.h"
#import "Gradients.h"
//#import "KeyboardHelper.h"
#import "Helper.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "HITPAAPI.h"
#import "UserManager.h"
#import "ChangePasswordController.h"

//NSInteger const kTypeTextFieldTag  = 12345;
//NSInteger const kRegistrationType = 10001;
NSInteger const kEmployviewTag                      = 10002;
NSInteger const kEmployIdImageTag                   = 10003;
NSString *const kRetail                             = @"Retail";
NSInteger const kOrLabelTag                         = 10006;
NSInteger const kUhidViewTag                        = 10010;
NSInteger const KUhidImageTag                       = 10011;
NSInteger const kMobilNoViewTag                     = 10014;
NSInteger const kMobileNoImageTag                   = 10015;
NSInteger const kMobilePasswordTag                  = 10018;
NSInteger const kEmailIdViewTag                     = 10022;
NSInteger const kEmailIdImageTag                    = 10023;
NSInteger const kEmailPasswordTag                   = 10026;
NSInteger const kBelowViewTag                       = 100040;
NSInteger const kBottomViewTag                      = 100050;
NSInteger const kRegistartionSuccessTag             = 111;
NSString    *   const kRegistrationDevice           =  @"IOS";
NSString    *   const kRegistrationSuccessMsg       =  @"Registration successful";

typedef enum {
    
    EmailPhoneNo = 1000,
    Password
    
}Fieldtype;

@interface RegistrationViewController ()<UITextFieldDelegate,NIDropDownDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) UIView                *dropDownViews;
@property (nonatomic, strong) NIDropDown            *nIDropDown;
@property (strong,nonatomic) NSMutableDictionary    *typeDetails;
@property (strong ,nonatomic) NSArray               *typeArray;
@property(strong,nonatomic) UITextField             *typeTextFld,*policyNotextFld, *employIdTextFld ,*uhidTextFld,*mobileNotextFld ,*emailIdTextFld;
@property (strong ,nonatomic) UILabel               *emailIdLabel;
@property (nonatomic, strong) MBProgressHUD         *progressHUD;
@property(strong,nonatomic) UIButton                *registerBtn,*cancelBtn;
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.typeArray = [[NSArray alloc]initWithObjects:@"Retail",@"Corporate", nil];
    self.navigationController.navigationBar.hidden = YES;
    [self createRegistrationView];
}

- (void)createRegistrationView {
    CGRect  frame = [self bounds];
    CGFloat xPos,yPos,width,height;
    
    xPos   = 0.0;
    yPos   = 0.0;
    width  = frame.size.width;
    height = frame.size.height;
    UIImageView *backgroundImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    backgroundImage.image = [UIImage imageNamed:loginbackgroundImage];
    [self.view addSubview:backgroundImage];
    //topview
    
    xPos   = 0.0;
    yPos   = 0.0;
    width  = frame.size.width;
    height = (frame.size.width/4);
    UIView *topView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    //Topview Image
    yPos   = 20.0;
    height = topView.frame.size.height - 10.0;
    UIImageView *banner =[self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    banner.image = [UIImage imageNamed:logintopviewImage];
    [topView addSubview:banner];

        //top color view
    yPos   = topView.frame.size.height + topView.frame.origin.y + 40.0;
    height = roundf(topView.frame.size.height/3.7);
    UIView *colorView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    // colorView.backgroundColor = [UIColor colorWithRed:1.0/255 green:60.0/255 blue:122.0/255 alpha:1.0];
    colorView.layer.cornerRadius  = 4.0;
    colorView.layer.masksToBounds = YES;
    CAGradientLayer *gradient = [[Gradients shareGradients]login];
    gradient.frame = colorView.bounds;
    [colorView.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:colorView];
    
    xPos   = 32.0 ;
    yPos   = colorView.frame.origin.y + colorView.frame.size.height + 10.0;
    width  =  frame.size.width - 32.0;
    height = colorView.frame.size.height ;
    UILabel * registrationLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    registrationLabel.text = @"Register Now!";
    registrationLabel.textColor = [UIColor whiteColor];
    registrationLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:20.0];
    registrationLabel.layer.shadowOpacity = 0.4;
    registrationLabel.layer.shadowRadius = 0.4;
    registrationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    registrationLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [self.view addSubview:registrationLabel];
    
   //scrooll view
    
    yPos = registrationLabel.frame.origin.y+registrationLabel.frame.size.height+10;
    xPos=0.0;
    width = frame.size.width;
    height = frame.size.height;
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    scrollView.delegate = self;
    //scrollView.showsVerticalScrollIndicator=YES;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    //scrollView.backgroundColor = [UIColor orangeColor];
    //[self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(width,760.0);
    [self.view addSubview:scrollView];
    
    
    //below view
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = frame.size.height/4 + 20;
    
    UIView *belowView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    belowView.tag = kBelowViewTag;
//    belowView.backgroundColor = [UIColor blueColor];
    //topView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:belowView];
    
    
    //type view
    xPos    =  10.0;
    yPos    = belowView.frame.origin.y;
    width   =  frame.size.width - 22.0;
    height = roundf(topView.frame.size.height/2.5) + 8.0;
    UIView * typeView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    typeView.layer.cornerRadius = 8.0;
    typeView.layer.masksToBounds = YES;
    typeView.backgroundColor = [UIColor lightGrayColor];
    typeView.layer.borderWidth = 5.0;
    typeView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [belowView addSubview:typeView];
    
    // type image
    xPos    = typeView.frame.origin.x + 4.0 ;
    yPos    = typeView.frame.origin.y +5.0 ;
    width   = typeView.frame.size.width /2.5;
    height  = typeView.frame.size.height -10.0 ;
    UIImageView * typeImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    typeImage.image = [UIImage imageNamed:loginIcon];
    [belowView addSubview:typeImage];
    
    // type text field
    xPos    = typeImage.frame.size.width + 20.0;
    yPos    = 8.0;
    width   = typeView.frame.size.width  - xPos  + 2.0;
    height  =  25.0;
    self.typeTextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.typeTextFld.layer.cornerRadius = 8.0;
    self.typeTextFld.layer.masksToBounds = YES;
    self.typeTextFld.text = ([[[UserManager sharedUserManager]policyType] isKindOfClass:[NSNull class]]) ? @"NA" :[[UserManager sharedUserManager]policyType];
    self.typeTextFld.enabled = NO;
    NSAttributedString *typePlaceholder = [[NSAttributedString alloc]initWithString:@"Type" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    
    self.typeTextFld.attributedPlaceholder = typePlaceholder;
    self.typeTextFld.backgroundColor = [UIColor clearColor];
    self.typeTextFld.textColor = [UIColor darkGrayColor];
    self.typeTextFld.delegate = self;
    [typeView addSubview:self.typeTextFld];
    
    xPos = self.typeTextFld.frame.origin.x+self.typeTextFld.frame.size.width-25;
    width = 25.0;
    height = roundf(topView.frame.size.height/2.5);
    yPos = typeView.frame.origin.y+5.0;
    //dropdown imageview
    UIImageView *typeDropdown = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    typeDropdown.image = [UIImage imageNamed:@"icon_dropdown.png"];
    //typeDropdown.backgroundColor = [UIColor orangeColor];
    //[belowView addSubview:typeDropdown];
    
    //dropdown button
    xPos = typeImage.frame.size.width + 20.0;
    width =typeView.frame.size.width  - xPos  + 2.0;
    height = 25.0;
    yPos = typeView.frame.origin.y+8.0;
    UIButton *typeBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [typeBtn addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //typeBtn.backgroundColor = [UIColor orangeColor];
    //[belowView addSubview:typeBtn];
    

    xPos   = 10.0;
    yPos   = typeView.frame.origin.y + typeView.frame.size.height + 10;
    width  = 10;
    height = 10;
    UIImageView *policyMandatoryImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    policyMandatoryImage.image = [UIImage imageNamed:@"icon_mandatory.png"];
    
    if ([[[UserManager sharedUserManager]policyType] isEqualToString:@"Retail"]) {
        NSLog(@"No EMP ID Mandatory Image");
    } else {
        [belowView addSubview:policyMandatoryImage];
    }
    
    //policy number view
    xPos    =  10.0;
    yPos    = policyMandatoryImage.frame.origin.y + policyMandatoryImage.frame.size.height;
    width   =  frame.size.width - 22.0;
    height = roundf(topView.frame.size.height/2.5) + 8.0;
    UIView * policyNoView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    policyNoView.layer.cornerRadius = 8.0;
    policyNoView.layer.masksToBounds = YES;
    policyNoView.backgroundColor = [UIColor whiteColor];
//    policyNoView.backgroundColor = [UIColor redColor];
    policyNoView.layer.borderWidth = 5.0;
    policyNoView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [belowView addSubview:policyNoView];
    
    // policy number image
    xPos    = 5.0;
    yPos    = 5.0;
    width   = policyNoView.frame.size.width /2.5;
    height  = policyNoView.frame.size.height - 10.0 ;
    UIImageView * policyNoImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    policyNoImage.image = [UIImage imageNamed:loginIcon];
    [policyNoView addSubview:policyNoImage];
    
    // policy number text field
    xPos    = policyNoImage.frame.size.width + 20.0;
    yPos    = 8.0;
    width   = policyNoView.frame.size.width  - xPos  + 2.0;
    height  =  25.0;
    self.policyNotextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    NSAttributedString *policyNoPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Policy Number" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    if (IS_IPHONE) {
         self.policyNotextFld.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:11.0]; //iPhone_6 = 15 && iPhone_5 = 11
    }
    
    self.policyNotextFld.attributedPlaceholder = policyNoPlaceholder;
    self.policyNotextFld.layer.cornerRadius = 8.0;
    self.policyNotextFld.layer.masksToBounds = YES;
    self.policyNotextFld.text = @"";
    self.policyNotextFld.backgroundColor = [UIColor whiteColor];
//     self.policyNotextFld.backgroundColor = [UIColor blueColor];
    self.policyNotextFld.delegate = self;
    [policyNoView addSubview:self.policyNotextFld];
    
    
    xPos   = 10.0;
    yPos   = policyNoView.frame.origin.y + policyNoView.frame.size.height + 10;
    width  = 10;
    height = 10;
    UIImageView *empIDMandatoryImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    empIDMandatoryImage.image = [UIImage imageNamed:@"icon_mandatory.png"];
    
    if ([[[UserManager sharedUserManager]policyType] isEqualToString:@"Retail"]) {
        NSLog(@"No EMP ID Mandatory Image");
    } else {
//        [belowView addSubview:empIDMandatoryImage];
    }
    
    //employ id view
    xPos    =  10.0;
    yPos    = empIDMandatoryImage.frame.origin.y + empIDMandatoryImage.frame.size.height;
    width   =  frame.size.width - 22.0;
    height = ([[[UserManager sharedUserManager]policyType] isEqualToString:@"Retail"])?0.0:roundf(topView.frame.size.height/2.5)+8.0;
    UIView * employIdView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    employIdView.tag = kEmployviewTag;
    employIdView.layer.cornerRadius = 8.0;
    employIdView.layer.masksToBounds = YES;
    employIdView.backgroundColor = [UIColor whiteColor];
    employIdView.layer.borderWidth = 5.0;
    employIdView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [belowView addSubview:employIdView];
    
    // employ id image
    xPos    = 5.0;
    yPos    = 5.0;
    width   = employIdView.frame.size.width /2.5;
    height  = ([[[UserManager sharedUserManager]policyType] isEqualToString:@"Retail"])?0.0:employIdView.frame.size.height - 10.0 ;
    UIImageView * employIdImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    employIdImage.tag = kEmployIdImageTag;
    employIdImage.image = [UIImage imageNamed:loginIcon];
    [employIdView addSubview:employIdImage];
    
    // employ id text field
    xPos    = employIdImage.frame.size.width + 20.0;
    yPos    = 8.0;
    width   = employIdView.frame.size.width  - xPos  + 2.0;
    height  =  ([[[UserManager sharedUserManager]policyType] isEqualToString:@"Retail"])?0.0:25.0;
    self.employIdTextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    NSAttributedString *employIdPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Employee ID" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    
    self.employIdTextFld.attributedPlaceholder = employIdPlaceholder;
    self.employIdTextFld.layer.cornerRadius = 8.0;
    self.employIdTextFld.layer.masksToBounds = YES;
    self.employIdTextFld.text = @"";
    self.employIdTextFld.backgroundColor = [UIColor whiteColor];
    self.employIdTextFld.delegate = self;
    [employIdView addSubview:self.employIdTextFld];
    
    belowView.frame = CGRectMake(belowView.frame.origin.x, belowView.frame.origin.y, belowView.frame.size.width, employIdView.frame.size.height + employIdView.frame.origin.y);
    //bottom view
    
    xPos = 0.0;
    yPos = belowView.frame.origin.y + belowView.frame.size.height;
    width = frame.size.width;
    height = frame.size.height/2 + 10;
    UIView * bottomView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    bottomView.tag = kBottomViewTag;
//    bottomView.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:bottomView];
    
    //or label
    xPos = frame.size.width/2 - 10;
    yPos = 5.0;
    width = 40.0;
    height = 30.0;
    UILabel *orLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    orLabel.text = @"OR";
    orLabel.tag = kOrLabelTag;
    orLabel.textColor = [UIColor whiteColor];
    orLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [bottomView addSubview:orLabel];
    
        xPos   = 10.0;
        yPos   = orLabel.frame.origin.y + orLabel.frame.size.height + 10;
        width  = 10;
        height = 10;
        UIImageView *uhidMandatoryImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
        uhidMandatoryImage.image = [UIImage imageNamed:@"icon_mandatory.png"];
//        [bottomView addSubview:uhidMandatoryImage];
    
    //uhid view
    xPos    =  10.0;
    yPos    = uhidMandatoryImage.frame.origin.y + uhidMandatoryImage.frame.size.height;
    width   =  frame.size.width - 22.0;
    height = roundf(topView.frame.size.height/2.5)+8.0;
    UIView * uhidView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    uhidView.tag = kUhidViewTag;
    uhidView.layer.cornerRadius = 8.0;
    uhidView.layer.masksToBounds = YES;
    uhidView.backgroundColor = [UIColor whiteColor];
    uhidView.layer.borderWidth = 5.0;
    uhidView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [bottomView addSubview:uhidView];
    
    // uhid image
    xPos    = 5.0;
    yPos    = 5.0;
    width   = uhidView.frame.size.width / 2.5;
    height  = uhidView.frame.size.height - 10.0 ;
    UIImageView * uhidImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    uhidImage.tag = KUhidImageTag;
    uhidImage.image = [UIImage imageNamed:loginIcon];
    [uhidView addSubview:uhidImage];
    
    // uhid text field
    xPos    = uhidImage.frame.size.width + 20.0;
    yPos    = 8.0;
    width   = uhidView.frame.size.width  - xPos  + 2.0;
    height  =  25.0;
    self.uhidTextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    NSAttributedString *uhIdPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter UHID" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    
    self.uhidTextFld.attributedPlaceholder = uhIdPlaceholder;
    self.uhidTextFld.layer.cornerRadius = 8.0;
    self.uhidTextFld.layer.masksToBounds = YES;
    self.uhidTextFld.text = @"";
    self.uhidTextFld.backgroundColor = [UIColor whiteColor];
    self.uhidTextFld.delegate = self;
    [uhidView addSubview:self.uhidTextFld];
    
    //mobile number view
    xPos    =  10.0;
    yPos    = uhidView.frame.origin.y + uhidView.frame.size.height + 10;
    width   =  frame.size.width - 22.0;
    height =  0.0;//roundf(topView.frame.size.height/2.5)+8.0;
    UIView * mobileNoView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    mobileNoView.tag = kMobilNoViewTag;
    mobileNoView.layer.cornerRadius = 8.0;
    mobileNoView.layer.masksToBounds = YES;
    mobileNoView.backgroundColor = [UIColor lightGrayColor];
    mobileNoView.layer.borderWidth = 5.0;
    mobileNoView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [bottomView addSubview:mobileNoView];
    
    // mobile number image
    xPos    = 5.0;
    yPos    = 5.0;
    width   = uhidView.frame.size.width /2.5;
    height  = uhidView.frame.size.height - 10.0 ;
    UIImageView * mobileNoImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    mobileNoImage.tag = kMobileNoImageTag;
    mobileNoImage.image = [UIImage imageNamed:loginIcon];
    [mobileNoView addSubview:mobileNoImage];
    
    // mobile number text field
    xPos    = mobileNoImage.frame.size.width + 20.0;
    yPos    = 8.0;
    width   = mobileNoView.frame.size.width  - xPos  + 2.0;
    height  =  25.0;
    self.mobileNotextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    NSAttributedString *mobileNoPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Mobile Number" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    
    self.mobileNotextFld.attributedPlaceholder = mobileNoPlaceholder;
    self.mobileNotextFld.layer.cornerRadius = 8.0;
    self.mobileNotextFld.layer.masksToBounds = YES;
    self.mobileNotextFld.enabled = NO;
    self.mobileNotextFld.text = ([[[UserManager sharedUserManager]contactNo] isKindOfClass:[NSNull class]])?@"NA":[[UserManager sharedUserManager]contactNo];
    self.mobileNotextFld.textColor = [UIColor darkGrayColor];
    self.mobileNotextFld.backgroundColor = [UIColor clearColor];
    self.mobileNotextFld.delegate = self;
//    self.mobileNotextFld.keyboardType = NumberPadKeyboard;
    [mobileNoView addSubview:self.mobileNotextFld];
    
    //your mobile password label
    xPos = frame.size.width/2 - 60.0;
    yPos = mobileNoView.frame.origin.y + mobileNoView.frame.size.height + 5;
    height = 0.0;
    width = frame.size.width/2 + 50.0;
    UILabel *mobilePasswrdLbl = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    mobilePasswrdLbl.tag = kMobilePasswordTag;
    mobilePasswrdLbl.text = @"Your Password will be sent to this number";
    mobilePasswrdLbl.textColor = [UIColor whiteColor];
    mobilePasswrdLbl.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:89.0/255.0 blue:163.0/255.0 alpha:1.0];
    mobilePasswrdLbl.layer.cornerRadius = 3.0;
    mobilePasswrdLbl.layer.masksToBounds = YES;
    mobilePasswrdLbl.layer.borderWidth = 0.1;
    mobilePasswrdLbl.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.width>320.0?12.0:9.0];
    mobilePasswrdLbl.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:mobilePasswrdLbl];
    
    //email id view
    xPos    =  10.0;
    yPos    = mobilePasswrdLbl.frame.origin.y + mobilePasswrdLbl.frame.size.height + 10;
    width   =  frame.size.width - 22.0;
    height = 0.0;//roundf(topView.frame.size.height/2.5)+8.0;
    UIView * emailIdView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    emailIdView.tag = kEmailIdViewTag;
    emailIdView.layer.cornerRadius = 8.0;
    emailIdView.layer.masksToBounds = YES;
    emailIdView.backgroundColor = [UIColor lightGrayColor];
    emailIdView.layer.borderWidth = 5.0;
    emailIdView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    emailIdView.userInteractionEnabled = NO;
    [bottomView addSubview:emailIdView];
    
    // email id image
    xPos    = 5.0;
    yPos    = 5.0;
    width   = uhidView.frame.size.width / 2.5;
    height  = uhidView.frame.size.height + 5.0 - 10.0 ;
    UIImageView * emailIdImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailIdImage.tag = kEmailIdImageTag;
    emailIdImage.image = [UIImage imageNamed:loginIcon];
    [emailIdView addSubview:emailIdImage];
    
    // email id text field
    xPos    = emailIdImage.frame.size.width + 20.0;
    yPos    = 3.0;
    width   = emailIdView.frame.size.width  - xPos - 5.0;
    height  =  45.0;
    self.emailIdLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    //self.emailIdLabel.text = @"swetha@inubesolutions.com";
    self.emailIdLabel.text = ([[[UserManager sharedUserManager]emailID] isKindOfClass:[NSNull class]])?@"NA":[[UserManager sharedUserManager]emailID];
    self.emailIdLabel.textColor = [UIColor darkGrayColor];
    self.emailIdLabel.numberOfLines = 0;
    self.emailIdLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
    self.emailIdLabel.backgroundColor = [UIColor clearColor];
    [emailIdView addSubview:self.emailIdLabel];

    
    self.emailIdTextFld = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    NSAttributedString *emailIdPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Email ID" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[[Configuration shareConfiguration]hitpaBoldFontWithSize:frame.size.width>320.0?15.0:13.0]}];
    
    self.emailIdTextFld.attributedPlaceholder = emailIdPlaceholder;
    self.emailIdTextFld.layer.cornerRadius = 8.0;
    self.emailIdTextFld.layer.masksToBounds = YES;
    self.emailIdTextFld.enabled = NO;
    //self.emailIdTextFld.text = [[UserManager sharedUserManager]emailID];
    self.emailIdTextFld.backgroundColor = [UIColor clearColor];
    self.emailIdTextFld.delegate = self;
    //[emailIdView addSubview:self.emailIdTextFld];
    
    
      //your email password label
    xPos = frame.size.width/4 + 10.0;
    yPos = emailIdView.frame.origin.y+emailIdView.frame.size.height + 5;
    height = 0.0;
    width = 3*frame.size.width/4-20.0;
    UILabel *emailPasswrdLbl = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailPasswrdLbl.tag = kEmailPasswordTag;
    emailPasswrdLbl.text = @"Your Password will be emailed to the above ID";
    emailPasswrdLbl.textColor = [UIColor whiteColor];
    emailPasswrdLbl.font = [[Configuration shareConfiguration]hitpaFontWithSize:10.0];
    emailPasswrdLbl.layer.cornerRadius = 3.0;
    emailPasswrdLbl.layer.masksToBounds = YES;
    emailPasswrdLbl.layer.borderWidth = 0.1;
    emailPasswrdLbl.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:89.0/255.0 blue:163.0/255.0 alpha:1.0];
    emailPasswrdLbl.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.width>320.0?12.0:9.0];
    emailPasswrdLbl.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:emailPasswrdLbl];
    
  //register button
    
    xPos   =  frame.size.width/4;
    yPos   =  emailPasswrdLbl.frame.origin.y + emailPasswrdLbl.frame.size.height + 10.0;
    width  = frame.size.width/4;
    height = roundf(topView.frame.size.height/2.5);
    self.registerBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.registerBtn.layer.cornerRadius = 4.0;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.borderWidth =2.0;
    self.registerBtn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    
    [self.registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.registerBtn setTitle:NSLocalizedString(@"Proceed", nil) forState:UIControlStateNormal];
    [self.registerBtn setHighlighted:YES];
    self.registerBtn.layer.shadowOpacity = 0.4;
    self.registerBtn.layer.shadowRadius = 0.8;
    self.registerBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.registerBtn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientlogin = [[Gradients shareGradients]login];
    gradientlogin.frame = self.registerBtn.bounds;
    [self.registerBtn.layer insertSublayer:gradientlogin atIndex:0];
    [bottomView addSubview:self.registerBtn];
    
    //cancel button
    xPos   =  self.registerBtn.frame.origin.x+self.registerBtn.frame.size.width+10;
    yPos   =  emailPasswrdLbl.frame.origin.y + emailPasswrdLbl.frame.size.height + 10.0;
    width  = frame.size.width/4;
    height = roundf(topView.frame.size.height/2.5);
    self.cancelBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.cancelBtn.layer.cornerRadius = 4.0;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderWidth =2.0;
    self.cancelBtn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    
    [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.cancelBtn setTitle:NSLocalizedString(CancelData, nil) forState:UIControlStateNormal];
    [self.cancelBtn setHighlighted:YES];
    self.cancelBtn.layer.shadowOpacity = 0.4;
    self.cancelBtn.layer.shadowRadius = 0.8;
    self.cancelBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cancelBtn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientCancel = [[Gradients shareGradients]cancel];
    gradientCancel.frame = self.cancelBtn.bounds;
    [self.cancelBtn.layer insertSublayer:gradientCancel atIndex:0];
    [bottomView addSubview:self.cancelBtn];


    // type text for ui view
    xPos    = typeImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = typeImage.frame.size.width ;
    height  = typeImage.frame.size.height;
    UILabel * type = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    type.text = NSLocalizedString(typeData, nil);
    type.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    type.textAlignment = NSTextAlignmentCenter;
    type.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
  
    [typeImage addSubview:type];
    // policy number text for uiview
    xPos    = policyNoImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = policyNoImage.frame.size.width ;
    height  = policyNoImage.frame.size.height;
    UILabel * policy = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    policy.text = NSLocalizedString(policyNumberData, nil);
    policy.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    policy.textAlignment = NSTextAlignmentCenter;
    policy.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
  
   
    [policyNoImage addSubview:policy];

    // employ id text for uiview
    xPos    = employIdImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = employIdImage.frame.size.width ;
    height  = employIdImage.frame.size.height;
    UILabel * empId = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    empId.text = NSLocalizedString(employIdData, nil);
    empId.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    empId.textAlignment = NSTextAlignmentCenter;
    empId.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
    
    [employIdImage addSubview:empId];
    
    // uhid text for uiview
    xPos    = uhidImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = uhidImage.frame.size.width ;
    height  = uhidImage.frame.size.height;
    UILabel * uhid = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    uhid.text = NSLocalizedString(uhidData, nil);
    uhid.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    uhid.textAlignment = NSTextAlignmentCenter;
    uhid.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
    
    [uhidImage addSubview:uhid];

    // mobile number text for uiview
    xPos    = mobileNoImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = mobileNoImage.frame.size.width ;
    height  = mobileNoImage.frame.size.height;
    UILabel * mobileNo = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    mobileNo.text = NSLocalizedString(mobileNoData, nil);
    mobileNo.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    mobileNo.textAlignment = NSTextAlignmentCenter;
    mobileNo.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
    
    [mobileNoImage addSubview:mobileNo];
    
    // email id text for uiview
    xPos    = emailIdImage.frame.size.height/2-14.0;
    yPos    = -2.0;
    width   = emailIdImage.frame.size.width ;
    height  = emailIdImage.frame.size.height;
    UILabel * emailId = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailId.text = NSLocalizedString(emailIdData, nil);
    emailId.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    emailId.textAlignment = NSTextAlignmentCenter;
    emailId.font = [[Configuration shareConfiguration]hitpaFontWithSize:frame.size.height>480?15.0:13.0];
   
    [emailIdImage addSubview:emailId];
}

-(CGRect)bounds{
    return [[UIScreen mainScreen]bounds];
}

- (UIView *)createviewithFrame:(CGRect) frame
{
    return [[UIView alloc]initWithFrame:frame];
}

- (UIImageView *)createimageviewwithFrame:(CGRect) frame
{
    return [[UIImageView alloc]initWithFrame:frame];
}

- (UILabel *)createlabelwithFrame:(CGRect) frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (UIButton *)createbuttonwithFrame:(CGRect) frame
{
    return [[UIButton alloc]initWithFrame:frame];
}

- (UITextField *)createtextfieldwithFrame:(CGRect) frame
{
    return [[UITextField alloc]initWithFrame:frame];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//
//    return YES;
//}
- (void)registrationType:(NSString *)registrationType{
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    self.typeTextFld.text = registrationType;
    CGRect  frame = [self bounds];
    
    
    if([self.typeTextFld.text isEqualToString:@"Retail"]){
        
        
        [(UIView *)[self.view viewWithTag:kEmployviewTag] setHidden:YES];
        [(UIImageView *) [self.view viewWithTag:kEmployIdImageTag] setHidden:YES];
        self.employIdTextFld.hidden = YES;
        UIView *belowview = (UIView*)[self.view viewWithTag:kBelowViewTag];
        
        if (belowview.frame.size.height>frame.size.height/4-10.0) {
            
            //belowview.backgroundColor = [UIColor orangeColor];
            belowview.frame =CGRectMake(0.0, 0.0, belowview.frame.size.width, belowview.frame.size.height-40.0);
            
            UIView *bottomview = (UIView *)[self.view viewWithTag:kBottomViewTag];
            bottomview.frame =CGRectMake(0.0, belowview.frame.origin.y+belowview.frame.size.height+10.0,bottomview.frame.size.width, bottomview.frame.size.height);
        }
    }
    else if([self.typeTextFld.text isEqualToString:@"Corporate"]){
        
        self.typeTextFld.text = registrationType;
        [(UIView *)[self.view viewWithTag:kEmployviewTag] setHidden:NO];
        self.employIdTextFld.hidden = NO;
        [(UIImageView *) [self.view viewWithTag:kEmployIdImageTag] setHidden:NO];
        
        UIView *belowview = (UIView*)[self.view viewWithTag:kBelowViewTag];
        
        if (belowview.frame.size.height<frame.size.height/4-10.0) {
            belowview.frame =CGRectMake(0.0, 0.0, belowview.frame.size.width, belowview.frame.size.height+40.0);
            
            
            UIView *bottomview = (UIView *)[self.view viewWithTag:kBottomViewTag];
            bottomview.frame =CGRectMake(0.0, bottomview.frame.origin.y+40.0,bottomview.frame.size.width, bottomview.frame.size.height);
        }
        
    }
    
}

#pragma mark - Button Delegate

- (IBAction)registerClicked:(UIButton *)sender{
    
    [self.view endEditing:YES];
    if([sender.titleLabel.text isEqualToString:@"Proceed"]) {
        
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            self.registerBtn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished) {
            
            self.registerBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            } completion:^(BOOL finished) {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
                [params setValue:self.typeTextFld.text forKey:@"Type"];
                [params setValue:self.policyNotextFld.text forKey:@"PolicyNumber"];
                [params setValue:self.employIdTextFld.text forKey:@"EmployeeId"];
                [params setValue:self.uhidTextFld.text forKey:@"Uhid"];
                [params setValue:self.mobileNotextFld.text forKey:@"MobileNumber"];
                [params setValue:self.emailIdTextFld.text forKey:@"EmailId"];

                
                NSArray *error = nil;
                
                
                BOOL isValidate = [[Helper shareHelper]validateRegistrationWithWithError:&error parmas:params];
                
                if (!isValidate){
                    NSString *errorMessage = [[Helper shareHelper]getErrorStringFromErrorDescription:error];
                    alertView([[Configuration shareConfiguration]appName], errorMessage, nil, @"Ok", nil, 0);
                    return;
                }
                
                NSString *checkMobileNo = ([[[UserManager sharedUserManager]contactNo] isKindOfClass:[NSNull class]])?@"":[[UserManager sharedUserManager]contactNo];
                NSString *checkEmailID = ([[[UserManager sharedUserManager]emailID] isKindOfClass:[NSNull class]])?@"":[[UserManager sharedUserManager]emailID];
//                NSString *checkMobileNo = @"9603249088";
//                NSString *checkEmailID = @"veer@gmail.com";
                
                CGRect frame = [self bounds];
                [self.registerBtn setTitle:NSLocalizedString(registerData, nil) forState:UIControlStateNormal];
                UIView *contactNo = [self.view viewWithTag:kMobilNoViewTag];
                contactNo.frame = CGRectMake(contactNo.frame.origin.x, contactNo.frame.origin.y,contactNo.frame.size.width, ([checkMobileNo isEqualToString:@""])?0.0:roundf(((frame.size.width/4)/2.5)+ 8.0));
                UILabel *contactNoLbl = (UILabel *)[self.view viewWithTag:kMobilePasswordTag];
                contactNoLbl.frame = CGRectMake(contactNoLbl.frame.origin.x, contactNo.frame.origin.y + contactNo.frame.size.height + 5,contactNoLbl.frame.size.width, ([checkMobileNo isEqualToString:@""])?0.0:12.0);
                UIView *email = [self.view viewWithTag:kEmailIdViewTag];
                email.frame = CGRectMake(email.frame.origin.x, contactNoLbl.frame.origin.y + contactNoLbl.frame.size.height + 10,email.frame.size.width, ([checkEmailID isEqualToString:@""])?0.0:roundf(((frame.size.width/4)/2.5)+ 8.0) + 5.0);
                UILabel *emailLbl = (UILabel *)[self.view viewWithTag:kEmailPasswordTag];
                emailLbl.frame = CGRectMake(emailLbl.frame.origin.x,email.frame.origin.y + email.frame.size.height + 5,emailLbl.frame.size.width, ([checkEmailID isEqualToString:@""])?0.0:12.0);
                self.registerBtn.frame = CGRectMake(self.registerBtn.frame.origin.x,  emailLbl.frame.origin.y + emailLbl.frame.size.height + 10.0,self.registerBtn.frame.size.width, self.registerBtn.frame.size.height);
                self.cancelBtn.frame = CGRectMake(self.cancelBtn.frame.origin.x, emailLbl.frame.origin.y + emailLbl.frame.size.height + 10.0,self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
                
                self.policyNotextFld.superview.backgroundColor = [UIColor lightGrayColor];
                self.policyNotextFld.enabled = NO;
                self.policyNotextFld.backgroundColor = [UIColor clearColor];
                
                self.employIdTextFld.superview.backgroundColor = [UIColor lightGrayColor];
                self.employIdTextFld.enabled = NO;
                self.employIdTextFld.backgroundColor = [UIColor clearColor];
                
                self.uhidTextFld.superview.backgroundColor = [UIColor lightGrayColor];
                self.uhidTextFld.enabled = NO;
                self.uhidTextFld.backgroundColor = [UIColor clearColor];
            }];
            
        }];

    }
    else {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            self.registerBtn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished) {
            
            self.registerBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            } completion:^(BOOL finished) {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
                [params setValue:self.typeTextFld.text forKey:@"Type"];
                [params setValue:self.policyNotextFld.text forKey:@"PolicyNumber"];
                [params setValue:self.employIdTextFld.text forKey:@"EmployeeId"];
                [params setValue:self.uhidTextFld.text forKey:@"Uhid"];
                [params setValue:self.mobileNotextFld.text forKey:@"MobileNumber"];
                [params setValue:self.emailIdTextFld.text forKey:@"EmailId"];
                
                NSArray *error = nil;
                
                
                BOOL isValidate = [[Helper shareHelper]validateRegistrationWithWithError:&error parmas:params];
                
                if (!isValidate){
                    NSString *errorMessage = [[Helper shareHelper]getErrorStringFromErrorDescription:error];
                    alertView([[Configuration shareConfiguration]appName], errorMessage, nil, @"Ok", nil, 0);
                    return;
                }
                
                NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithCapacity:8];
                [requestParams setValue:[[UserManager sharedUserManager]userName] forKey:@"username"];
                [requestParams setValue:[[Helper shareHelper] getUniqueDeviceIdentifierAsString] forKey:@"DeviceIMEI"];
                [requestParams setValue:kRegistrationDevice forKey:@"DeviceOS"];
                [requestParams setValue:[[Configuration shareConfiguration] deviceModelName] forKey:@"DeviceModel"];
                [requestParams setValue:([[Configuration shareConfiguration] serviceProvider] != nil && [[Configuration shareConfiguration] serviceProvider].length > 0)?[[Configuration shareConfiguration] serviceProvider]:@"" forKey:@"DeviceCarrier"];
                [requestParams setValue:[NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]] forKey:@"OsVersion"];
                
                [self showHUDWithMessage:@""];
                [[HITPAAPI shareAPI] registrationWithParams:requestParams completionHandler:^(NSDictionary *response ,NSError *error){
                    
                    [self didReceiverRegistrationResponse:response error:error];
                    
                }];
                
            }];
            
        }];
 
    }
    

}

- (IBAction)cancelClicked:(id)sender{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)typeButtonTapped:(id)sender{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if (self.nIDropDown == nil){
        
        
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-40,frame.size.width>360.0?255.0:215.0,frame.size.width/2+10, 100.0)];
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
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:self.typeArray imgArr:nil direction:@"down" isIndex:90000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        [self.view addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
    
}


#pragma mark - Handler

- (void)didReceiverRegistrationResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    NSString *str = [response objectForKey:@"ResponseMessage"];
    
    if ([str isEqualToString:kRegistrationSuccessMsg]) {
        
        alertView([[Configuration shareConfiguration] appName], str, self, @"Ok", nil, kRegistartionSuccessTag);

    }
    else{
        
        if(error == nil) {
            alertView([[Configuration shareConfiguration] appName],@"Registration failed" , nil, @"Ok", nil, 0);
            return;
        }
        else
        {
            alertView([[Configuration shareConfiguration] appName], @"No internet connection. Connect to internet to proceed", nil, @"Ok", nil, 0);
            return;
        }
        
        
        
    }
    
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *nextField =[self getNextFiledFromCurrentField:textField];
    if (nextField != nil) {
        [nextField becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
        
    }
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [[KeyboardHelper sharedKeyboardHelper]animateTextField:textField isUp:YES View:self.view];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [[KeyboardHelper sharedKeyboardHelper]animateTextField:textField isUp:NO View:self.view];
}

- (UITextField *)getNextFiledFromCurrentField:(UITextField *)textField
{
    
    UITextField *nextField = nil;
    
    Fieldtype fieldType = (Fieldtype)textField.tag;
    
    switch (fieldType) {
        case EmailPhoneNo:
            nextField = (UITextField *)[self.view viewWithTag:Password];
            break;
        case Password:
            break;
            
        default:
            break;
    }
    
    return nextField;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "] )
       {
           return NO;
       }
    if(textField == self.employIdTextFld) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *alphabets = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:alphabets] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return ([string isEqualToString:filtered])?!([newString length] > 15):NO;
    }
    return YES;
}

#pragma mark - HUD

- (void)showHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    [self.progressHUD show:YES];
}

- (void)showSuccessHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.delegate = self;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:2.0];
}

- (void)showErrorHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [[Configuration shareConfiguration] hitpaFontWithSize:14.0];
    self.progressHUD.margin = 10.f;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.progressHUD hide:YES afterDelay:2.0];
}

- (void)hideHUD
{
    [self.progressHUD hide:YES];
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kRegistartionSuccessTag) {
        
        if (buttonIndex == 0)
        {
            HITPAAppDelegate *appDelegate = (HITPAAppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
            ChangePasswordController *vctr = [[ChangePasswordController alloc]initWithIsRegister:YES];
            [navigationController pushViewController:vctr animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else
        {
            return;
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
