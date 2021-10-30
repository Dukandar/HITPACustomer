//
//  WellnessTipViewController.m
//  HITPA
//
//  Created by Sunilkumar Basappa on 25/11/20.
//  Copyright © 2020 Bathi Babu. All rights reserved.
//

#import "WellnessTipViewController.h"
#import "Configuration.h"
#import "Gradients.h"
#import "HomeViewController.h"
#import "HITPAAPI.h"
#import "MBProgressHUD.h"
#import "FTPHelper.h"
#import "DocumentDirectory.h"
#import "ImagePreviewViewController.h"

@interface WellnessTipViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,FTPHelperDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   MBProgressHUD   *   progressHUD;
@property (nonatomic,strong)  NSArray * wellnessTips;
@property (nonatomic,strong)  NSString * selectedFile;
@end

@implementation WellnessTipViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Wellness Tip", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self barItems];
    //[self wellnessTipsView];
    [self showHUDWithMessage:@""];
    [[HITPAAPI shareAPI] getWellnessTipWithCompletionHandler:^(NSDictionary *response, NSError *error) {
        [self didReceiveWellnessTipsResponse:response error:error];
    }];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Handler
- (void)didReceiveWellnessTipsResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    self.wellnessTips =[NSJSONSerialization JSONObjectWithData:[[response valueForKey:@"responseID"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    if([self.wellnessTips count] > 0 ){
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
    }
}
- (void)wellnessTipsView
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

    //scrollView
    xPos    = 0.0;
    yPos    = 100.0;
    width   = frame.size.width;
    height  = frame.size.height - 20.0;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(frame.size.width, 980.0);
    
    
    //view
    xPos    = 0.0;
    yPos    = 0.0;
    width   = scrollView.frame.size.width;
    height  = scrollView.frame.size.height;
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [scrollView addSubview:aboutView];
    
    //About Label
    xPos   = 10.0;
    yPos   = 5.0;
    width  = aboutView.frame.size.width - 20.0;
    height = aboutView.frame.size.height;
    UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    aboutLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:14.0];
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.text = @"Drink plenty of water. Not only is it good for your internal organs, it also keeps your skin healthy and lessens acne. \n▸ Divide your weight (in pounds) by two. This gives the daily ounce-recommendation of water.\n▸ Opt for fresh, seasonal and local produce over packaged food items\n▸ Wake up early to practice simple meditation. It harmonizes body, mind and soul.\n▸ Exercise at least four days a week for 20 to 30 minutes each day. If it’s all not possible at a go, break your workouts into smaller sessions.\n▸Try to get as much physical activity as you can. Skip the elevator and take the stairs, walk to your office instead of taking the elevator.\n▸If exercising alone bores you out, hook up with a partner or friend who is committed to exercise. The fun factor will also let you stay committed.\n▸Exercise also works as an outlet for pent up stress. So keep exercising, especially when you’ve got work bearing down on you.\n▸If you’re on medication for an illness, kindly ensure that you do not miss any dose and complete the full course as advised by your Physician\n▸Make friends with your family physician. Get regular check-ups done.\n▸Try to get all your nutrition from the food you eat. If you aren’t getting it though, multivitamins and nutritional supplements are a good option.\n▸Get your vitamin D from the sun. But also stay UV-protected.\nExercise at least four days a week for 20 to 30 minutes each day. If it’s all not possible at a go, break your workouts into smaller sessions.\n▸Try to get as much physical activity as you can. Skip the elevator and take the stairs, walk to your office instead of taking the elevator.\n▸If exercising alone bores you out, hook up with a partner or friend who is committed to exercise. The fun factor will also let you stay committed.\n▸Exercise also works as an outlet for pent up stress. So keep exercising, especially when you’ve got work bearing down on you.\n▸If you’re on medication for an illness, kindly ensure that you do not miss any dose and complete the full course as advised by your Physician\n▸ Make friends with your family physician. Get regular check-ups done.\n▸Try to get all your nutrition from the food you eat. If you aren’t getting it though, multivitamins and nutritional supplements are a good option.\n▸Get your vitamin D from the sun. But also stay UV-protected.";
    aboutLabel.numberOfLines = 0;
    [aboutLabel sizeToFit];
    aboutLabel.textAlignment = NSTextAlignmentJustified;
    [aboutView addSubview:aboutLabel];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark - Table View datasource and delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return  sectionFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( [self.wellnessTips isKindOfClass:[NSArray class]]) ? self.wellnessTips.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.wellnessTips objectAtIndex:indexPath.row];
    CGFloat height = [self getHeightWithText:[dictionary valueForKey:@"WellNessTip"] font:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    return height + 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    NSDictionary *dictionary = [self.wellnessTips objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary valueForKey:@"WellNessTip"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel sizeToFit];
    
    cell.detailTextLabel.text = [dictionary valueForKey:@"CreatedDate"];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    
    CGFloat height = [self getHeightWithText:[dictionary valueForKey:@"WellNessTip"] font:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    NSString * filePath = [dictionary valueForKey:@"Filepath"];
    //Add download Image
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat imageViewWidthHeight = 34.0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - (imageViewWidthHeight + 1.5)), height - 4.0, imageViewWidthHeight, imageViewWidthHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"icon_download.png"]];
    [view addSubview:imageView];
    [view setHidden:(filePath.length> 0 ? FALSE : TRUE)];
    [cell addSubview:view];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = [self.wellnessTips objectAtIndex:indexPath.row];
    NSString * filePath = [dictionary valueForKey:@"Filepath"];
    if (filePath.length > 0){
        [self downloadMediaWithPath:filePath];
    }
}

#pragma mark Download file
- (void)downloadMediaWithPath:(NSString *)filePath {
    [self showHUDWithMessage:@""];
    self.selectedFile = filePath;//mediaPath;
    NSString *hostName = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] downlaodFtpHostName], @"WellnessTIP/"];
    [FTPHelper sharedInstance].delegate = self;
    [FTPHelper sharedInstance].uname = [[Configuration shareConfiguration] ftpUserName];
    [FTPHelper sharedInstance].pword = [[Configuration shareConfiguration] ftpPassword];
//    [FTPHelper sharedInstance].urlString = [[Configuration shareConfiguration] ftpHostName];
    [FTPHelper sharedInstance].urlString = hostName;
    [FTPHelper download:self.selectedFile destinationPath:[[DocumentDirectory shareDocumentDirectory]saveWellnessTipsFile]];
}


- (void)dataDownloadFailed:(NSString *)reason{
    [self hideHUD];
}
- (void)downloadFinished{
     [self hideHUD];
    if(self.selectedFile.length > 0){
        
        ImagePreviewViewController *vctr = [[ImagePreviewViewController alloc]initWithNibName:@"ImagePreviewViewController" bundle:nil];
        vctr.imagePath = [[DocumentDirectory shareDocumentDirectory] getImageFormDirectotyWithPath:self.selectedFile];
        [self.navigationController pushViewController:vctr animated:YES];
        
    }
}


- (CGFloat )getHeightWithText:(NSString *)text font:(UIFont *)font
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    CGFloat xPos = 10.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width - 20.0;
    CGFloat height = 20.0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [label setText:text];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    return label.frame.size.height;
    
}

@end
