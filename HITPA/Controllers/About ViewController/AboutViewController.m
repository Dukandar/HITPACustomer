//
//  AboutViewController.m
//  HITPA
//
//  Created by Bathi Babu on 04/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "AboutViewController.h"
#import "Configuration.h"
#import "HomeViewController.h"
#import "Gradients.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"About HITPA", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self aboutView];
    [self barItems];
    // Do any additional setup after loading the view from its nib.
}

- (void)aboutView
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
    xPos   = 5.0;
    yPos   = 5.0;
    width  = aboutView.frame.size.width - 10.0;
    height = aboutView.frame.size.height;
    UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    aboutLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.text = @"Health Insurance TPA of India Ltd is a joint venture of public sector Non-life insurance companies –National Insurance Co. Ltd, The Oriental Insurance Co. Ltd, The New India Assurance Co. Ltd, United India Insurance Co. Ltd and GIC of India.\n\nThe Company was incorporated on August 14, 2013 with two key objectives - to enhance customer experience and to bring in greater efficiency in health insurance claims processing. Health Insurance TPA is headquartered in New Delhi and shall develop its footprint/branches in different cities in due course.";
    aboutLabel.numberOfLines = 0;
    [aboutLabel sizeToFit];
    aboutLabel.textAlignment = NSTextAlignmentJustified;
    [aboutView addSubview:aboutLabel];
    
    NSString *date=[NSDateFormatter localizedStringFromDate:[NSDate date]
                                                  dateStyle:NSDateFormatterLongStyle
                                                  timeStyle:NSDateFormatterNoStyle];
//    NSString *strtime=[NSString stringWithFormat:@"Version %@\n\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],date];  //Build
    NSString *strtime=[NSString stringWithFormat:@"Version %@\n\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],date]; 
    
    //version label
    yPos   = aboutLabel.frame.origin.y + aboutLabel.frame.size.height + 120.0;
    width  = 160.0;
    height = 80.0;
    xPos   = frame.size.width - width + 30.0;
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    versionLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    versionLabel.text = strtime;
    versionLabel.numberOfLines = 0;
    versionLabel.textColor = [UIColor whiteColor];
    [versionLabel sizeToFit];
    [self.view addSubview:versionLabel];
    
    //icon image view
    xPos   = 10.0;
    width  = 40.0 ;
    height = 30.0;
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    iconImageView.image = [UIImage imageNamed:@"icon_hitpalogo"];
    [self.view addSubview:iconImageView];
    
    //title Name
    xPos   = iconImageView.frame.origin.x + iconImageView.frame.size.width + 6.0;
    width  = 80.0 ;
    UILabel *appName = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    appName.text = [[Configuration shareConfiguration]appName];
    appName.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    appName.textColor = [UIColor whiteColor];
    [self.view addSubview:appName];
    
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
    return [[UIScreen mainScreen] bounds];
    
}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
