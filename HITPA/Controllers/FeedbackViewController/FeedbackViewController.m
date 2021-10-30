//
//  FeedbackViewController.m
//  HITPA
//
//  Created by Kranthi B. on 11/9/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Configuration.h"
//#import "KeyboardHelper.h"
#import "Constants.h"
#import "HITPAAPI.h"
#import "Utility.h"
#import "UpdatesViewController.h"

NSString    *  const kFeedbackResponse          =  @"\"Feedback submitted successfully\"";
NSString    *  const kFeedbackSuccessMessage    =  @"Feedback submitted successfully";

@interface FeedbackViewController (){
    
}
@property (strong, nonatomic) UITextField *amountField,*dischargeField,*claimField;
@property (nonatomic,strong) UIView *rateIcView, *rateDoctorView, *rateProfView;
@property (nonatomic,strong) NSMutableDictionary *feedbackResponse;
@property (nonatomic,strong) NSDictionary *updateDetails;
@property (nonatomic,strong) UILabel *labelDoctor;
@property (nonatomic,strong) UILabel *profLabel;
@property (nonatomic,strong)  UILabel * patientLabel;
@property (nonatomic,strong)  UISegmentedControl *segmentControl;

@end

@implementation FeedbackViewController

- (instancetype)initWithUpdateDetails:(NSDictionary *)updateDetails
{
    self = [super init];
    self.updateDetails = [[NSMutableDictionary alloc]init];
    if (self)
    {
        self.updateDetails = updateDetails;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Feedback", @"");
    self.feedbackResponse = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"HospitalFeedback1",@"",@"HospitalFeedback2",@"",@"HospitalFeedback3", nil]],@"Hospital",[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"TPAFeedback1",@"",@"TPAFeedback2",@"",@"TPAFeedback3", nil]],@"TPA", nil];
    // Do any additional setup after loading the view from its nib.
    [self topView];
}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.0);
    [self.view layoutIfNeeded];
    
}

