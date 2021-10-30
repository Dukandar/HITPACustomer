//
//  BMICalculatorViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 02/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "BMICalculatorViewController.h"
#import "Gradients.h"
//#import "KeyboardHelper.h"
#import "Configuration.h"
#import "Constants.h"
#import "Helper.h"
#import "Utility.h"

@interface BMICalculatorViewController ()

@property(nonatomic, strong) UITextField *weightTextfield;
@property(nonatomic, strong) UITextField *heightTextfield;
@property(nonatomic, strong) UITextField *feetTextfield;
@property(nonatomic, strong) UITextField *inchesTextfield;
@property(nonatomic, strong) UILabel *bmiLabel;
@property(nonatomic, strong) UIView *bmiTable;
@property(nonatomic, readwrite) BOOL isKgs;
@property(nonatomic, readwrite) BOOL isCms;
@property (nonatomic,strong)     NSMutableArray     *bmiLabelTitles;
@property (nonatomic,strong)     NSMutableArray     *bmiLabelValues;

@end

@implementation BMICalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[KeyboardHelper sharedKeyboardHelper]notificationCenter:[[UITableView alloc]init] view:self.view];
    
    self.navigationItem.title = NSLocalizedString(@"BMI Calculator", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    
    self.isKgs = YES;
    self.isCms = YES;
    self.bmiLabelTitles = [[NSMutableArray alloc]initWithObjects:@"BMI",@"Below 18.5",@"18.5 to 24.9",@"25 to 29.9",@"Above 30", nil];
    self.bmiLabelValues = [[NSMutableArray alloc]initWithObjects:@"Meaning",@"Underweight",@"Healthy Weight",@"Above ideal range",@"Obese", nil];
    [self barItems];
    [self createBMIView];
}

- (void)barItems
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    UIImage *buttonImage = [UIImage imageNamed:@"icon_back_arrow.png"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, 1.0)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineView];
    
}

