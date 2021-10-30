//
//  BaseViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/3/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "BaseViewController.h"
#import "UIManager.h"
#import "Configuration.h"
#import "Gradients.h"

@interface BaseViewController ()<UITableViewDataSource,UITableViewDelegate>
  
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation BaseViewController


#pragma mark  - instancetype
- (instancetype)init
{
    self = [super initWithNibName:@"BaseViewController" bundle:nil];
    if (self)
    {
        
        
    }
    
    
    return self;
    
    
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    CAGradientLayer *topGradient = [[Gradients shareGradients] background];
//    topGradient.frame = [self bounds];
//    [self.view.layer insertSublayer:topGradient atIndex:0];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.appDelegate = (HITPAAppDelegate *)[UIApplication sharedApplication].delegate;
    //self.revealController = [self revealViewController];
    //[self.revealController panGestureRecognizer];
    
    [self statusBarAndNavigationBar];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)statusBarAndNavigationBar
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = 20.0;
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusBar.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:statusBar];
    
    [self barItems];
    
}

#pragma BarItems
- (void)barItems
{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navigation.png"] forBarMetrics:UIBarMetricsDefault];
   // self.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[[Configuration shareConfiguration] hitpaFontWithSize:20.0]}];
    
    UIImage *buttonImage = [UIImage imageNamed:@"icon_back_arrow.png"];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    aButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    
    UIBarButtonItem *aLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    [aButton addTarget:self action:@selector(leftBackBarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setLeftBarButtonItem:aLeftBarButtonItem];
    
//    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
}

- (IBAction)rightBarButtonTapped:(id)sender
{
    
    
}


- (void)reloadTableView
{
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
    
    
}

#pragma mark - tableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"Identifier";
    
    
    UITableViewCell *cell;
    if (cell == nil)
    {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    
    
    return cell;
    
    
}

- (void)rightBarBackButton
{
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackBarButtonTapped:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}


- (IBAction)leftBackBarButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (CGRect)bounds
{
    
    
    return [[UIScreen mainScreen] bounds];
    
    
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
    
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
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