- (void)topView {
    
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = frame.size.height;
    
    UIView * aboveView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    //[aboveView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:aboveView];
    
    //success label
    xPos = 10.0;
    yPos = 10.0;
    width = frame.size.width - 10.0;
    height = 30.0;
    UILabel *labelSuccess = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    labelSuccess.text = @"The event has been successfully transacted!";
    labelSuccess.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [aboveView addSubview:labelSuccess];
    
    //enhanced label
    xPos = 10.0;
    yPos = labelSuccess.frame.origin.y + labelSuccess.frame.size.height;
    width = frame.size.width / 2;
    height = 20.0;
    UILabel *labelAmount = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    labelAmount.text = @"Amount Enhanced   :";
    //labelSuccess.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    labelAmount.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [aboveView addSubview:labelAmount];
    
    // discharge label
    xPos = 10;
    yPos = labelAmount.frame.origin.y + labelAmount.frame.size.height;
    width = frame.size.width / 2.0;
    height = 20.0;
    UILabel *labelDischarge = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    labelDischarge.text = @"Discharge Amount   :";
    //labelSuccess.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    labelDischarge.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [aboveView addSubview:labelDischarge];
    
    //claim label
    xPos = 10.0;
    yPos = labelDischarge.frame.origin.y+ labelDischarge.frame.size.height;
    width = frame.size.width/2;
    height = 20.0;
    UILabel *labelClaim = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    labelClaim.text = @"Total Claim Amount :";
    labelClaim.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [aboveView addSubview:labelClaim];
    
    //enhanced textfield
    xPos = frame.size.width - labelAmount.frame.size.width;
    yPos = labelSuccess.frame.origin.y+ labelSuccess.frame.size.height;
    width= frame.size.width / 2;
    height = 20.0;
    self.amountField = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.amountField.textColor = [UIColor whiteColor];
    self.amountField.text = [self.updateDetails valueForKey:@"amountEnhanced"];
    self.amountField.delegate = self;
    //self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    [aboveView addSubview:self.amountField];
    
    
    //discharge textfield
    yPos = labelAmount.frame.origin.y + labelAmount.frame.size.height;
    self.dischargeField = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.dischargeField.textColor = [UIColor whiteColor];
    self.dischargeField.text = [self.updateDetails valueForKey:@"dischargeAmount"];
    self.dischargeField.delegate = self;
    [aboveView addSubview:self.dischargeField];
    
    yPos = labelDischarge.frame.origin.y + labelDischarge.frame.size.height;
    self.claimField = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.claimField.textColor = [UIColor whiteColor];
    CGFloat claimAmt = [[self.updateDetails valueForKey:@"amountEnhanced"]floatValue] + [[self.updateDetails valueForKey:@"dischargeAmount"]floatValue];
    self.claimField.text = [NSString stringWithFormat:@"%.2f",claimAmt];
    self.claimField.delegate = self;
    [aboveView addSubview:self.claimField];
    

    //feedback label
    xPos = 10.0;
    yPos = labelClaim.frame.origin.y + labelClaim.frame.size.height;
    width = frame.size.width - 10.0;
    height = 30.0;
    UILabel *labelfeed = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    labelfeed.text = @"Give Your Feedback";
    labelfeed.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [aboveView addSubview:labelfeed];
    //hospital label
//    xPos = 10;
//    yPos = labelfeed.frame.origin.y+ labelfeed.frame.size.height;
//    width = frame.size.width/2;
//    height = 60;
//    UILabel *labelhospital = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
//    labelhospital.text = @"Hospital";
//    labelhospital.textAlignment = NSTextAlignmentCenter;
//    labelhospital.tintColor = [UIColor blackColor];
//    labelhospital.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
//    labelhospital.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
//    [aboveView addSubview:labelhospital];
//    
    
    
    xPos = 10.0;
    yPos = labelfeed.frame.origin.y + labelfeed.frame.size.height;
    width = frame.size.width - 20.0;
    height = 30.0;
    NSArray * arr = [[NSArray alloc]initWithObjects:@"HOSPITAL",@"TPA", nil];
    self.segmentControl = [[UISegmentedControl alloc]initWithItems:arr];
    self.segmentControl.frame = CGRectMake(xPos, yPos, width, height);
    self.segmentControl.tintColor = [UIColor colorWithRed:23.0/255.0 green:131.0/255.0 blue:75.0/255 alpha:1.0];
    self.segmentControl.backgroundColor = [UIColor whiteColor];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.layer.cornerRadius = 5.0;
    self.segmentControl.layer.masksToBounds = YES;
    [self.segmentControl addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    [aboveView addSubview:self.segmentControl];
    
    //doctor label
    xPos = 10.0;
    yPos = self.segmentControl.frame.origin.y + self.segmentControl.frame.size.height + 5.0;
    width = frame.size.width - 20.0;
    height = 40.0;
    self.labelDoctor = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.labelDoctor.text = @"Nurses and Doctors were patient when dealing with patients";
    self.labelDoctor.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    self.labelDoctor.numberOfLines = 0;
    [aboveView addSubview:self.labelDoctor];
    
    //rated view
    xPos = 10.0;
    yPos = self.labelDoctor.frame.origin.y + self.labelDoctor.frame.size.height;
    width = aboveView.frame.size.width - 2 * xPos;
    height = 50.0;
    self.rateDoctorView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.rateDoctorView.backgroundColor = [UIColor clearColor];
    self.rateDoctorView.layer.cornerRadius = 5.0;
    self.rateDoctorView.tag = 1;
    [aboveView addSubview:self.rateDoctorView];
    
    
    //rate imageview
    xPos = 0.0;
    yPos = 0.0;
    UIImageView *rateDoctorImageView = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    rateDoctorImageView.image = [UIImage imageNamed:@"icon_livetrackback.png"];
    [self.rateDoctorView addSubview:rateDoctorImageView];
    
    // rate strong button
    xPos = 0.0;
    yPos = 0.0;
    width = self.rateDoctorView.frame.size.width/4;
    height = 50.0;
    UIButton *strongBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strongBtn.backgroundColor = [UIColor clearColor];
    strongBtn.titleLabel.numberOfLines = 0;
    strongBtn.tag = 1;
    strongBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    strongBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [strongBtn setTitle:@"Strongly \n Agree" forState:UIControlStateNormal];
    [strongBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateDoctorView addSubview:strongBtn];
    
    // rate agree button
    xPos = strongBtn.frame.origin.x + strongBtn.frame.size.width;
    width = self.rateDoctorView.frame.size.width/4;
    UIButton *agreeBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    agreeBtn.backgroundColor = [UIColor clearColor];
    agreeBtn.titleLabel.numberOfLines = 0;
    agreeBtn.tag = 2;
    agreeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    agreeBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [agreeBtn setTitle:@"Agree" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateDoctorView addSubview:agreeBtn];
    
    //rate disagree button
    xPos = agreeBtn.frame.size.width+ agreeBtn.frame.origin.x;
    width = self.rateDoctorView.frame.size.width/4;
    UIButton *disAgreeBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    disAgreeBtn.backgroundColor = [UIColor clearColor];
    disAgreeBtn.titleLabel.numberOfLines = 0;
    disAgreeBtn.tag = 3;
    disAgreeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    disAgreeBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [disAgreeBtn setTitle:@"Disagree" forState:UIControlStateNormal];
    [disAgreeBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateDoctorView addSubview:disAgreeBtn];
    
    // rate strongly disagree button
    xPos = disAgreeBtn.frame.size.width+ disAgreeBtn.frame.origin.x;
    width = self.rateDoctorView.frame.size.width/4;
    UIButton *strngDisAgreeBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strngDisAgreeBtn.backgroundColor = [UIColor clearColor];
    strngDisAgreeBtn.titleLabel.numberOfLines = 0;
    strngDisAgreeBtn.tag = 4;
    strngDisAgreeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    strngDisAgreeBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [strngDisAgreeBtn setTitle:@"Strongly Disagree" forState:UIControlStateNormal];
    [strngDisAgreeBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateDoctorView addSubview:strngDisAgreeBtn];

    
    //profession label
    
    xPos = 10.0;
    yPos = self.rateDoctorView.frame.origin.y + self.rateDoctorView.frame.size.height + 10.0;
    width = frame.size.width - 20.0;
    height = 30.0;
    self.profLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.profLabel.text =@"Professionalism is of high standard";
    self.profLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [aboveView addSubview:self.profLabel];
    
    //rated prof view
    xPos = 10.0;
    yPos = self.profLabel.frame.origin.y + self.profLabel.frame.size.height;
    width = aboveView.frame.size.width - 2 * xPos;
    height = 50.0;
    self.rateProfView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //rateDoctorView.backgroundColor = [UIColor redColor];
    self.rateProfView.layer.cornerRadius = 5.0;
    self.rateProfView.tag = 2;
    [aboveView addSubview:self.rateProfView];
    
    
    //rate imageview
    xPos = 0.0;
    yPos = 0.0;
    UIImageView *rateProfImageView = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    rateProfImageView.image = [UIImage imageNamed:@"icon_livetrackback.png"];
    [self.rateProfView addSubview:rateProfImageView];
    
    
    // rate strong button
    xPos = 0.0;
    yPos = 0.0;
    width = self.rateProfView.frame.size.width/4;
    height = 50.0;
    UIButton *strongPBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strongPBtn.backgroundColor = [UIColor clearColor];
    strongPBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    strongPBtn.titleLabel.numberOfLines = 0;
    strongPBtn.tag = 1;
    strongPBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [strongPBtn setTitle:@"Strongly \n Agree" forState:UIControlStateNormal];
    [strongPBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateProfView addSubview:strongPBtn];
    
    // rate agree button
    xPos = strongPBtn.frame.origin.x+ strongPBtn.frame.size.width;
    width = self.rateProfView.frame.size.width/4;
    UIButton *agreePBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    agreePBtn.backgroundColor = [UIColor clearColor];
    agreePBtn.titleLabel.numberOfLines = 0;
    agreePBtn.tag = 2;
    agreePBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    agreePBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [agreePBtn setTitle:@"Agree" forState:UIControlStateNormal];
    [agreePBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateProfView addSubview:agreePBtn];
    
    //rate disagree button
    xPos = agreePBtn.frame.size.width+ agreePBtn.frame.origin.x;
    width = self.rateProfView.frame.size.width/4;
    UIButton *disAgreePBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    disAgreePBtn.backgroundColor = [UIColor clearColor];
    disAgreePBtn.titleLabel.numberOfLines = 0;
    disAgreePBtn.tag = 3;
    disAgreePBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    disAgreePBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [disAgreePBtn setTitle:@"Disagree" forState:UIControlStateNormal];
    [disAgreePBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateProfView addSubview:disAgreePBtn];
    
    // rate strongly disagree button
    xPos = disAgreePBtn.frame.size.width+ disAgreePBtn.frame.origin.x;
    width = self.rateProfView.frame.size.width/4;
    UIButton *strngDisAgreePBtn= [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strngDisAgreePBtn.backgroundColor = [UIColor clearColor];
    strngDisAgreePBtn.titleLabel.numberOfLines = 0;
    strngDisAgreePBtn.tag = 4;
    strngDisAgreePBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    strngDisAgreePBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [strngDisAgreePBtn setTitle:@"Strongly Disagree" forState:UIControlStateNormal];
    [strngDisAgreePBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateProfView addSubview:strngDisAgreePBtn];
    
    
    //patient label
    xPos = 10.0;
    yPos = self.rateProfView.frame.origin.y + self.rateProfView.frame.size.height + 10.0;
    width  = frame.size.width-2;
    height = aboveView.frame.size.height/28;
    self.patientLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.patientLabel.text = @"Patient are attended IC promptly";
    self.patientLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [aboveView addSubview:self.patientLabel];
    
    //rated prof view
    xPos = 10.0;
    yPos = self.patientLabel.frame.origin.y + self.patientLabel.frame.size.height;
    width = aboveView.frame.size.width - 2 * xPos;
    height = 50.0;
    self.rateIcView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    //rateDoctorView.backgroundColor = [UIColor redColor];
    self.rateIcView.tag = 3;
    [aboveView addSubview:self.rateIcView];
    
    
    //rate imageview
    xPos = 0.0;
    yPos = 0.0;
    UIImageView *rateIcImageView = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    rateIcImageView.image = [UIImage imageNamed:@"icon_livetrackback.png"];
    [self.rateIcView addSubview:rateIcImageView];
    
    
    // rate strong button
    xPos = 0.0;
    yPos = 0.0;
    width = self.rateIcView.frame.size.width/4;
//    height = aboveView.frame.size.height/10;
     height = 50;
    UIButton *strongIcBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strongIcBtn.backgroundColor = [UIColor clearColor];
    strongIcBtn.titleLabel.numberOfLines = 0;
    strongIcBtn.tag = 1;
    strongIcBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    strongIcBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [strongIcBtn setTitle:@"Strongly \n Agree" forState:UIControlStateNormal];
    [strongIcBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateIcView addSubview:strongIcBtn];
    
    // rate agree button
    xPos = strongIcBtn.frame.origin.x + strongIcBtn.frame.size.width;
    width = self.rateIcView.frame.size.width/4;
    UIButton *agreeIcBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    agreeIcBtn.backgroundColor = [UIColor clearColor];
    agreeIcBtn.titleLabel.numberOfLines = 0;
    agreeIcBtn.tag = 2;
    agreeIcBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    agreeIcBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [agreeIcBtn setTitle:@"Agree" forState:UIControlStateNormal];
    [agreeIcBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateIcView addSubview:agreeIcBtn];
    
    //rate disagree button
    xPos = agreeIcBtn.frame.size.width + agreeIcBtn.frame.origin.x;
    width = self.rateIcView.frame.size.width/4;
    UIButton *disAgreeIcBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    disAgreeIcBtn.backgroundColor = [UIColor clearColor];
    disAgreeIcBtn.titleLabel.numberOfLines = 0;
    disAgreeIcBtn.tag = 3;
    disAgreeIcBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    disAgreeIcBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [disAgreeIcBtn setTitle:@"Disagree" forState:UIControlStateNormal];
    [disAgreeIcBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateIcView addSubview:disAgreeIcBtn];
    
    // rate strongly disagree button
    xPos = disAgreeIcBtn.frame.size.width+ disAgreeIcBtn.frame.origin.x;
    width = self.rateIcView.frame.size.width/4;
    UIButton *strngDisAgreeIcBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    strngDisAgreeIcBtn.backgroundColor = [UIColor clearColor];
    strngDisAgreeIcBtn.titleLabel.numberOfLines = 0;
    strngDisAgreeIcBtn.tag = 4;
    strngDisAgreeIcBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    strngDisAgreeIcBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    [strngDisAgreeIcBtn setTitle:@"Strongly Disagree" forState:UIControlStateNormal];
    [strngDisAgreeIcBtn addTarget:self action:@selector(feedbackBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rateIcView addSubview:strngDisAgreeIcBtn];
    
    // SUBMIT button
    yPos = self.rateIcView.frame.origin.y + self.rateIcView.frame.size.height + 15.0;
    width = 100.0;
    height = 40.0;
    xPos = (frame.size.width - width) / 2.0;
    UIButton *submitBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 4.0;
    submitBtn.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
    submitBtn.layer.borderWidth = 1.0;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
    [submitBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aboveView addSubview:submitBtn];


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



- (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.amountField resignFirstResponder];
    [self.dischargeField resignFirstResponder];
    [self.claimField resignFirstResponder];
    [textField resignFirstResponder];
 
    return YES;
    
}

#pragma mark - Button Delegate
- (void)feedbackBtnTapped:(UIButton *)sender {
    NSArray *subviews = sender.superview.subviews;
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == sender.tag) {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
    UIView *superView = sender.superview;
    if (self.segmentControl.selectedSegmentIndex == 0) {
        NSMutableArray *response = [self getArrayforFeedbackResponseWithIndex:superView.tag array:[self.feedbackResponse valueForKey:@"Hospital"] feedbackIndex:sender.tag];
        [self.feedbackResponse setValue:response forKey:@"Hospital"];
    }
    else {
        NSMutableArray *response = [self getArrayforFeedbackResponseWithIndex:superView.tag array:[self.feedbackResponse valueForKey:@"TPA"] feedbackIndex:sender.tag];
        [self.feedbackResponse setValue:response forKey:@"TPA"];
    }
}

- (NSMutableArray *)getArrayforFeedbackResponseWithIndex:(NSInteger)index array:(NSMutableArray *)response feedbackIndex:(NSInteger)feedbackIndex {
    
    switch (index) {
        case 1:
            (self.segmentControl.selectedSegmentIndex == 0)?[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"HospitalFeedback1"]:[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"TPAFeedback1"];
            break;
        case 2:
            (self.segmentControl.selectedSegmentIndex == 0)?[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"HospitalFeedback2"]:[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"TPAFeedback2"];
            break;
        case 3:
            (self.segmentControl.selectedSegmentIndex == 0)?[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"HospitalFeedback3"]:[[response objectAtIndex:0]setValue:[NSString stringWithFormat:@"%ld",(long)feedbackIndex] forKey:@"TPAFeedback3"];
            break;
        default:
            break;
    }
    return  response;
}

- (void)submitButtonTapped:(UIButton *)sender {
    
    NSMutableArray *hospitalArray = [NSMutableArray new];
    hospitalArray = [self getFeedBackDetailWithFeedType:@"Hospital"];
    NSMutableArray *tpaArray = [NSMutableArray new];
    tpaArray = [self getFeedBackDetailWithFeedType:@"TPA"];
    
    NSLog(@"Bool 0: %d", [[[hospitalArray objectAtIndex:0] valueForKey:@"Remarks"] isEqualToString:@""]);
    NSLog(@"Bool 1: %d", [[[hospitalArray objectAtIndex:1] valueForKey:@"Remarks"] isEqualToString:@""]);
    NSLog(@"Bool 2: %d", [[[hospitalArray objectAtIndex:2] valueForKey:@"Remarks"] isEqualToString:@""]);
    if (([[[hospitalArray objectAtIndex:0] valueForKey:@"Remarks"] isEqualToString:@""] && [[[hospitalArray objectAtIndex:1] valueForKey:@"Remarks"] isEqualToString:@""] && [[[hospitalArray objectAtIndex:2] valueForKey:@"Remarks"] isEqualToString:@""]) && ([[[tpaArray objectAtIndex:0] valueForKey:@"Remarks"] isEqualToString:@""] && [[[tpaArray objectAtIndex:1] valueForKey:@"Remarks"] isEqualToString:@""] && [[[tpaArray objectAtIndex:2] valueForKey:@"Remarks"] isEqualToString:@""])) {
        
        NSLog(@"Not Selected Any One");
        alertView([[Configuration shareConfiguration] appName], @"Select Feedback", nil, @"Ok", nil, 0);
        
    } else {
        
        NSDictionary *hospitalDict = [[NSDictionary alloc]initWithObjectsAndKeys:[self.updateDetails valueForKey:@"UHID"],@"UHID",[self.updateDetails valueForKey:@"ClaimNo"],@"ClaimNo",@"Hospital",@"FeedbackType", hospitalArray,@"FeedbackDetails",nil];
        NSDictionary *tpaDict = [[NSDictionary alloc]initWithObjectsAndKeys:[self.updateDetails valueForKey:@"UHID"],@"UHID",[self.updateDetails valueForKey:@"ClaimNo"],@"ClaimNo",@"TPA",@"FeedbackType", tpaArray,@"FeedbackDetails",nil];
        
        NSArray *feedback = [[NSArray alloc]initWithObjects:hospitalDict,tpaDict, nil];
        
        
        
        [self showHUDWithMessage:@""];
        
        [[HITPAAPI shareAPI] postFeedbackWithParams:feedback completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceiveFeedbackResponse:response error:error];
        }];
    }
}

- (void)didReceiveFeedbackResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    
    NSString *str = [NSString stringWithFormat:@"%@", [response objectForKey:@"successID"]];
    
    if ([str isEqualToString:kFeedbackResponse]) {
        NSLog(@"%@",str);
//         alertView([[Configuration shareConfiguration] appName], [str stringByReplacingOccurrencesOfString:@"\"" withString:@""], nil, @"Ok", nil, 0);
//        [self.navigationController popViewControllerAnimated:YES];
//
        alertView([[Configuration shareConfiguration] appName], [str stringByReplacingOccurrencesOfString:@"\"" withString:@""], self, @"Ok", nil, 0);
    }else{
        
        if(error == nil) {
            alertView([[Configuration shareConfiguration] appName], [str stringByReplacingOccurrencesOfString:@"\"" withString:@""], nil, @"Ok", nil, 0);
            return;
        }
        else
        {
            alertView([[Configuration shareConfiguration] appName], @"No internet connection. Connect to internet to proceed", nil, @"Ok", nil, 0);
            return;
        }
    }
    
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        
        if (buttonIndex == 0)
        {
//            [self.navigationController popViewControllerAnimated:YES];
//            UpdatesViewController *vctr = [[UpdatesViewController alloc] init];
//            [self.navigationController popToViewController:vctr animated:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        }else
        {
            return;
        }
    }
}


