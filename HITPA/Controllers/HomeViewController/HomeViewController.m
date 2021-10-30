//
//  homeViewController.m
//  HITPA
//
//  Created by Bathi Babu on 01/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "Configuration.h"
#import "Gradients.h"
#import "ClaimsViewController.h"
#import "QuickConnectViewController.h"
#import "HospitalSearchController.h"
#import "MyPolicyViewController.h"
#import "GrievanceViewController.h"
#import "UpdatesViewController.h"
#import "QuickGuideController.h"
#import "Utility.h"
#import "UIManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
#import "HITPAUserDefaults.h"
#import "LoginViewController.h"

CGFloat     const headerWidt            = 260.0;
CGFloat     const headerheigh           = 240.0;
CGFloat     const headerImageWidt       = 80.0;
CGFloat     const headerImageHeigh      = 80.0;
CGFloat     const headerSectionHeigh    = 60.0;
NSInteger   const menuCoun              = 8;
NSInteger   const subMenuCoun           = 6;

NSInteger      const mypolicyTag                = 1001;
NSInteger      const updatesTag                 = 1002;
NSInteger      const quickConnectTag            = 1003;
NSInteger      const quickguideTag              = 1004;
NSInteger      const griveanceTag               = 1005;
NSInteger      const hospitalsearchTag          = 1006;
NSInteger      const claimsTag                  = 1007;
NSInteger      const kUserNameTag               = 12345;
int page;


typedef enum {
    BMICalculator,
    Calendar,
    Aboutinube,
    Abouthitpa,
    ServicesOffered,
    MedReminder,
    WellnessTip,
    LogoutHitpa,
}menu;

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat xScale;
    UIView *full, *menuHeaderView;
    UITableView *menuTableView;
}
@property (nonatomic , strong) UIScrollView *imageScroll;
@property (nonatomic, readwrite) NSInteger currentPage;
@property (nonatomic , strong) UIPageControl *page;

@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.revealController = [self revealViewController];
    //[self.revealViewController panGestureRecognizer];
    [self homeList];
    UISwipeGestureRecognizer *leftToRightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [leftToRightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:leftToRightSwipe];
    
    UISwipeGestureRecognizer *rightToLeftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [rightToLeftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:rightToLeftSwipe];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(pushtoNextimage:) userInfo:nil repeats:YES];
    
    //Do any additional setup after loading the view from its nib.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}


-(void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    CGRect frame = [self bounds];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
       
        UIView *profileView = full;
        CGRect newProfile =  [full frame];
        UIView *menuProfile = menuHeaderView;
        CGRect newMenu = [menuHeaderView frame];
        
        newMenu.origin.x = 0;
        [UIView animateWithDuration:0.5 animations:^(void){
            menuHeaderView.frame = newMenu;

        }];
        
        //Remove LoginViewController from HomeViewController whenever User Swipe Mune Option in Right Side
       
        for(UIViewController *loginVC in [self.navigationController viewControllers])
        {
            if([loginVC isKindOfClass:[LoginViewController class]])
            {
                [loginVC removeFromParentViewController];
                NSLog(@"LoginViewController");
            }
        }
        
//                self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
//                    (vc.isKind(of: HomeViewController.self)) ? false : true
//                })
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.view layoutIfNeeded];
//                             if (full.transform.a == xScale) {
//
//
//
//                             }else{
//
//                                 UIView *profileView = full;
//                                 CGRect newProfile =  [full frame];
//                                 UIView *menuProfile = menuHeaderView;
//                                 CGRect newMenu = [menuHeaderView frame];
//
//                                 //newProfile.origin.x = [self bounds].size.width/2;
//                                 newMenu.origin.x = - 20.0;
//                                 [UIView animateWithDuration:0.5 animations:^(void){
//                                     //profileView.frame = newProfile;
//                                     menuProfile.frame = newMenu;
//
//                                 }];
//
//                                 [UIView animateWithDuration:0.5
//                                                  animations:^{
//                                                      //full.transform = CGAffineTransformMakeScale(0.7, 0.7);
//                                                      menuHeaderView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//                                                      //xScale = full.transform.a;
//
//
//                                                  }
//                                                  completion:^(BOOL finished) {
//
//
//                                                  }];
//
//                             }
//
//                         }];
        
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        
        UIView *profileView = full;
        CGRect newProfile =  [full frame];
        UIView *menuProfile = menuHeaderView;
        CGRect newMenu = [menuHeaderView frame];
        
        newMenu.origin.x = - [self bounds].size.width;
        [UIView animateWithDuration:0.5 animations:^(void){
            menuHeaderView.frame = newMenu;
            
        }];
        
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.view layoutIfNeeded];
//                             if (full.transform.a == xScale) {
//
//                                 UIView *profileView = full;
//                                 CGRect newProfile =  [full frame];
//                                 UIView *menuProfile = menuHeaderView;
//                                 CGRect newMenu = [menuHeaderView frame];
//
//                                 //newProfile.origin.x = frame.size.width > 320? 56.0:48.0;
//                                 newMenu.origin.x = - [self bounds].size.width;
//                                 [UIView animateWithDuration:0.5 animations:^(void){
//                                     //profileView.frame = newProfile;
//                                     menuProfile.frame = newMenu;
//
//                                 }];
//
//                                 [UIView animateWithDuration:0.5
//                                                  animations:^{
//                                                      //full.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                                                      menuHeaderView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                                                  }
//                                                  completion:^(BOOL finished) {
//
//
//                                                  }];
//
//                             }else{
//
//
//
//                             }
//
//            }];
        
    }
    
}

