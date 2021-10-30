//
//  LoginViewController.m
//  HITPA
//
//  Created by Bathi Babu on 26/11/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "LoginViewController.h"
#import "Configuration.h"
#import "Constants.h"
#import "Gradients.h"
#import "HomeViewController.h"
#import "HITPAAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIManager.h"
#import "ForgotPasswordViewController.h"
#import "ContactUsViewController.h"
#import "HITPAAPI.h"
#import "MBProgressHUD.h"
#import "UserManager.h"
//#import "KeyboardHelper.h"
#import "Helper.h"
#import "Utility.h"
#import "HITPAUserDefaults.h"
#import "CoreData.h"
#import "ChangePasswordController.h"
#import "RegistrationViewController.h"

NSUInteger      const kForgotpassword           =  100;
NSUInteger      const kRemember                 =  101;
NSUInteger      const kLoginSuccess             =  107;
NSUInteger      const kRegistration             =  108;
NSUInteger      const kChangePassword           =  109;
NSString    *   const kInvalidCredentials       =  @"Invalid login credentials";
NSString    *   const kUserAlreadyExists        =  @"User already exists";
NSString    *   const kChangePasswordStatus     =  @"Change Password";
NSString    *   const kRegistrationStatus       =  @"Registration Required";
NSString    *   const kDevice                   =  @"IOS";

typedef enum {
    
    EmailPhoneNo = 1000,
    Password
    
}Fieldtype;


@interface LoginViewController ()<MBProgressHUDDelegate>

@property (nonatomic , strong) UIImageView  *  tickmarkforRemember;
@property (nonatomic , strong) UIImageView  *  tickmarkforForgot;
@property (nonatomic , strong) UITextField  *  passWord;
@property (nonatomic , strong) UITextField  *  userName;
@property (nonatomic, strong) MBProgressHUD *  progressHUD;
@property (nonatomic)          CGFloat         shiftForKeyboard;
@property (nonatomic, strong)  UIButton     *  logIn;
@property (nonatomic, strong)  UIButton     *  contactUs;
@property (nonatomic, strong)  UIButton     *  forgotPassword;

@end

@implementation LoginViewController
#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    
    /* Login Credentials
     UserName:1418000000000401
     Password:inube123
     */
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self loginUI];
    // Do any additional setup after loading the view from its nib.