#pragma mark - Segment Control
- (void)segmentedChanged:(UISegmentedControl *)sender {
    NSMutableArray *response;
    NSString *feedback1Index, *feedback2Index, *feedback3Index;
    if(sender.selectedSegmentIndex == 0) {
        self.labelDoctor.text = @"Nurses and Doctors were patient when dealing with patients";
        self.profLabel.text = @"Professionalism is of high standard";
        self.patientLabel.text = @"Patient are attended IC promptly";
        response = [self.feedbackResponse valueForKey:@"Hospital"];
        feedback1Index = [[response objectAtIndex:0]valueForKey:@"HospitalFeedback1"];
        feedback2Index = [[response objectAtIndex:0]valueForKey:@"HospitalFeedback2"];
        feedback3Index = [[response objectAtIndex:0]valueForKey:@"HospitalFeedback3"];
    }
    else {
        self.labelDoctor.text = @"TPA informed you the complete process in time giving full details";
        self.profLabel.text = @"Professionalism is of high standard";
        self.patientLabel.text = @"I have not heard any major complaints on TPA";
        response = [self.feedbackResponse valueForKey:@"TPA"];
        feedback1Index = [[response objectAtIndex:0]valueForKey:@"TPAFeedback1"];
        feedback2Index = [[response objectAtIndex:0]valueForKey:@"TPAFeedback2"];
        feedback3Index = [[response objectAtIndex:0]valueForKey:@"TPAFeedback3"];
    }
    
    [self setFeedbackButtonTextColorWithIndex:[feedback1Index integerValue] view:self.rateDoctorView];
    [self setFeedbackButtonTextColorWithIndex:[feedback2Index integerValue] view:self.rateProfView];
    [self setFeedbackButtonTextColorWithIndex:[feedback3Index integerValue] view:self.rateIcView];

}