- (void)homeList
{
    
    CGRect frame = [self bounds];
    CGFloat xpos,ypos,width,height;
    
    UIView *backGround = [self createviewwithframe:frame];
    CAGradientLayer *gradient1 = [[Gradients shareGradients]background];
    gradient1.frame = backGround.bounds;
    [backGround.layer insertSublayer:gradient1 atIndex:0];
    [self.view addSubview:backGround];
    
    full = [self createviewwithframe:frame];
    [self.view addSubview:full];
    
    //top black view
    xpos   =  0.0;
    ypos   =  0.0;
    width  =  frame.size.width;
    height =  20.0;
    UIView * statusBar= [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    statusBar.backgroundColor = [UIColor clearColor];
    [full addSubview:statusBar];
    
    // Top sliding bar view
    xpos   = 0.0;
    ypos   = 0.0;
    width  = frame.size.width;
    height = (frame.size.height/2.5) - 32.0;
    UIView *topView = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    topView.backgroundColor = [UIColor darkGrayColor];
    [full addSubview:topView];
    
    //image scroller
    height = topView.frame.size.height;
    self.imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(xpos, 0.0, width, height )];
    self.imageScroll.delegate = self;
    self.imageScroll.userInteractionEnabled = YES;
    self.imageScroll.pagingEnabled = YES;
    self.imageScroll.tag=homeScrollviewtag;
    NSArray *imageNames = @[@"slider1.png",@"slider5.png",@"slider7.png",@"slider9.png"];
    for (int i = 0; i<[imageNames count]; i++)
    {
        UIImageView *imageScroller = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, 0.0, width, self.imageScroll.frame.size.height)];
        imageScroller.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageNames objectAtIndex:i]]];
        [self.imageScroll addSubview:imageScroller];
        xpos = self.imageScroll.frame.size.width + xpos;
    }
    
    self.imageScroll.contentSize = CGSizeMake(xpos, topView.frame.size.height);
    self.imageScroll.alwaysBounceVertical = NO;
    self.imageScroll.scrollEnabled = YES;
    self.imageScroll.scrollsToTop = NO;
    self.imageScroll.bounces = NO;
    self.imageScroll.showsHorizontalScrollIndicator = NO;
    self.imageScroll.showsVerticalScrollIndicator = NO;
    [topView addSubview:self.imageScroll];
    
    
    // full view for all tiles
    xpos    = 0.0;
    ypos    = topView.frame.origin.y + topView.frame.size.height ;
    width   = frame.size.width;
    height  =  frame.size.height - (topView.frame.size.height );
    UIView * fullView = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    fullView.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    [full addSubview:fullView];
    
    // Mypolicy View
    xpos   = 4.0;
    ypos   = 4.0;
    width  = ((fullView.frame.size.width - 12.0)/1.5) + 2.0;
    height = ((fullView.frame.size.height)/3) - 5.5;
    UIView *myPolicy = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *gradient = [[Gradients shareGradients]myPolicy];
    gradient.frame = myPolicy.bounds;
    [myPolicy.layer insertSublayer:gradient atIndex:0];
    [fullView addSubview:myPolicy];
    
    
    //updates view
    xpos   =  myPolicy.frame.origin.x + myPolicy.frame.size.width + 4.0;
    ypos   =  4.0;
    width  =  (fullView.frame.size.width - myPolicy.frame.size.width) - 12.0;
    UIView *updates = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *updatesGradient = [[Gradients shareGradients]Updates];
    updatesGradient.frame = updates.bounds;
    [updates.layer insertSublayer:updatesGradient atIndex:0];
    [fullView addSubview:updates];
    
    //QuickConnect view
    xpos   = 4.0;
    ypos   = myPolicy.frame.origin.y + myPolicy.frame.size.height + 4.0;
    width  = ((fullView.frame.size.width - 16.0)/3) ;
    UIView *quickConnect = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *quickconnectGradient =[[Gradients shareGradients]quickConnect];
    quickconnectGradient.frame = quickConnect.bounds;
    [quickConnect.layer insertSublayer:quickconnectGradient atIndex:0];
    [fullView addSubview:quickConnect];
    
    //Quick Guide view
    xpos   = quickConnect.frame.origin.x  + quickConnect.frame.size.width + 4.0 ;
    width  = ((fullView.frame.size.width - 16.0)/3);
    UIView *quickGuide = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *quickguideGradient = [[Gradients shareGradients]quickGuide];
    quickguideGradient.frame = quickGuide.bounds;
    [quickGuide.layer insertSublayer:quickguideGradient atIndex:0];
    [fullView addSubview:quickGuide];
    
    //Grivance view
    xpos = quickGuide.frame.origin.x + quickGuide.frame.size.width + 4.0;
    UIView *griVance = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *grivenceGradient = [[Gradients shareGradients]grivence];
    grivenceGradient.frame = griVance.bounds;
    [griVance.layer insertSublayer:grivenceGradient atIndex:0];
    [fullView addSubview:griVance];
    
    //Hospital serch view
    xpos  = 4.0;
    ypos  = quickGuide.frame.origin.y + quickGuide.frame.size.height + 4.0;
    width = myPolicy.frame.size.width ;
    UIView *hospitalSearch = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *hospitalGradient = [[Gradients shareGradients]hospitalSearch];
    hospitalGradient.frame = hospitalSearch.bounds;
    [hospitalSearch.layer insertSublayer:hospitalGradient atIndex:0];
    [fullView addSubview:hospitalSearch];
    
    //Claims Junction
    xpos  = hospitalSearch.frame.origin.x + hospitalSearch.frame.size.width + 4.0 ;
    width =  quickGuide.frame.size.width;
    UIView * claimsJunction = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *claimsGradient = [[Gradients shareGradients]claimsJunction];
    claimsGradient.frame = claimsJunction.bounds;
    [claimsJunction.layer insertSublayer:claimsGradient atIndex:0];
    [fullView addSubview:claimsJunction];
    
    
    //My policy label
    xpos    =  myPolicy.frame.origin.x ;
    ypos    =  0.0;
    width   =  myPolicy.frame.size.width;
    height  =  (myPolicy.frame.size.height)/4;
    UILabel *policy = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    policy.textAlignment = NSTextAlignmentCenter;
    policy.text =NSLocalizedString(homepolicy, nil);
    policy.textColor = [UIColor whiteColor];
    policy.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [myPolicy addSubview:policy];
    
    //updates label
    xpos   = 0.0;
    width  = updates.frame.size.width;
    height = (updates.frame.size.height)/3;
    UILabel *updatesTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    updatesTitle.textAlignment = NSTextAlignmentCenter;
    updatesTitle.text = NSLocalizedString(homeUpdates, nil);
    updatesTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    updatesTitle.textColor = [UIColor whiteColor];
    updatesTitle.numberOfLines = 0;
    [updates addSubview:updatesTitle];
    
    //Quick connect label
    xpos   = quickConnect.frame.origin.x - 3.0;
    width  = quickConnect.frame.size.width;
    height = (quickConnect.frame.size.height)/3;
    UILabel *quickconnectTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    quickconnectTitle.text = NSLocalizedString(homeQuickconnect, nil);
    quickconnectTitle.textColor = [UIColor whiteColor];
    quickconnectTitle.textAlignment = NSTextAlignmentCenter;
    quickconnectTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    quickconnectTitle.lineBreakMode = NSLineBreakByWordWrapping;
    quickconnectTitle.numberOfLines = 3;
    CGSize maxiSizeconnect = CGSizeMake(width, CGFLOAT_MAX);
    CGSize reuSizeconnect  = [quickconnectTitle sizeThatFits:maxiSizeconnect];
    xpos = (claimsJunction.frame.size.width - reuSizeconnect.width)/2;
    quickconnectTitle.frame = CGRectMake(xpos, ypos, reuSizeconnect.width,reuSizeconnect.height);
    
    [quickConnect addSubview:quickconnectTitle];
    
    //quick guide label
    xpos   = 0.0;
    width  = quickGuide.frame.size.width;
    height = (quickGuide.frame.size.height)/3;
    UILabel *quickguideTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    quickguideTitle.textAlignment = NSTextAlignmentCenter;
    quickguideTitle.text = NSLocalizedString(homeQuickguide, nil);
    quickguideTitle.textColor = [UIColor whiteColor];
    quickguideTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    quickguideTitle.lineBreakMode = NSLineBreakByWordWrapping;
    quickguideTitle.numberOfLines = 3;
    CGSize maxiSizeguide = CGSizeMake(width, CGFLOAT_MAX);
    CGSize reuSizeguide  = [quickguideTitle sizeThatFits:maxiSizeguide];
    xpos = (claimsJunction.frame.size.width - reuSizeguide.width)/2;
    quickguideTitle.frame = CGRectMake(xpos, ypos, reuSizeguide.width,reuSizeguide.height);
    
    [quickGuide addSubview:quickguideTitle];
    
    //Griveance label
    
    xpos   = 0.0;
    width  = griVance.frame.size.width;
    height = (griVance.frame.size.height)/3;
    UILabel *griveanceTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    griveanceTitle.textAlignment = NSTextAlignmentCenter;
    griveanceTitle.text = NSLocalizedString(homeGriveance, nil);
    griveanceTitle.textColor = [UIColor whiteColor];
    griveanceTitle.numberOfLines = 0;
    griveanceTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [griVance addSubview:griveanceTitle];
    
    //HOSPITALSEARCH label
    
    xpos   = hospitalSearch.frame.origin.x;
    width  = hospitalSearch.frame.size.width;
    height = (griVance.frame.size.height)/4;
    UILabel *hospitalsearchTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    hospitalsearchTitle.textAlignment = NSTextAlignmentCenter;
    hospitalsearchTitle.text = NSLocalizedString(homeHospitalsearch, nil);
    hospitalsearchTitle.textColor = [UIColor whiteColor];
    hospitalsearchTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    [hospitalSearch addSubview:hospitalsearchTitle];
    
    //Claims Junctio label
    
    xpos   = 0.0;
    width  = claimsJunction.frame.size.width;
    height = (claimsJunction.frame.size.height)/3;
    UILabel *claimsjunctionTitle = [self createlabelwithframe:CGRectMake(xpos, ypos, width, height)];
    claimsjunctionTitle.textAlignment = NSTextAlignmentCenter;
    claimsjunctionTitle.text = NSLocalizedString(homeClaimsjunction, nil);
    claimsjunctionTitle.textColor = [UIColor whiteColor];
    claimsjunctionTitle.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:14.0];
    claimsjunctionTitle.numberOfLines = 4;
    CGSize maxiSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize rquSize  = [claimsjunctionTitle sizeThatFits:maxiSize];
    xpos = (claimsJunction.frame.size.width - rquSize.width)/2;
    claimsjunctionTitle.frame = CGRectMake(xpos, ypos, rquSize.width,rquSize.height);
    [claimsJunction addSubview:claimsjunctionTitle];
    
    // Page control
    ypos   = topView.frame.size.height - 22.0;
    width  = 50.0;
    height = 20.0;
    xpos   = (topView.frame.size.width - width)/2 ;
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(xpos, ypos, width, height)];
    self.page.numberOfPages = [imageNames count];
    self.page.tintColor = [UIColor whiteColor];
    [topView addSubview:self.page];
    
    // Menu button
    xpos   = 10.0 ;
    width  = 30.0 ;
    height = 25.0;
    ypos   = (statusBar.frame.size.height + height/2.5) ;
    UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, ypos, width, height)];
    menuView.image = [UIImage imageNamed:homeMenu];
    menuView.image = [[UIImage imageNamed:homeMenu] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    menuView.tintColor = [UIColor whiteColor];
    [full addSubview:menuView];
    
    //Menu button
    
    xpos = 0.0;
    ypos = 0.0;
    width = 50.0;
    height = statusBar.frame.size.height * 5;
    UIButton *menuBtn = [self createbuttonwithframe:CGRectMake(xpos, ypos, width, height)];
    [menuBtn addTarget:self action:@selector(menuBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [full addSubview:menuBtn];
    
    //mypolicy image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *mypolicyImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    mypolicyImage.image = [UIImage imageNamed:homePolicy];
    [myPolicy addSubview:mypolicyImage];
    
    //updates image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *updatesImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    updatesImage.image = [UIImage imageNamed:homeupdates];
    [updates addSubview:updatesImage];
    
    //quickconnect image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *quickconnectImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    quickconnectImage.image = [UIImage imageNamed:homeconnect];
    [quickConnect addSubview:quickconnectImage];
    
    //quickguide image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *quickguideImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    quickguideImage.image = [UIImage imageNamed:homeguide];
    [quickGuide addSubview:quickguideImage];
    
    //grievance image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *grievanceImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    grievanceImage.image = [UIImage imageNamed:homegrivence];
    [griVance addSubview:grievanceImage];
    
    //hospital image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *hospitalImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    hospitalImage.image = [UIImage imageNamed:homehospital];
    [hospitalSearch addSubview:hospitalImage];
    
    //claim Junction image
    
    xpos   = 8.0;
    ypos   = myPolicy.frame.size.height - 40.0;
    width  = 30.0;
    height = 30.0;
    UIImageView *claimImage = [self createimageviewwithframe:CGRectMake(xpos, ypos, width, height)];
    claimImage.image = [UIImage imageNamed:homeclaims];
    [claimsJunction addSubview:claimImage];
    
    
    
    // setting gestures for views
    myPolicy.tag = mypolicyTag;
    UITapGestureRecognizer *tapMypolicy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMyPolicy:)];
    [myPolicy addGestureRecognizer:tapMypolicy];
    
    updates.tag = updatesTag;
    UITapGestureRecognizer *tapUpdates = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUpdates:)];
    [updates addGestureRecognizer:tapUpdates];
    
    quickConnect.tag = quickConnectTag;
    UITapGestureRecognizer *tapQuickConnect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuickConnect:)];
    [quickConnect addGestureRecognizer:tapQuickConnect];
    
    quickGuide.tag = quickguideTag;
    UITapGestureRecognizer *tapQuickGuide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuickGuide:)];
    [quickGuide addGestureRecognizer:tapQuickGuide];
    
    griVance.tag = griveanceTag;
    UITapGestureRecognizer *tapGriveance = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGrievance:)];
    [griVance addGestureRecognizer:tapGriveance];
    
    hospitalSearch.tag = hospitalsearchTag;
    UITapGestureRecognizer *tapHospitalSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHospitalSearch:)];
    [hospitalSearch addGestureRecognizer:tapHospitalSearch];
    
    claimsJunction.tag = claimsTag;
    UITapGestureRecognizer *tapClaimsJunction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClaimJunction:)];
    [claimsJunction addGestureRecognizer:tapClaimsJunction];
    
    xpos = - (full.frame.size.width);
    ypos = 0.0;
    width = frame.size.width; //frame.size.width - 80.0;
    height = frame.size.height;
    menuHeaderView = [[UIView alloc]initWithFrame:CGRectMake(xpos, ypos, width, height)];
    menuHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:menuHeaderView];
    
    xpos = 0;
    ypos = 0.0;
    width = frame.size.width - 80.0; //frame.size.width - 80.0;
    height = frame.size.height;
    UIView *menuNavigationView = [[UIView alloc]initWithFrame:CGRectMake(xpos, ypos, width, height)];
    CAGradientLayer *menuGradient = [[Gradients shareGradients]background];
    menuGradient.frame = menuNavigationView.bounds;
    [menuNavigationView.layer insertSublayer:menuGradient atIndex:0];
    [menuHeaderView addSubview:menuNavigationView];
    
    //imageView
    xpos = (menuNavigationView.frame.size.width - headerImageWidt)/2;