//    RegistrationViewController *vctr = [[RegistrationViewController alloc]init];
//    [self presentViewController:vctr animated:YES completion:nil];
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Login UI
- (void)loginUI
{
    // Gradient colors
    //getting current device boundaries
    CGRect frame = [self bounds];
    CGFloat xPos , yPos , width ,height;
    
    //Background Image
    xPos   = 0.0;
    yPos   = 0.0;
    width  = frame.size.width;
    height = frame.size.height;
    UIImageView *backgroundImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    backgroundImage.image = [UIImage imageNamed:loginbackgroundImage];
    [self.view addSubview:backgroundImage];
    
    //Top View
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
    
    
    
    // Login Now Label
    xPos   = 32.0 ;
    yPos   = colorView.frame.origin.y + colorView.frame.size.height + 10.0;
    width  =  frame.size.width - 32.0;
    height = colorView.frame.size.height ;
    UILabel * loginLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    loginLabel.text = loginNow;
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:20.0];
    loginLabel.layer.shadowOpacity = 0.4;
    loginLabel.layer.shadowRadius = 0.4;
    loginLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    loginLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [self.view addSubview:loginLabel];
    
    // Below View
    xPos   = 0.0;
    yPos   = frame.size.height - topView.frame.size.height;
    width  = frame.size.width;
    height = roundf(topView.frame.size.height/2.5);;
    UIView * belowDetails = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    belowDetails.layer.cornerRadius  = 4.0;
    belowDetails.layer.masksToBounds = YES;
    CAGradientLayer *gradientBelowdetails = [[Gradients shareGradients]login];
    gradientBelowdetails.frame = belowDetails.bounds;
    [belowDetails.layer insertSublayer:gradientBelowdetails atIndex:0];
    [self.view addSubview:belowDetails];
    
    // Enter username and password label
    xPos   = loginLabel.frame.origin.x;
    yPos   = loginLabel.frame.origin.y + loginLabel.frame.size.height + 15.0;
    height =  colorView.frame.size.height;
    UILabel * showDetails = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    showDetails.text = NSLocalizedString(Credentials, nil);
    showDetails.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
    showDetails.textColor = [UIColor whiteColor];
    showDetails.layer.shadowOpacity = 0.4;
    showDetails.layer.shadowRadius = 0.4;
    showDetails.layer.shadowColor = [UIColor blackColor].CGColor;
    showDetails.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [self.view addSubview:showDetails];
    
    //Username Below view
    xPos    =  (10.0) ;
    yPos    =  showDetails.frame.origin.y + showDetails.frame.size.height + 10.0;
    width   =  frame.size.width - 22.0;
    height  =  belowDetails.frame.size.height + 8.0;
    UIView * userView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    userView.layer.cornerRadius = 8.0;
    userView.layer.masksToBounds = YES;
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.borderWidth = 5.0;
    userView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [self.view addSubview:userView];
    
    // Username image
    xPos    = userView.frame.origin.x + 4.0 ;
    yPos    = userView.frame.origin.y +5.0 ;
    width   = userView.frame.size.width /2.5;
    height  = userView.frame.size.height -10.0 ;
    UIImageView * usernameImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    usernameImage.image = [UIImage imageNamed:loginIcon];
    [self.view addSubview:usernameImage];
    
    // Username text field
    xPos    = usernameImage.frame.size.width + 20.0;
    yPos    = showDetails.frame.origin.y + showDetails.frame.size.height + 15.0;
    width   = userView.frame.size.width  - xPos  + 2.0;
    height  =  30.0;
    self.userName = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.userName.layer.cornerRadius = 8.0;
    self.userName.layer.masksToBounds = YES;
    self.userName.backgroundColor = [UIColor whiteColor];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    // Password below view
    
    xPos    =  (10.0) ;
    yPos    =  self.userName.frame.origin.y + (self.userName.frame.size.height *2) - 2.0;
    width   =  frame.size.width - 22.0;
    height  =  belowDetails.frame.size.height + 8.0;
    UIView * passwordView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    passwordView.layer.cornerRadius = 8.0;
    passwordView.layer.masksToBounds = YES;
    passwordView.layer.shadowOpacity = 0.4f;
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.borderWidth = 5.0;
    passwordView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [self.view addSubview:passwordView];
    
    // Password image
    xPos    = passwordView.frame.origin.x + 4.0;
    yPos    = passwordView.frame.origin.y + 5.0;
    width   = passwordView.frame.size.width /2.5;
    height  = passwordView.frame.size.height -10.0;
    UIImageView * passwordeImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    passwordeImage.image = [UIImage imageNamed:loginIcon];
    [self.view addSubview:passwordeImage];
    
    
    // password text field
    xPos    =  passwordeImage.frame.size.width + 20.0 ;
    yPos    =  passwordView.frame.origin.y + 5.0;
    width   =  passwordView.frame.size.width - xPos + 5.0;
    height  =  passwordView.frame.size.height - 10.0;
    self.passWord = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.passWord.secureTextEntry = YES;
    self.passWord.layer.cornerRadius = 8.0;
    self.passWord.layer.masksToBounds = YES;
    self.passWord.backgroundColor = [UIColor whiteColor];
    self.passWord.tag = Password;
    self.passWord.delegate = self;
    [self.view addSubview:self.passWord];
    
    //Below label text
    xPos = 0.0 ;
    yPos = belowDetails.frame.origin.y;
    width = 125.0;
    height = belowDetails.frame.size.height;
    self.forgotPassword =[self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.forgotPassword setTitle:NSLocalizedString(@"Forgot password ?", nil) forState:UIControlStateNormal];
    [self.forgotPassword addTarget:self action:@selector(forgotBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.forgotPassword.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
    self.forgotPassword.layer.shadowOpacity = 0.4;
    self.forgotPassword.layer.shadowRadius = 0.8;
    self.forgotPassword.layer.shadowColor = [UIColor blackColor].CGColor;
    self.forgotPassword.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [self.view addSubview:self.forgotPassword];
    
    // contact us
    xPos  = frame.size.width - 100.0;
    width =  100.0;
    self.contactUs = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.contactUs setTitle:NSLocalizedString(contact, nil) forState:UIControlStateNormal];
    [self.contactUs addTarget:self action:@selector(contactBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.contactUs.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
    self.contactUs.layer.shadowOpacity = 0.4;
    self.contactUs.layer.shadowRadius = 0.8;
    self.contactUs.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contactUs.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [self.view addSubview:self.contactUs];
    
    // Login button
    xPos   =  (frame.size.width/2) + self.contactUs.frame.size.width/3;
    yPos   =  self.passWord.frame.origin.y + self.passWord.frame.size.height * 2;
    width  =  belowDetails.frame.size.width/3;
    height =  belowDetails.frame.size.height;
    self.logIn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.logIn addTarget:self action:@selector(loginBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.logIn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.logIn.layer.cornerRadius = 4.0;
    self.logIn.layer.masksToBounds = YES;
    self.logIn.layer.borderWidth =2.0;
    self.logIn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    
    [self.logIn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.logIn setTitle:NSLocalizedString(loginData, nil) forState:UIControlStateNormal];
    [self.logIn setHighlighted:YES];
    self.logIn.layer.shadowOpacity = 0.4;
    self.logIn.layer.shadowRadius = 0.8;
    self.logIn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logIn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientlogin = [[Gradients shareGradients]login];
    gradientlogin.frame = self.logIn.bounds;
    [self.logIn.layer insertSublayer:gradientlogin atIndex:0];
    [self.view addSubview:self.logIn];
    
    // remember me view
    xPos    =  loginLabel.frame.origin.x  - 6.0;
    yPos    =  self.passWord.frame.origin.y + (self.passWord.frame.size.height * 2) + 12.0 ;
    width   =  frame.size.width/2;
    height  =  colorView.frame.size.height;
    UIView * rememberMe = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    rememberMe.backgroundColor = [UIColor clearColor];
    [rememberMe setTag:kRemember];

    UITapGestureRecognizer * setRemember = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRemember:)];
    [rememberMe addGestureRecognizer:setRemember];
    [self.view addSubview:rememberMe];
    
    // forgot password view
    xPos    =  loginLabel.frame.origin.x  - 6.0;
    yPos    =  rememberMe.frame.origin.y + (self.passWord.frame.size.height) -4.0 ;
    width   =  frame.size.width/2;
    height  =  colorView.frame.size.height;
    UIView * forgot = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    forgot.backgroundColor = [UIColor clearColor];
    [forgot setTag:kForgotpassword];
    
    // checkbox ui for remember
    xPos   =  0.0;
    yPos   =  (rememberMe.frame.size.height/2) - 4.0;
    width  =  15.0;
    height =  15.0;
    UILabel * checkbox = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    checkbox.backgroundColor = [UIColor clearColor];
    [checkbox.layer setCornerRadius:2.0];
    [checkbox.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [checkbox.layer setBorderWidth:2.0];
    [rememberMe addSubview:checkbox];
    
    // data for remember
    xPos   =  18.0;
    yPos   =  3.0;
    width  =  rememberMe.frame.size.width;
    height =  rememberMe.frame.size.height;
    UILabel * remember = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    remember.textColor = [UIColor whiteColor];
    remember.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
    remember.text = NSLocalizedString(rememberData, nil);
    remember.layer.shadowOpacity = 0.4;
    remember.layer.shadowRadius = 0.8;
    remember.layer.shadowColor = [UIColor blackColor].CGColor;
    remember.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    [rememberMe addSubview:remember];
    
    // data for forgot
    xPos   =  4.0;
    yPos   =  2.0;
    width  =  forgot.frame.size.width;
    height =  forgot.frame.size.height;
    UILabel * forgotMe = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    forgotMe.textColor = [UIColor whiteColor];
    forgotMe.font = [[Configuration shareConfiguration]hitpaFontWithSize:12.0];
    forgotMe.text = NSLocalizedString(forgotpasswordData, nil);
    forgotMe.layer.shadowOpacity = 0.4;
    forgotMe.layer.shadowRadius = 0.8;
    forgotMe.layer.shadowColor = [UIColor blackColor].CGColor;
    forgotMe.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [forgot addSubview:forgotMe];
    
    // username text for ui view
    xPos    = usernameImage.frame.size.height/2;
    yPos    = -2.0;
    width   = usernameImage.frame.size.width ;
    height  = usernameImage.frame.size.height;
    UILabel * user = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    user.text = NSLocalizedString(usernameField, nil);
    user.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [usernameImage addSubview:user];
    
    // password text for ui view
    xPos    = (passwordeImage.frame.size.height/2) + 4.0;
    yPos    = -2.0 ;
    width   = passwordeImage.frame.size.width;
    height  = passwordeImage.frame.size.height;
    UILabel * password = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    password.text = NSLocalizedString(passwordField, nil);
    password.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [passwordeImage addSubview:password];
    
    //Tick mark for check box
    xPos     =  2.0;
    yPos     =  (rememberMe.frame.size.height/2) - 1;
    width    =  10.0 ;
    height   =  10.0;
    self.tickmarkforRemember = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.tickmarkforRemember.contentMode = UIViewContentModeScaleAspectFit;
    [rememberMe addSubview:self.tickmarkforRemember];
    
    if([[HITPAUserDefaults shareUserDefaluts]valueForKey:@"rememberUser"] != nil) {
        self.tickmarkforRemember.image = [UIImage imageNamed:selection];
        self.tickmarkforRemember.image = [self.tickmarkforRemember.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.tickmarkforRemember setTintColor:[UIColor whiteColor]];
        NSMutableDictionary *userInfo = [[HITPAUserDefaults shareUserDefaluts] valueForKey:@"rememberUser"];
        self.passWord.text = [userInfo valueForKey:@"password"];
        self.userName.text = [userInfo valueForKey:@"username"];
    }
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10, 10);
}

- (void)selectRemember :(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.tickmarkforRemember.image == nil)
    {
        self.tickmarkforRemember.image = [UIImage imageNamed:selection];
        self.tickmarkforRemember.image = [self.tickmarkforRemember.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.tickmarkforRemember setTintColor:[UIColor whiteColor]];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [userInfo setValue:self.passWord.text forKey:@"password"];
        [userInfo setValue:self.userName.text forKey:@"username"];
        [[HITPAUserDefaults shareUserDefaluts] setValue:userInfo forKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts] synchronize];
    }
    else
    {
        self.tickmarkforRemember.image = nil;
        [[HITPAUserDefaults shareUserDefaluts]removeObjectForKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts]synchronize];

    }
    
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
    return [[UILabel alloc]initWithFrame:frame];
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
    return [[UIScreen mainScreen]bounds];
}

