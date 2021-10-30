//
//  ChangePasswordController.m
//  HITPA
//
//  Created by Kranthi B. on 11/4/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "ChangePasswordController.h"
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

typedef enum {
    
    EmailPhoneNo = 1000,
    Password
    
}Fieldtype;

NSString    *   const kChangePwdInvalidCredentials     =  @"Invalid login credentials";
NSString    *   const kChangePwdStatus                 =  @"\"Password changed successfully\"";
NSUInteger      const kChangePasswordSuccessTag        = 110;



@interface ChangePasswordController ()<MBProgressHUDDelegate>
@property(strong,nonatomic) UITextField *userName;
@property (strong,nonatomic) UITextField *oldPassWord, *nwPassword, *confirmPassword;
@property(strong,nonatomic) UIButton *submittBtn;
@property(readwrite,nonatomic) BOOL isRegister;


@end

@implementation ChangePasswordController

- (instancetype)initWithIsRegister:(BOOL)isRegister {
    
    self = [super init];
    if (self)
    {
        
        self.isRegister = isRegister;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self changePasswrd];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)changePasswrd{
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
//    yPos   = topView.frame.size.height + topView.frame.origin.y + 40.0;
//    height = roundf(topView.frame.size.height/3.7);
    yPos   = topView.frame.size.height + topView.frame.origin.y + 30.0;
    height = roundf(topView.frame.size.height/4.2);
    UIView *colorView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    // colorView.backgroundColor = [UIColor colorWithRed:1.0/255 green:60.0/255 blue:122.0/255 alpha:1.0];
    colorView.layer.cornerRadius  = 4.0;
    colorView.layer.masksToBounds = YES;
    CAGradientLayer *gradient = [[Gradients shareGradients]login];
    gradient.frame = colorView.bounds;
    [colorView.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:colorView];
    
    
    
    // Login Now Label
    xPos   =  (10.0);
    yPos   = colorView.frame.origin.y + colorView.frame.size.height + 10.0;
    width  =  frame.size.width - 32.0;
    height = colorView.frame.size.height ;
    UILabel * loginLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    loginLabel.text = @"Change Password";
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
    height = roundf(topView.frame.size.height/2.5);
    UIView * belowDetails = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
     yPos   = frame.size.height - 40;
     UIView * belowDetailss = [self createviewithFrame:CGRectMake(xPos, yPos, width, roundf(topView.frame.size.height/4.2))];
    belowDetailss.layer.cornerRadius  = 4.0;
    belowDetailss.layer.masksToBounds = YES;
    CAGradientLayer *gradientBelowdetails = [[Gradients shareGradients]login];
    gradientBelowdetails.frame = belowDetailss.bounds;
    [belowDetailss.layer insertSublayer:gradientBelowdetails atIndex:0];
    [self.view addSubview:belowDetailss];
    
       //Username Below view
    xPos    =  (10.0) ;
    yPos    = loginLabel.frame.origin.y+loginLabel.frame.size.height+10;
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
    yPos    = loginLabel.frame.origin.y+loginLabel.frame.size.height+15;
    width   = userView.frame.size.width  - xPos  + 2.0;
    height  =  30.0;
    self.userName = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.userName.layer.cornerRadius = 8.0;
    self.userName.layer.masksToBounds = YES;
    self.userName.text = [[UserManager sharedUserManager]userName];
    self.userName.enabled = NO;
    self.userName.backgroundColor = [UIColor whiteColor];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    // Password below view
    
    xPos    =  (10.0) ;
    yPos    =  self.userName.frame.origin.y + (self.userName.frame.size.height *2) - 2.0;
    
    width   =  frame.size.width - 22.0;
    height  =  belowDetails.frame.size.height + 8.0;
    UIView * oldpasswordView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    oldpasswordView.layer.cornerRadius = 8.0;
    oldpasswordView.layer.masksToBounds = YES;
    oldpasswordView.layer.shadowOpacity = 0.4f;
    oldpasswordView.backgroundColor = [UIColor whiteColor];
    oldpasswordView.layer.borderWidth = 5.0;
    oldpasswordView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [self.view addSubview:oldpasswordView];
    
    // Password image
    xPos    = oldpasswordView.frame.origin.x + 4.0;
    yPos    = oldpasswordView.frame.origin.y + 5.0;
    width   = oldpasswordView.frame.size.width /2.5;
    height  = oldpasswordView.frame.size.height -10.0;
    UIImageView * oldpasswordImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    oldpasswordImage.image = [UIImage imageNamed:loginIcon];
    [self.view addSubview:oldpasswordImage];
    
    
    // password text field
    xPos    =  oldpasswordImage.frame.size.width + 20.0 ;
    yPos    =  oldpasswordView.frame.origin.y + 5.0;
    width   =  oldpasswordView.frame.size.width - xPos + 5.0;
    height  =  oldpasswordView.frame.size.height - 10.0;
    self.oldPassWord = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.oldPassWord.secureTextEntry = YES;
    self.oldPassWord.layer.cornerRadius = 8.0;
    self.oldPassWord.layer.masksToBounds = YES;
    self.oldPassWord.backgroundColor = [UIColor whiteColor];
    self.oldPassWord.tag = Password;
    self.oldPassWord.delegate = self;
    [self.view addSubview:self.oldPassWord];
    
    xPos    =  (10.0) ;
    yPos    =  self.oldPassWord.frame.origin.y + (self.oldPassWord.frame.size.height *2) - 2.0;
    width   =  frame.size.width - 22.0;
    height  =  belowDetails.frame.size.height + 8.0;
    UIView * newpasswordView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    newpasswordView.layer.cornerRadius = 8.0;
    newpasswordView.layer.masksToBounds = YES;
    newpasswordView.layer.shadowOpacity = 0.4f;
    newpasswordView.backgroundColor = [UIColor whiteColor];
    newpasswordView.layer.borderWidth = 5.0;
    newpasswordView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [self.view addSubview:newpasswordView];
    
    // newPassword image
    xPos    = newpasswordView.frame.origin.x + 4.0;
    yPos    = newpasswordView.frame.origin.y + 5.0;
    width   = newpasswordView.frame.size.width /2.5;
    height  = newpasswordView.frame.size.height -10.0;
    UIImageView * newpasswordImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    newpasswordImage.image = [UIImage imageNamed:loginIcon];
    [self.view addSubview:newpasswordImage];
    
    
    // newpassword text field
    xPos    =  newpasswordImage.frame.size.width + 20.0 ;
    yPos    =  newpasswordView.frame.origin.y + 5.0;
    width   =  newpasswordView.frame.size.width - xPos + 5.0;
    height  =  newpasswordView.frame.size.height - 10.0;
    self.nwPassword = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.nwPassword.secureTextEntry = YES;
    self.nwPassword.layer.cornerRadius = 8.0;
    self.nwPassword.layer.masksToBounds = YES;
    self.nwPassword.backgroundColor = [UIColor whiteColor];
    self.nwPassword.tag = Password;
    self.nwPassword.delegate = self;
    [self.view addSubview:self.nwPassword];
    
    //confirm  password
    xPos    =  (10.0) ;
    yPos    =  self.nwPassword.frame.origin.y + (self.nwPassword.frame.size.height *2) - 2.0;
    width   =  frame.size.width - 22.0;
    height  =  belowDetails.frame.size.height + 8.0;
    UIView * confirmpasswordView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    confirmpasswordView.layer.cornerRadius = 8.0;
    confirmpasswordView.layer.masksToBounds = YES;
    confirmpasswordView.layer.shadowOpacity = 0.4f;
    confirmpasswordView.backgroundColor = [UIColor whiteColor];
    confirmpasswordView.layer.borderWidth = 5.0;
    confirmpasswordView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [self.view addSubview:confirmpasswordView];
    
    // confirmPassword image
    xPos    = confirmpasswordView.frame.origin.x + 4.0;
    yPos    = confirmpasswordView.frame.origin.y + 5.0;
    width   = confirmpasswordView.frame.size.width /2.5;
    height  = confirmpasswordView.frame.size.height -10.0;
    UIImageView * confirmpasswordImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    confirmpasswordImage.image = [UIImage imageNamed:loginIcon];
    [self.view addSubview:confirmpasswordImage];
    
    
    // confirm password text field
    xPos    =  confirmpasswordImage.frame.size.width + 20.0 ;
    yPos    =  confirmpasswordView.frame.origin.y + 5.0;
    width   =  confirmpasswordView.frame.size.width - xPos + 5.0;
    height  =  confirmpasswordView.frame.size.height - 10.0;
    self.confirmPassword = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.confirmPassword.secureTextEntry = YES;
    self.confirmPassword.layer.cornerRadius = 8.0;
    self.confirmPassword.layer.masksToBounds = YES;
    self.confirmPassword.backgroundColor = [UIColor whiteColor];
    self.confirmPassword.tag = Password;
    self.confirmPassword.delegate = self;
    [self.view addSubview:self.confirmPassword];
    

    
    // Login button
    xPos   =  (frame.size.width/2) + self.confirmPassword.frame.size.width/3.5;
    yPos   =  self.confirmPassword.frame.origin.y + self.confirmPassword.frame.size.height * 2;
    width  =  belowDetails.frame.size.width/3.2;
    height =  belowDetails.frame.size.height;
    self.submittBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.submittBtn addTarget:self action:@selector(submittBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.submittBtn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.submittBtn.layer.cornerRadius = 4.0;
    self.submittBtn.layer.masksToBounds = YES;
    self.submittBtn.layer.borderWidth =2.0;
    self.submittBtn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    
    [self.submittBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.submittBtn setTitle:NSLocalizedString(submit, nil) forState:UIControlStateNormal];
    [self.submittBtn setHighlighted:YES];
    self.submittBtn.layer.shadowOpacity = 0.4;
    self.submittBtn.layer.shadowRadius = 0.8;
    self.submittBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submittBtn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientlogin = [[Gradients shareGradients]login];
    gradientlogin.frame = self.submittBtn.bounds;
    [self.submittBtn.layer insertSublayer:gradientlogin atIndex:0];
    [self.view addSubview:self.submittBtn];

    // username text for ui view
    xPos    = 0.0;
    yPos    = -2.0;
    width   = usernameImage.frame.size.width ;
    height  = usernameImage.frame.size.height;
    UILabel * user = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    user.text = NSLocalizedString(usernameField, nil);
    user.font = [[Configuration shareConfiguration]hitpaFontWithSize:13.0];
    user.textAlignment = NSTextAlignmentCenter;
    user.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [usernameImage addSubview:user];
    

    // oldpassword text for ui view
    xPos    = 0.0;
    yPos    = -2.0;
    width   = oldpasswordImage.frame.size.width ;
    height  = oldpasswordImage.frame.size.height;
    UILabel * old = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    old.text = NSLocalizedString(@"Old Password:", nil);
    old.font = [[Configuration shareConfiguration]hitpaFontWithSize:13.0];
    old.textAlignment = NSTextAlignmentCenter;
    old.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [oldpasswordImage addSubview:old];
    
    // new password text for ui view
    xPos    = 0.0;
    yPos    = -2.0;
    width   = newpasswordImage.frame.size.width ;
    height  = newpasswordImage.frame.size.height;
    UILabel * new = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    new.text = NSLocalizedString(@"New Password:", nil);
    new.font = [[Configuration shareConfiguration]hitpaFontWithSize:13.0];
    new.textAlignment = NSTextAlignmentCenter;
    new.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [newpasswordImage addSubview:new];
    
    // confirm password text for ui view
    xPos    = 0.0;
    yPos    = -2.0;
    width   = confirmpasswordImage.frame.size.width ;
    height  = confirmpasswordImage.frame.size.height;
    UILabel * conform = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    conform.text = NSLocalizedString(@"Confirm Password:", nil);
    conform.font = [[Configuration shareConfiguration]hitpaFontWithSize:13.0];
    conform.textAlignment = NSTextAlignmentCenter;
    conform.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [confirmpasswordImage addSubview:conform];
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10, 10);
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
-(void)submittBtnTapped:(id)sender{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.submittBtn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        self.submittBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
            [params setValue:self.userName.text forKey:@"UserName"];
            [params setValue:self.oldPassWord.text forKey:@"OldPassword"];
            [params setValue:self.nwPassword.text forKey:@"NewPassword"];
            [params setValue:self.confirmPassword.text forKey:@"ConfirmPassword"];

            NSArray *error = nil;
            

            BOOL isValidate = [[Helper shareHelper]validateChangePasswordWithWithError:&error parmas:params];
        
            if (!isValidate)
            {
                NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
                alertView([[Configuration shareConfiguration] appName], errorMessage, nil, @"Ok", nil, 0);
                return ;
                
            }
//
            [self showHUDWithMessage:@""];
            [[HITPAAPI shareAPI] changePasswordWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
                
                [self didReceiveChangePasswordResponse:response error:error];
                
            }];
            
        }];
        
    }];
}
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

#pragma mark - Response

- (void)didReceiveChangePasswordResponse:(NSDictionary *)response error:(NSError *)error
{
    
    //    [self hideHUD];
    NSString *str = [NSString stringWithFormat:@"%@", [response objectForKey:@"successID"]];
    
    if ([str isEqualToString:kChangePwdStatus]) {
        
        [self hideHUD];
        alertView([[Configuration shareConfiguration] appName], [str stringByReplacingOccurrencesOfString:@"\"" withString:@""], self, @"Ok", nil, kChangePasswordSuccessTag);
        

    }else{
        
        [self hideHUD];
        
        alertView([[Configuration shareConfiguration] appName], [str stringByReplacingOccurrencesOfString:@"\"" withString:@""], nil, @"Ok", nil, 0);
        return;
        
    }
    
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kChangePasswordSuccessTag) {
        
        if (buttonIndex == 0)
        {
            
            if(self.isRegister) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
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