- (void)createBMIView {
    
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    //scroll View
    xPos = 0.0;
    yPos = 64.0;
    width = frame.size.width;
    height = frame.size.height;
    UIScrollView *bmiScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    bmiScroll.showsVerticalScrollIndicator = NO;
    bmiScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bmiScroll];
    
    //weight View
    xPos = 0.0;
    yPos = 5.0;
    width = frame.size.width;
    height = 85.0;
    UIView *weightView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [weightView setTag:0];
    [weightView setBackgroundColor:[UIColor clearColor]];
    [bmiScroll addSubview:weightView];
    
    xPos = 10.0;
    yPos = 5.0;
    width = frame.size.width * 0.3;
    height = 30.0;
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    weightLabel.text = @"Weight :";
    weightLabel.textColor = [UIColor whiteColor];
    [weightLabel setFont:[[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0]];
    [weightLabel sizeToFit];
    width = weightLabel.frame.size.width;
    [weightLabel setFrame:CGRectMake(xPos, yPos, width, height)];
    [weightView addSubview:weightLabel];
    
    CGFloat x = weightLabel.frame.origin.x + weightLabel.frame.size.width + 10.0;
    for(int i = 0; i<2; i++){
        xPos = x;
        yPos = 5.0;
        width = (frame.size.width - weightLabel.frame.size.width - 25.0)/2.0;
        height = 30.0;
        UIView *radioView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        radioView.tag = i;
        [radioView setBackgroundColor:[UIColor clearColor]];
        [weightView addSubview:radioView];
        
        xPos = 0.0;
        width = 20.0;
        height = 20.0;
        yPos = (radioView.frame.size.height - height)/2.0;
        UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        outerView.layer.borderColor = [[UIColor whiteColor]CGColor];
        outerView.layer.borderWidth = 1.0;
        outerView.layer.cornerRadius = height/2.0;
        [radioView addSubview:outerView];
        
        width = 8.0;
        height = 8.0;
        yPos = (outerView.frame.size.height - height)/2.0;
        xPos = (outerView.frame.size.width - width)/2.0;
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [innerView setBackgroundColor:[UIColor whiteColor]];
        innerView.layer.cornerRadius = height/2.0;
        [outerView addSubview:innerView];
        
        if (i == 1) {
            [innerView setHidden:YES];
        }
        
        xPos = outerView.frame.origin.x + outerView.frame.size.width + 5.0;
        yPos = 0.0;
        width = radioView.frame.size.width - xPos - 5.0;
        height = radioView.frame.size.height;
        UILabel *radioLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        radioLabel.text = (i == 0) ? @"Kgs" : @"Pounds";
        [radioLabel setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
        [radioLabel setTextColor:[UIColor whiteColor]];
        [radioView addSubview:radioLabel];
        
        UITapGestureRecognizer *radioGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(radioButtonTapped:)];
        [radioView addGestureRecognizer:radioGesture];
        
        x = x + radioView.frame.size.width + 5.0;
    }
    
    xPos = 10.0;
    yPos = weightLabel.frame.origin.y + weightLabel.frame.size.height;
    width = weightView.frame.size.width - xPos - 100.0;
    height = 40.0;
    UIView *weightTextView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [weightTextView setBackgroundColor:[UIColor whiteColor]];
    weightTextView.layer.cornerRadius = 5.0;
    [weightTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [weightTextView.layer setBorderWidth:0.5];
    [weightView addSubview:weightTextView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = weightTextView.frame.size.width - 2 * xPos;
    height = weightTextView.frame.size.height;
    self.weightTextfield = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.weightTextfield setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    self.weightTextfield.delegate = self;
    self.weightTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.weightTextfield setTextColor:[UIColor blackColor]];
    [weightTextView addSubview:self.weightTextfield];
    
    xPos = weightTextView.frame.origin.x + weightTextView.frame.size.width + 5.0;
    yPos = weightLabel.frame.origin.y + weightLabel.frame.size.height;
    width = weightView.frame.size.width - xPos - 10.0;
    UILabel *weightUnit = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [weightUnit setText:@"Kgs"];
    weightUnit.textColor = [UIColor whiteColor];
    [weightUnit setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    [weightView addSubview:weightUnit];
    
    xPos = 10.0;
    yPos = weightView.frame.size.height - 1.0;
    width = frame.size.width;
    height = 1.0;
    UIView *weightLineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [weightLineView setBackgroundColor:[UIColor whiteColor]];
    [weightView addSubview:weightLineView];
    
    //height View
    xPos = 0.0;
    yPos = weightView.frame.origin.y + weightView.frame.size.height + 5.0;
    width = frame.size.width;
    height = 85.0;
    UIView *heightView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [heightView setTag:1];
    [heightView setBackgroundColor:[UIColor clearColor]];
    [bmiScroll addSubview:heightView];
    
    xPos = 10.0;
    yPos = 5.0;
    width = frame.size.width * 0.3;
    height = 30.0;
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    heightLabel.text = @"Height :";
    heightLabel.textColor = [UIColor whiteColor];
    [heightLabel setFont:[[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0]];
    [heightLabel sizeToFit];
    width = heightLabel.frame.size.width;
    [heightLabel setFrame:CGRectMake(xPos, yPos, width, height)];
    [heightView addSubview:heightLabel];
    
    x = heightLabel.frame.origin.x + heightLabel.frame.size.width + 10.0;
    for(int i = 0; i<2; i++){
        xPos = x;
        yPos = 5.0;
        width = (frame.size.width - heightLabel.frame.size.width - 25.0)/2.0;
        height = 30.0;
        UIView *radioView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        radioView.tag = i;
        [radioView setBackgroundColor:[UIColor clearColor]];
        [heightView addSubview:radioView];
        
        xPos = 0.0;
        width = 20.0;
        height = 20.0;
        yPos = (radioView.frame.size.height - height)/2.0;
        UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        outerView.layer.borderColor = [[UIColor whiteColor]CGColor];
        outerView.layer.borderWidth = 1.0;
        outerView.layer.cornerRadius = height/2.0;
        [radioView addSubview:outerView];
        
        width = 8.0;
        height = 8.0;
        yPos = (outerView.frame.size.height - height)/2.0;
        xPos = (outerView.frame.size.width - width)/2.0;
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [innerView setBackgroundColor:[UIColor whiteColor]];
        innerView.layer.cornerRadius = height/2.0;
        [outerView addSubview:innerView];
        
        if (i == 1) {
            [innerView setHidden:YES];
        }
        
        xPos = outerView.frame.origin.x + outerView.frame.size.width + 5.0;
        yPos = 0.0;
        width = radioView.frame.size.width - xPos - 5.0;
        height = radioView.frame.size.height;
        UILabel *radioLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        radioLabel.text = (i == 0) ? @"cms" : @"Feet inches";
        [radioLabel setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
        [radioLabel setTextColor:[UIColor whiteColor]];
        [radioView addSubview:radioLabel];
        
        UITapGestureRecognizer *radioGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(radioButtonTapped:)];
        [radioView addGestureRecognizer:radioGesture];
        
        x = x + radioView.frame.size.width + 5.0;
    }
    
    xPos = 0.0;
    yPos = heightLabel.frame.origin.y + heightLabel.frame.size.height;
    width = heightView.frame.size.width;
    height = 40.0;
    UIView *cmsView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [cmsView setBackgroundColor:[UIColor clearColor]];
    [heightView addSubview:cmsView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = cmsView.frame.size.width - xPos - 100.0;
    height = 40.0;
    UIView *heightTextView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [heightTextView setBackgroundColor:[UIColor whiteColor]];
    heightTextView.layer.cornerRadius = 5.0;
    [heightTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [heightTextView.layer setBorderWidth:0.5];
    [cmsView addSubview:heightTextView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = heightTextView.frame.size.width - 2 * xPos;
    height = heightTextView.frame.size.height;
    self.heightTextfield = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.heightTextfield setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    self.heightTextfield.delegate = self;
    self.heightTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.heightTextfield setTextColor:[UIColor blackColor]];
    [heightTextView addSubview:self.heightTextfield];
    
    xPos = heightTextView.frame.origin.x + heightTextView.frame.size.width + 5.0;
    yPos = 0.0;
    width = heightView.frame.size.width - xPos - 10.0;
    UILabel *heightUnit = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [heightUnit setText:@"cms"];
    heightUnit.textColor = [UIColor whiteColor];
    [heightUnit setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    [cmsView addSubview:heightUnit];
    
    xPos = 0.0;
    yPos = heightLabel.frame.origin.y + heightLabel.frame.size.height;
    width = heightView.frame.size.width;
    height = 40.0;
    UIView *feetInchesView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [feetInchesView setHidden:YES];
    [feetInchesView setBackgroundColor:[UIColor clearColor]];
    [heightView addSubview:feetInchesView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = feetInchesView.frame.size.width/2.0;
    height = feetInchesView.frame.size.height;
    UIView *feetView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [feetView setBackgroundColor:[UIColor clearColor]];
    [feetInchesView addSubview:feetView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = feetView.frame.size.width - xPos - 70.0;
    height = feetView.frame.size.height;
    UIView *feetTextView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [feetTextView setBackgroundColor:[UIColor whiteColor]];
    feetTextView.layer.cornerRadius = 5.0;
    [feetTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [feetTextView.layer setBorderWidth:0.5];
    [feetView addSubview:feetTextView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = feetTextView.frame.size.width - 2 * xPos;
    height = feetTextView.frame.size.height;
    self.feetTextfield = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.feetTextfield setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    self.feetTextfield.delegate = self;
    self.feetTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.feetTextfield setTextColor:[UIColor blackColor]];
    [feetTextView addSubview:self.feetTextfield];
    
    xPos = feetTextView.frame.origin.x + feetTextView.frame.size.width + 5.0;
    yPos = 0.0;
    width = feetView.frame.size.width - xPos - 10.0;
    UILabel *feetUnit = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [feetUnit setText:@"feet"];
    feetUnit.textColor = [UIColor whiteColor];
    [feetUnit setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    [feetView addSubview:feetUnit];
    
    xPos = feetView.frame.size.width;
    yPos = 0.0;
    width = feetInchesView.frame.size.width/2.0;
    height = feetInchesView.frame.size.height;
    UIView *inchesView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [inchesView setBackgroundColor:[UIColor clearColor]];
    [feetInchesView addSubview:inchesView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = inchesView.frame.size.width - xPos - 70.0;
    height = inchesView.frame.size.height;
    UIView *inchesTextView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [inchesTextView setBackgroundColor:[UIColor whiteColor]];
    inchesTextView.layer.cornerRadius = 5.0;
    [inchesTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [inchesTextView.layer setBorderWidth:0.5];
    [inchesView addSubview:inchesTextView];
    
    xPos = 10.0;
    yPos = 0.0;
    width = inchesTextView.frame.size.width - 2 * xPos;
    height = inchesTextView.frame.size.height;
    self.inchesTextfield = [[UITextField alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.inchesTextfield setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    [self.inchesTextfield setTextColor:[UIColor blackColor]];
    self.inchesTextfield.delegate = self;
    self.inchesTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [inchesTextView addSubview:self.inchesTextfield];
    
    xPos = inchesTextView.frame.origin.x + inchesTextView.frame.size.width + 5.0;
    yPos = 0.0;
    width = inchesView.frame.size.width - xPos - 10.0;
    UILabel *inchesUnit = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [inchesUnit setText:@"inches"];
    inchesUnit.textColor = [UIColor whiteColor];
    [inchesUnit setFont:[[Configuration shareConfiguration]hitpaFontWithSize:18.0]];
    [inchesView addSubview:inchesUnit];
    
    xPos = 10.0;
    yPos = heightView.frame.size.height - 1.0;
    width = frame.size.width;
    height = 1.0;
    UIView *heightLineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [heightLineView setBackgroundColor:[UIColor whiteColor]];
    [heightView addSubview:heightLineView];
    
    width = 150.0;
    height = 50.0;
    xPos = (frame.size.width - width)/2.0;
    yPos = heightView.frame.origin.y + heightView.frame.size.height + 20.0;
    UIButton *calculateButton = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [calculateButton setTitle:@"Calculate BMI" forState:UIControlStateNormal];
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculateButton addTarget:self action:@selector(calculateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    calculateButton.titleLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    calculateButton.backgroundColor = [UIColor clearColor];
    calculateButton.layer.cornerRadius = 5.0;
    [calculateButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [bmiScroll addSubview:calculateButton];
    
    xPos = 10.0;
    yPos = calculateButton.frame.origin.y + calculateButton.frame.size.height + 2.0;
    width = frame.size.width - 2 * xPos;
    self.bmiLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.bmiLabel setText:@"Your BMI is "];
    self.bmiLabel.textColor = [UIColor whiteColor];
    [self.bmiLabel setFont:[[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0]];
    [self.bmiLabel setHidden:YES];
    [self.bmiLabel setTextAlignment:NSTextAlignmentCenter];
    [bmiScroll addSubview:self.bmiLabel];
    
    xPos = 10.0;
    yPos = self.bmiLabel.frame.origin.y + self.bmiLabel.frame.size.height + 2.0;
    width = frame.size.width - 2 * xPos;
    height = 210.0;
    self.bmiTable = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.bmiTable setBackgroundColor:[UIColor clearColor]];
    self.bmiTable.layer.cornerRadius = 5.0;
//    [self.bmiTable setHidden:YES];
    [self.bmiTable setHidden:NO];
    [self.bmiTable.layer setMasksToBounds:YES];
    [bmiScroll addSubview:self.bmiTable];
    
    CGFloat y = 0.0;
    for(int i = 0; i < 5; i++) {
        xPos = 0.0;
        yPos = y;
        width = self.bmiTable.frame.size.width;
        height = 40.0;
        UIView *row = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [row setBackgroundColor:[UIColor grayColor]];
        [self.bmiTable addSubview:row];
        
        xPos = 2.0;
        yPos = 0.0;
        width = (row.frame.size.width - 6.0)/2.0;
        height = row.frame.size.height - 2.0;
        UIView *bmiLabelTitleView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [bmiLabelTitleView setBackgroundColor:[UIColor whiteColor]];
        [row addSubview:bmiLabelTitleView];
        
        xPos = 5.0;
        yPos = 0.0;
        width = bmiLabelTitleView.frame.size.width - 2 * xPos;
        height = bmiLabelTitleView.frame.size.height;
        UILabel *bmiLabelTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [bmiLabelTitle setText:[self.bmiLabelTitles objectAtIndex:i]];
        [bmiLabelTitle setFont:(i == 0) ? [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration]hitpaFontWithSize:16.0]];
        [bmiLabelTitle setTextAlignment:NSTextAlignmentCenter];
        [bmiLabelTitleView addSubview:bmiLabelTitle];
        
        xPos = bmiLabelTitleView.frame.origin.x + bmiLabelTitleView.frame.size.width + 2.0;
        yPos = 0.0;
        width = (row.frame.size.width - 6.0)/2.0;
        height = row.frame.size.height - 2.0;
        UIView *bmiLabelValueView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [bmiLabelValueView setBackgroundColor:[UIColor whiteColor]];
        [row addSubview:bmiLabelValueView];
        
        xPos = 5.0;
        yPos = 0.0;
        width = bmiLabelValueView.frame.size.width - 2 * xPos;
        height = bmiLabelValueView.frame.size.height;
        UILabel *bmiLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
        [bmiLabelValue setText:[self.bmiLabelValues objectAtIndex:i]];
        [bmiLabelValue setFont:(i == 0) ? [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0] :  [[Configuration shareConfiguration]hitpaFontWithSize:16.0]];
        [bmiLabelValue setTextAlignment:NSTextAlignmentCenter];
        [bmiLabelValueView addSubview:bmiLabelValue];
        
        y = y + row.frame.size.height;
    }
    
    bmiScroll.contentSize = CGSizeMake(bmiScroll.frame.size.width, y + 5.0);
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
    
}

- (IBAction)radioButtonTapped:(UITapGestureRecognizer *)sender {
    UIView *innerView = [[[sender.view.subviews objectAtIndex:0]subviews]objectAtIndex:0];
    UILabel *selectedUnitLbl = (UILabel *)[sender.view.subviews objectAtIndex:1];
    UIView *otherRadioButton = [[[[[sender.view.superview.subviews objectAtIndex:(sender.view.tag == 0) ? 2 : 1]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
    [otherRadioButton setHidden:YES];
    if(sender.view.superview.tag == 0) {
        UILabel *weightUnit = (UILabel *)[sender.view.superview.subviews objectAtIndex:4];
        [weightUnit setText:selectedUnitLbl.text];
        if(innerView.isHidden) {
            UITextField *weightTextField = (UITextField *)[[[sender.view.superview.subviews objectAtIndex:3]subviews]objectAtIndex:0];
            weightTextField.text = @"";
        }
        self.isKgs = (sender.view.tag == 0) ? YES : NO;
    }else {
        if(sender.view.tag == 0) {
            UIView *cmsView = [sender.view.superview.subviews objectAtIndex:3];
            [cmsView setHidden:NO];
            UIView *feetView = [sender.view.superview.subviews objectAtIndex:4];
            [feetView setHidden:YES];
            UITextField *feetTextField = (UITextField *)[[[[[[[sender.view.superview.subviews objectAtIndex:4]subviews]objectAtIndex:0]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
            feetTextField.text = @"";
            UITextField *inchesTextField = (UITextField *)[[[[[[[sender.view.superview.subviews objectAtIndex:4]subviews]objectAtIndex:1]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
            inchesTextField.text = @"";
            if(innerView.isHidden) {
                UITextField *heightTextField = (UITextField *)[[[[[sender.view.superview.subviews objectAtIndex:3]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
                heightTextField.text = @"";
            }
            self.isCms = YES;
        }else {
            UIView *cmsView = [sender.view.superview.subviews objectAtIndex:3];
            [cmsView setHidden:YES];
            UIView *feetView = [sender.view.superview.subviews objectAtIndex:4];
            [feetView setHidden:NO];
            UITextField *heightTextField = (UITextField *)[[[[[sender.view.superview.subviews objectAtIndex:3]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
            heightTextField.text = @"";
            if(innerView.isHidden) {
                UITextField *feetTextField = (UITextField *)[[[[[[[sender.view.superview.subviews objectAtIndex:4]subviews]objectAtIndex:0]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
                feetTextField.text = @"";
                UITextField *inchesTextField = (UITextField *)[[[[[[[sender.view.superview.subviews objectAtIndex:4]subviews]objectAtIndex:1]subviews]objectAtIndex:0]subviews]objectAtIndex:0];
                inchesTextField.text = @"";
            }
            self.isCms = NO;
        }
    }
    [innerView setHidden:NO];

}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)calculateButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.weightTextfield.text,@"weight",self.heightTextfield.text,@"cms",self.feetTextfield.text,@"feet",self.inchesTextfield.text,@"inches", nil];
    NSArray *error = nil;
    if([[Helper shareHelper]validateBMIWithError:&error parmas:params]) {
        CGFloat weight,height;
        if(!self.isKgs) {
            weight = [self poundsToKgs:self.weightTextfield.text.floatValue];
        }else {
            weight = self.weightTextfield.text.floatValue;
        }
        if(!self.isCms) {
            height = [self feetInchesToMeters:self.feetTextfield.text.floatValue inches:self.inchesTextfield.text.floatValue];
        }else {
            height = self.heightTextfield.text.floatValue/100;
        }
        CGFloat bmiValue = weight / (height * height);
        [self.bmiLabel setHidden:NO];
        self.bmiLabel.text = [NSString stringWithFormat:@"Your BMI is %.2f",bmiValue];
        [self.bmiTable setHidden:NO];
    }else {
        NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
        alertView([[Configuration shareConfiguration] appName], errorMessage, self, @"Ok", nil, 0);
        return;
    }
    
}

- (CGFloat)poundsToKgs:(CGFloat)weight {
    return weight * 0.453592;
}

- (CGFloat)feetInchesToMeters:(CGFloat)feet inches:(CGFloat)inches {
//    return feet * 0.3048 + inches * 0.0254;
    return (feet * 0.3048) + (inches * 0.0254);
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

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    textField.inputAccessoryView = [[KeyboardHelper sharedKeyboardHelper]tollbar:self.view];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