#pragma mark - Button delegate

- (IBAction)loginBtnTapped:(id)sender
{
     
    if (self.tickmarkforRemember.image != nil)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [userInfo setValue:self.passWord.text forKey:@"password"];
        [userInfo setValue:self.userName.text forKey:@"username"];
        [[HITPAUserDefaults shareUserDefaluts] setValue:userInfo forKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts] synchronize];
    }
    else
    {
        [[HITPAUserDefaults shareUserDefaluts]removeObjectForKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts]synchronize];

    }

    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.logIn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {

        self.logIn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {

            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
            [params setValue:self.userName.text forKey:@"username"];
            [params setValue:self.passWord.text forKey:@"password"];
            [params setValue:[[Helper shareHelper] getUniqueDeviceIdentifierAsString] forKey:@"DeviceIMEI"];
            [params setValue:kDevice forKey:@"DeviceOS"];
            [params setValue:[[Configuration shareConfiguration] deviceModelName] forKey:@"DeviceModel"];
            [params setValue:([[Configuration shareConfiguration] serviceProvider] != nil && [[Configuration shareConfiguration] serviceProvider].length > 0)?[[Configuration shareConfiguration] serviceProvider]:@"" forKey:@"DeviceCarrier"];
            [params setValue:[NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]] forKey:@"OsVersion"];

            NSArray *error = nil;

            BOOL isValidate =  [[Helper shareHelper]validateLoginWithWithError:&error parmas:params];

            if (!isValidate)
            {
                NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
                alertView([[Configuration shareConfiguration] appName], errorMessage, nil, @"Ok", nil, 0);
                return ;

            }

                [self showHUDWithMessage:@""];
                [[HITPAAPI shareAPI] loginWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){

                    [self didReceiveLoginResponse:response error:error];

                }];

        }];

    }];
    
}