//    ypos = 20.0;
     ypos = 40.0;      //Menu Profile Image gap
    ypos = 100.0;
    width = headerImageWidt;
    height = headerImageHeigh;
    UIImageView *imageView = [self createImageViewWithFrame:CGRectMake(xpos, ypos, width, height)];
    imageView.image = [UIImage imageNamed:@"icon_userprofile"];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
    [menuNavigationView addSubview:imageView];
    
    //labelUsername
    xpos = 0.0;
    ypos = imageView.frame.size.height + imageView.frame.origin.y;
    width = menuNavigationView.frame.size.width;
    height = 60.0;
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(xpos, ypos, width, height)];
    [userName setFont:[[Configuration shareConfiguration] hitpaFontWithSize:20.0]];
    
    NSString *strUsername = [[HITPAUserDefaults shareUserDefaluts] valueForKey:@"username"];
    NSString *userNameString = [strUsername capitalizedString];
    
    [userName setText:userNameString];
    userName.textColor = [UIColor whiteColor];
    userName.tag = kUserNameTag;
    userName.textAlignment = NSTextAlignmentCenter;
    [menuNavigationView addSubview:userName];
    
    xpos = 15.0;
    ypos = userName.frame.size.height + userName.frame.origin.y;
    width = menuNavigationView.frame.size.width - 2 * xpos;
    height = 2.0;
    UIView *lineView = [self createviewwithframe:CGRectMake(xpos, ypos, width, height)];
    lineView.backgroundColor = [UIColor whiteColor];
    [menuNavigationView addSubview:lineView];
    
    xpos = 0.0;
    ypos = lineView.frame.size.height + lineView.frame.origin.y + 5.0;
    width = menuNavigationView.frame.size.width;
    height = [self bounds].size.height - headerheigh;
    menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(xpos, ypos, width, height)];
    menuTableView.backgroundColor = [UIColor clearColor];
    menuTableView.separatorColor = [UIColor clearColor];
    menuTableView.tableFooterView = [UIView new];
    [menuNavigationView addSubview:menuTableView];
    [self reloadTableView];
    
}

