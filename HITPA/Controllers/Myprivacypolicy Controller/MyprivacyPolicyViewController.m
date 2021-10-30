//
//  MyprivacyPolicyViewController.m
//  HITPA
//
//  Created by Bathi Babu on 04/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "MyprivacyPolicyViewController.h"
#import "Configuration.h"
#import "HITPAAppDelegate.h"
#import "HomeViewController.h"
#import "Gradients.h"

@interface MyprivacyPolicyViewController ()

@property (nonatomic, strong)   UILabel *   policyLabel;

@end

@implementation MyprivacyPolicyViewController
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Privacy Policy", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self privacyView];
    [self barItems];
    // Do any additional setup after loading the view from its nib.
}

- (void)privacyView
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    //Line
    xPos  = 0.0;
    yPos  = 100.0;
    width = frame.size.width;
    height = 1.0;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    lineView.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:lineView];
    
    //view
    xPos  = 0.0;
    yPos  = 100.0;
    width = frame.size.width;
    height = (frame.size.height/3) + 26.0 ;
    UIView *policyView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.view addSubview:policyView];
    
    //privacy label
    xPos   = 6.0;
    yPos   = 6.0;
    width  = policyView.frame.size.width - 12.0;
    height = policyView.frame.size.height/2;
    self.policyLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    NSString *privacyPolicyStr = @"Using this may require transmission of data and involve sending of local information.The features may not always be available or accurate. \n\nBy Starting the app you agree to the  Privacy Policy\n\nCheck the phone settings for controls.";
    self.policyLabel.textColor = [UIColor whiteColor];
    
    NSMutableAttributedString *attributtedString=[[NSMutableAttributedString alloc]initWithString:privacyPolicyStr];
    [attributtedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14.0f] range:NSMakeRange(0, attributtedString.length)];
    [attributtedString addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (179, 14)];
    [attributtedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(179, 14)];
    [self.policyLabel setAttributedText:attributtedString];
    
    self.policyLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    self.policyLabel.numberOfLines = 0;
    [self.policyLabel sizeToFit];
    self.policyLabel.textAlignment = NSTextAlignmentJustified;
    [policyView addSubview:self.policyLabel];
    self.policyLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *privacyPolicyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyPolicyGestureTapped:)];
    [self.policyLabel addGestureRecognizer:privacyPolicyGesture];

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
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Guesture
- (void)privacyPolicyGestureTapped:(UITapGestureRecognizer *)tapGesture
{
    CGPoint touchPoint = [tapGesture locationInView:self.policyLabel];
    CGRect validFrame = CGRectMake(244, 75, 91.0, 20);      
    if (YES == CGRectContainsPoint(validFrame, touchPoint))
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://223.30.163.104:91/Home/HITPAPolicyDocx"]];
    }
}

#pragma mark - didReceiveMemoryWarning
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