- (IBAction)contactBtnTapped:(id)sender
{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.contactUs.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        self.contactUs.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            ContactUsViewController *vctr = [[ContactUsViewController alloc]init];
            [self.navigationController pushViewController:vctr animated:YES];
        }];
        
    }];
}

- (IBAction)forgotBtnTapped:(id)sender
{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.forgotPassword.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        self.forgotPassword.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            self.userName.text = @"";
            self.passWord.text = @"";
            ForgotPasswordViewController *vctr = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
            [self.navigationController pushViewController:vctr animated:YES];

        }];
        
    }];
    
}

#pragma mark - Handler

- (void)didReceiveLoginResponse:(NSDictionary *)response error:(NSError *)error
{
    
//    [self hideHUD];
    NSString *str = [response objectForKey:@"ResponseMessage"];
    
    if ([str isEqualToString:kUserAlreadyExists]) {
        
       [[UserManager sharedUserManager] populateUserInfoFromResponse:response username:self.userName.text isSuccess:YES authToken:[response objectForKey:@"AuthToken"]];

        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyResponse:response error:error];
        }];
    }else if ([str isEqualToString:kChangePasswordStatus]) {
        [self hideHUD];
        [[UserManager sharedUserManager] populateUserInfoFromResponse:response username:self.userName.text isSuccess:NO authToken:[response objectForKey:@"AuthToken"]];
        self.userName.text = @"";
        self.passWord.text = @"";
        self.tickmarkforRemember.image = nil;
        [[HITPAUserDefaults shareUserDefaluts]removeObjectForKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts]synchronize];
        alertView([[Configuration shareConfiguration] appName],@"Login successful" , self, @"Ok", nil, kChangePassword);
        
        
    }else if ([str isEqualToString:kRegistrationStatus]) {
        [self hideHUD];
        [[UserManager sharedUserManager] populateUserInfoFromResponse:response username:self.userName.text isSuccess:NO authToken:[response objectForKey:@"AuthToken"]];
        self.userName.text = @"";
        self.passWord.text = @"";
        self.tickmarkforRemember.image = nil;
        [[HITPAUserDefaults shareUserDefaluts]removeObjectForKey:@"rememberUser"];
        [[HITPAUserDefaults shareUserDefaluts]synchronize];
        //Old Code
//         alertView([[Configuration shareConfiguration] appName],@"Login successful" , self, @"Ok", nil, kRegistration);
        //New Code
        RegistrationViewController *vctr = [[RegistrationViewController alloc]init];
        [self presentViewController:vctr animated:YES completion:nil];
        
    }else{
        
        [self hideHUD];
        if(error == nil) {
            alertView([[Configuration shareConfiguration] appName],str , nil, @"Ok", nil, 0);
            return;
        }
        else
        {
            alertView([[Configuration shareConfiguration] appName], @"No internet connection. Connect to internet to proceed", nil, @"Ok", nil, 0);
            return;
        }
    }
    
}