- (void)reloadTableView
{
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    [menuTableView reloadData];
}

- (NSString *)headerTitleWithMenuType:(menu)menuType
{
    
    NSString *string = nil;
    
    switch (menuType) {
        case BMICalculator:
            string = @"BMI Calculator";
            break;
        case Calendar:
            string = @"Calendar";
            break;
        case Aboutinube:
            string = @"About HITPA";
            break;
        case Abouthitpa:
            string = @"Privacy Policy";
            break;
        case ServicesOffered:
            string = @"Services Offered";
            break;
        case MedReminder:
            string = @"Med Reminder";
            break;
        case WellnessTip:
            string = @"Wellness Tip";
            break;
        case LogoutHitpa:
            string = @"Logout";
            break;
            
        default:
            break;
    }
    
    return NSLocalizedString(string, @"") ;
    
}

#pragma mark - tableview Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuCoun;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return headerSectionHeigh;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell ;
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    cell.separatorInset = UIEdgeInsetsMake(cell.bounds.size.width, 0.0, 0.f, 0.f);
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width = menuHeaderView.frame.size.width - 80.0;
    CGFloat height = 60.0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    xPos = 10.0;
    yPos = 10.0;
    UILabel *label = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) font:[[Configuration shareConfiguration] hitpaFontWithSize:16.0] text:[self headerTitleWithMenuType:(menu)indexPath.row]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    xPos = 0.0;
    yPos = cell.frame.size.height - 4.0;
    height = 0.5;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:lineView];
    [cell.contentView addSubview:view];
    
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [[UIManager sharedUIManger]gotoBMICalculatorWitnMenuAnimated:YES];
        [self animation];
    }
    else if (indexPath.row == 1)
    {
        [[UIManager sharedUIManger]gotoCalendarWitnMenuAnimated:YES isMedReminder:NO];
        [self animation];
    }
    else if (indexPath.row == 2)
    {
        [[UIManager sharedUIManger]gotoAboutusWitnMenuAnimated:YES];
        [self animation];
    }
    else if (indexPath.row == 3)
    {
        [[UIManager sharedUIManger]gotogotoMyprivacyWitnMenuAnimated:YES];
        [self animation];
    }
    else if (indexPath.row == 4)
    {
        [[UIManager sharedUIManger]gotoServicesOfferedWitnMenuAnimated:YES];
        [self animation];
    }
    else if (indexPath.row == 5)
    {
        [[UIManager sharedUIManger]gotoCalendarWitnMenuAnimated:YES isMedReminder:YES];
        [self animation];
    }else if (indexPath.row == 6)
    {
        [[UIManager sharedUIManger]wellnessTipViewControllerMenuAnimated:YES];
        [self animation];
    }
    else
    {
        
        alertView([[Configuration shareConfiguration] appName], @"Do you want to logout?", self, @"Yes", @"No", 0);
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0)
    {
        
        [[UserManager sharedUserManager] clearUser];
        [[UIManager sharedUIManger]gotoLoginPageWitnMenuAnimated:YES];
        
        
    }
    else if (buttonIndex == 1)
    {
        
    }
    
}


