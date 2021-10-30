//
//  ServicesOfferedViewController.m
//  HITPA
//
//  Created by Sunilkumar Basappa on 25/11/20.
//  Copyright © 2020 Bathi Babu. All rights reserved.
//

#import "ServicesOfferedViewController.h"
#import "Configuration.h"
#import "HomeViewController.h"
#import "Gradients.h"

@interface ServicesOfferedViewController ()

@end

@implementation ServicesOfferedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Services Offered", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self barItems];
    [self serviceOfferedView];
    // Do any additional setup after loading the view from its nib.
}

- (void)serviceOfferedView
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
    xPos    = 0.0;
    yPos    = 100.0;
    width   = frame.size.width;
    height  = (frame.size.height/2) ;
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.view addSubview:aboutView];
    
    //About Label
    xPos   = 10.0;
    yPos   = 5.0;
    width  = aboutView.frame.size.width - 20.0;
    height = aboutView.frame.size.height;
    UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    aboutLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.text = @"Health Insurance TPA of India Ltd.(HITPA) is a joint venture of 4 Public Sector General Insurance Companies – National Insurance Company Limited,The New India Assurance Company Limited,The Oriental Insurance Company Limited,United India Insurance Company Limited and General Insurance Corporation of India.The Company was incorporated on August 14, 2013 with two key objectives - to enhance customer experience and to bring in greater efficiency in health insurance claims processing.Health Insurance TPA is headquartered in New Delhi.\nServices offered:\n- Member id card generation\n- Claim Processing\n- Hospital Network\n- 24*7 Customer care";
    aboutLabel.numberOfLines = 0;
    [aboutLabel sizeToFit];
    aboutLabel.textAlignment = NSTextAlignmentJustified;
    [aboutView addSubview:aboutLabel];
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
    
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

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