- (void)didReceivePolicyResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    
    if ([[response valueForKey:@"Message"] length] > 0) {
        
    }
    else
    {
        [[CoreData shareData] setMyPolicyDetailsWithResponse:response];
        [[HITPAUserDefaults shareUserDefaluts] setValue:[response valueForKey:@"CustomerName"] forKey:@"username"];
        [[HITPAUserDefaults shareUserDefaluts] setValue:[response valueForKey:@"ProductName"] forKey:@"productname"];
        [[HITPAUserDefaults shareUserDefaluts]synchronize];
//        [[[HITPAUserDefaults shareUserDefaluts] valueForKey:@"CustomerName"] synchronize];
    }
    alertView([[Configuration shareConfiguration] appName],@"Login is Successful" , self, @"Ok", nil, kLoginSuccess);
   
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kLoginSuccess) {
        
        if (buttonIndex == 0)
        {
            [[UIManager sharedUIManger] gotoHomePageWitnMenuAnimated:YES];
            [self registerDeviceToken];
            
        }else
        {
            return;
        }
        
    }
    else if (alertView.tag == kRegistration)
    {
        if (buttonIndex == 0)
        {
            RegistrationViewController *vctr = [[RegistrationViewController alloc]init];
            [self presentViewController:vctr animated:YES completion:nil];
            
        }else
        {
            return;
        }

    }
    else if (alertView.tag == kChangePassword)
    {
        if (buttonIndex == 0)
        {
            ChangePasswordController *vctr = [[ChangePasswordController alloc]initWithIsRegister:NO];
            [self presentViewController:vctr animated:YES completion:nil];
            
        }else
        {
            return;
        }
        
    }

}


#pragma mark - DeviceToken
- (void)registerDeviceToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"deviceuniqueid"];
    [params setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
    [[HITPAAPI shareAPI] registerDeviceTokeWithParam:params completionHandler:^(NSDictionary *response , NSError *error){
        [self didReceiveRegisterDeviceResponse:response error:error];
    }];
}

- (void)didReceiveRegisterDeviceResponse:(NSDictionary *)response error:(NSError *)error
{
    
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

#pragma mark - Textfield delegate
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "] )
    {
        return NO;
    }
    return YES;
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

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