- (void)tapMyPolicy:(UITapGestureRecognizer*)reco {
    
    
    UIView *mypolicy = (UIView *) [self.view viewWithTag:mypolicyTag];
    mypolicy.layer.shadowColor = [UIColor colorWithRed:15.0/255.0 green:143.0/255.0 blue:169.0/255 alpha:1.0].CGColor;
    mypolicy.layer.shadowRadius = 30.0f;
    mypolicy.layer.shadowOpacity = 1.0f;
    mypolicy.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        mypolicy.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        mypolicy.layer.shadowRadius = 0.0f;
        mypolicy.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        MyPolicyViewController *vctr = [[MyPolicyViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
        
    }];
    
    
}


- (void)tapUpdates:(UITapGestureRecognizer*)reco {
    //    217 66 73
    
    
    UIView *updates = (UIView *) [self.view viewWithTag:updatesTag];
    updates.layer.shadowColor = [UIColor colorWithRed:186.0/255.0 green:46.0/255.0 blue:52.0/255 alpha:1.0].CGColor;
    updates.layer.shadowRadius = 30.0f;
    updates.layer.shadowOpacity = 1.0f;
    updates.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        updates.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        updates.layer.shadowRadius = 0.0f;
        updates.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        
        UpdatesViewController *vctr = [[UpdatesViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
    }];
    
}