- (void)setFeedbackButtonTextColorWithIndex:(NSInteger)index view:(UIView *)view {
    NSArray *subviews = view.subviews;
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == index) {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }

}

- (NSMutableArray *)getFeedBackDetailWithFeedType:(NSString *)feedbackType {
    NSMutableArray *feedbackDetails = [[NSMutableArray alloc]init];
    
    for (int i = 1; i < 4; i++) {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[self getFeedbackQuestionWithIndex:i feedbackType:feedbackType],@"Question",[self getFeedbackOptionStringWithValue:[[[[self.feedbackResponse valueForKey:feedbackType]objectAtIndex:0] valueForKey:[NSString stringWithFormat:@"%@Feedback%d",feedbackType,i]]integerValue]] ,@"Remarks", nil];
        [feedbackDetails addObject:dict];
    }
    
    return feedbackDetails;
}

- (NSString *)getFeedbackQuestionWithIndex:(NSInteger)index feedbackType:(NSString *)feedbackType {
    
    if ([feedbackType isEqualToString:@"Hospital"]) {
        switch (index) {
            case 1:
                return @"Nurses and Doctors were patient when dealing with patients";
            case 2:
                return @"Professionalism is of high standard";
            case 3:
                return @"Patient are attended IC promptly";
            default:
                break;
        }
    }
    else {
        switch (index) {
            case 1:
                return @"TPA informed you the complete process in time giving full details";
            case 2:
                return @"Professionalism is of high standard";
            case 3:
                return @"I have not heard any major complaints on TPA";
            default:
                break;
        }
 
    }
    return @"";
}

- (NSString *)getFeedbackOptionStringWithValue:(NSInteger)index {
    switch (index) {
        case 1:
            return @"Strongly \n Agree";
        case 2:
            return @"Agree";
        case 3:
            return @"Disagree";
        case 4:
            return @"Strongly Disagree";
        default:
            break;
    }
    return @"";
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