- (void)tapGrievance:(UITapGestureRecognizer*)reco {
    
    
    UIView *griveance = (UIView *) [self.view viewWithTag:griveanceTag];
    griveance.layer.shadowColor = [UIColor colorWithRed:25.0/255.0 green:102.0/255.0 blue:149.0/255 alpha:1.0].CGColor;
    griveance.layer.shadowRadius = 30.0f;
    griveance.layer.shadowOpacity = 1.0f;
    griveance.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        griveance.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        griveance.layer.shadowRadius = 0.0f;
        griveance.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        
        GrievanceViewController *vctr = [[GrievanceViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
    }];
    
    
}

- (void)tapQuickConnect:(UITapGestureRecognizer*)reco {
    
    UIView *quickConnect = (UIView *) [self.view viewWithTag:quickConnectTag];
    quickConnect.layer.shadowColor = [UIColor colorWithRed:199.0/255.0 green:154.0/255.0 blue:35.0/255 alpha:1.0].CGColor;
    quickConnect.layer.shadowRadius = 30.0f;
    quickConnect.layer.shadowOpacity = 1.0f;
    quickConnect.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        quickConnect.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        quickConnect.layer.shadowRadius = 0.0f;
        quickConnect.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        QuickConnectViewController *vctr = [[QuickConnectViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
        
    }];
    
    
}

- (void)tapQuickGuide:(UITapGestureRecognizer*)reco {
    
    
    UIView *quickGuide = (UIView *) [self.view viewWithTag:quickguideTag];
    quickGuide.layer.shadowColor = [UIColor colorWithRed:6.0/255.0 green:106.0/255.0 blue:99.0/255 alpha:1.0].CGColor;
    quickGuide.layer.shadowRadius = 30.0f;
    quickGuide.layer.shadowOpacity = 1.0f;
    quickGuide.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        quickGuide.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        quickGuide.layer.shadowRadius = 0.0f;
        quickGuide.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        QuickGuideController *vctr = [[QuickGuideController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
        
    }];
    
}

- (void)tapHospitalSearch:(UITapGestureRecognizer*)reco {
    
    UIView *hospitalSearch = (UIView *) [self.view viewWithTag:hospitalsearchTag];
    hospitalSearch.layer.shadowColor = [UIColor colorWithRed:133.0/255.0 green:56.0/255.0 blue:183.0/255 alpha:1.0].CGColor;
    hospitalSearch.layer.shadowRadius = 30.0f;
    hospitalSearch.layer.shadowOpacity = 1.0f;
    hospitalSearch.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        hospitalSearch.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        hospitalSearch.layer.shadowRadius = 0.0f;
        hospitalSearch.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        HospitalSearchController *vctr = [[HospitalSearchController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
    }];
    
    
}

- (void)tapClaimJunction:(UITapGestureRecognizer*)reco {
    
    UIView *claims = (UIView *) [self.view viewWithTag:claimsTag];
    claims.layer.shadowColor = [UIColor colorWithRed:23.0/255.0 green:131.0/255.0 blue:75.0/255 alpha:1.0].CGColor;
    claims.layer.shadowRadius = 30.0f;
    claims.layer.shadowOpacity = 1.0f;
    claims.layer.shadowOffset = CGSizeZero;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        
        claims.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        claims.layer.shadowRadius = 0.0f;
        claims.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        ClaimsViewController *vctr = [[ClaimsViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
        [self animation];
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    

}

- (void)pushtoNextimage :(NSTimer *)timer
{
    CGRect frame = [(UIScrollView *)[self.view viewWithTag: homeScrollviewtag] frame];
    frame.origin.x = frame.size.width * self.currentPage;
    frame.origin.y = 0;
    [(UIScrollView *)[self.view viewWithTag:homeScrollviewtag] scrollRectToVisible:frame animated:YES];
    self.page.currentPage = self.currentPage;
    self.currentPage ++;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentPage == [[scrollView subviews] count])
    {
        self.currentPage = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.imageScroll.frame.size.width;
    page = floor((self.imageScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.page.currentPage=page;
    self.currentPage = page;
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

- (UIView *)createviewwithframe :(CGRect)frame
{
    return [[UIView alloc]initWithFrame:frame];
}
- (UIImageView *)createimageviewwithframe :(CGRect)frame
{
    return [[UIImageView alloc]initWithFrame:frame];
}

- (UILabel *)createlabelwithframe :(CGRect)frame
{
    return [[UILabel alloc]initWithFrame:frame];
}

- (UIButton *)createbuttonwithframe :(CGRect)frame
{
    return [[UIButton alloc]initWithFrame:frame];
}

#pragma mark - Button delegates

- (IBAction)menuBtnTapped:(id)sender
{
    CGRect frame = [self bounds];
    
    if (menuHeaderView.frame.origin.x > 0) {
        
        UIView *profileView = full;
        CGRect newProfile =  [full frame];
        UIView *menuProfile = menuHeaderView;
        CGRect newMenu = [menuHeaderView frame];
        
        //newProfile.origin.x = frame.size.width > 320? 56.0:48.0;
        newMenu.origin.x = - [self bounds].size.width;
        [UIView animateWithDuration:0.5 animations:^(void){
            //profileView.frame = newProfile;
            menuHeaderView.frame = newMenu;
            
        }];
        
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             //full.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                             menuHeaderView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                             xScale = menuHeaderView.transform.a;
//                         }
//                         completion:^(BOOL finished) {
//
//
//                         }];
        
    }else{
        
        UIView *profileView = full;
        CGRect newProfile =  [full frame];
        UIView *menuProfile = menuHeaderView;
        CGRect newMenu = [menuHeaderView frame];
        
        //newProfile.origin.x = [self bounds].size.width/2;
        newMenu.origin.x = 0;//- 20.0;
        [UIView animateWithDuration:0.5 animations:^(void){
            //profileView.frame = newProfile;
            menuHeaderView.frame = newMenu;
            
        }];
        
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             //full.transform = CGAffineTransformMakeScale(0.7, 0.7);
//                             menuHeaderView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//                             xScale = menuHeaderView.transform.a;//xScale = full.transform.a;
//
//
//                         }
//                         completion:^(BOOL finished) {
//
//
//                         }];
//
    }

   
    //[self.revealViewController revealToggle:nil];
    
}

- (void)animation
{
   
    CGRect newMenu = [menuHeaderView frame];
    
    newMenu.origin.x = - [self bounds].size.width;
    [UIView animateWithDuration:0.5 animations:^(void){
        menuHeaderView.frame = newMenu;
        
    }];
    
//    if (full.transform.a == xScale) {
//
//        UIView *profileView = full;
//        CGRect newProfile =  [full frame];
//        UIView *menuProfile = menuHeaderView;
//        CGRect newMenu = [menuHeaderView frame];
//
//        newProfile.origin.x = frame.size.width > 320? 56.0:48.0;
//        newMenu.origin.x = - [self bounds].size.width;
//        [UIView animateWithDuration:0.5 animations:^(void){
//            profileView.frame = newProfile;
//            menuProfile.frame = newMenu;
//
//        }];
//
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             full.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                             menuHeaderView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                         }
//                         completion:^(BOOL finished) {
//
//
//                         }];
//
//    }else{
//
//
//    }

}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:@"icon_userprofile.png"]];
    return imageView;
    
    
}


- (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return label;
}


#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
