//
//  ForgotPasswordViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/24/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Constants.h"
#import "Configuration.h"
#import "Gradients.h"
#import "Utility.h"
#import "HITPAAPI.h"
#import "MBProgressHUD.h"
#import "Helper.h"

NSUInteger  const kBack            = 54321;
NSUInteger  const kNewPAssword     = 543233;
//NSString    * const kPasswordChanged = @"Your password has been sent to your email ID";
NSString    * const kPasswordChanged = @"Your password has been sent to your Mobile Number";
NSString    * const kInvalidUserId   = @"Please enter valid username";

@interface ForgotPasswordViewController ()<UITextFieldDelegate,MBProgressHUDDelegate, UIAlertViewDelegate>

@property (nonatomic , strong)  UITextField     *   userName;
@property (nonatomic, strong)   MBProgressHUD   *   progressHUD;
@property (nonatomic, strong)   UIButton        *   submitBtn;
@property (nonatomic, strong)   UIButton        *   backBtn;
@property (nonatomic)           CGFloat             shiftForKeyboard;

@end

@implementation ForgotPasswordViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self forgotPasswordView];
    // Do any additional setup after loading the view from its nib.
}

- (void)forgotPasswordView
{
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
    height = frame.size.height;
    UIView *fullView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    fullView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fullView];
    
    yPos   = 32.0;
    height = frame.size.width > 320 ? 78.0:58.0;
    UIImageView *banner =[self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    banner.image = [UIImage imageNamed:logintopviewImage];
    [fullView addSubview:banner];
    
    yPos   = banner.frame.size.height + banner.frame.origin.y + (frame.size.width > 320 ? 52.0:32.0);
    height = 25.0;
    UIView *colorView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    colorView.layer.cornerRadius  = 2.0;
    colorView.layer.masksToBounds = YES;
    CAGradientLayer *gradient = [[Gradients shareGradients]login];
    gradient.frame = colorView.bounds;
    [colorView.layer insertSublayer:gradient atIndex:0];
    [fullView addSubview:colorView];
    
    xPos   = 10.0;
    yPos   = colorView.frame.origin.y + colorView.frame.size.height + 19.0;
    width  =  frame.size.width - 32.0;
    height = colorView.frame.size.height ;
    UILabel * forgotLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    forgotLabel.text = forgotPass;
    forgotLabel.textColor = [UIColor whiteColor];
    forgotLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:24.0];
    forgotLabel.layer.shadowRadius = 0.4;
    forgotLabel.layer.shadowOpacity = 0.4;
    forgotLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    forgotLabel.layer.shadowOffset = CGSizeMake(1.0, 3.0);
    [fullView addSubview:forgotLabel];
    
    xPos    =  10.0;
    yPos    =  forgotLabel.frame.origin.y + forgotLabel.frame.size.height + (frame.size.height > 480 ? 65.0:35.0);
    width   =  frame.size.width - 22.0;
    height  =  48.0;
    UIView * userView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    userView.layer.cornerRadius = 10.0;
    userView.layer.masksToBounds = YES;
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.borderWidth = 5.0;
    userView.layer.borderColor = [UIColor colorWithRed:151.0/255 green:137.0/255 blue:133.0/255 alpha:0.6].CGColor;
    [fullView addSubview:userView];
    
    // Username image
    xPos    = userView.frame.origin.x + 4.0 ;
    yPos    = userView.frame.origin.y + 5.0 ;
    width   = userView.frame.size.width /3.5;
    height  = userView.frame.size.height - 10.0 ;
    UIImageView * usernameImage = [self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    usernameImage.image = [UIImage imageNamed:loginIcon];
    [fullView addSubview:usernameImage];
    
    // Username text field
    xPos    = usernameImage.frame.size.width + 20.0;
    yPos    = forgotLabel.frame.origin.y + forgotLabel.frame.size.height + (frame.size.height > 480 ? 70.0:40.0);
    width   = userView.frame.size.width  - xPos  + 2.0;
    height  =  38.0;
    self.userName = [self createtextfieldwithFrame:CGRectMake(xPos, yPos, width, height)];
    self.userName.layer.cornerRadius = 8.0;
    self.userName.layer.masksToBounds = YES;
    self.userName.backgroundColor = [UIColor whiteColor];
    self.userName.delegate = self;
    [fullView addSubview:self.userName];
    
    // username text for ui view
    xPos    = 5.0;
    yPos    = -2.0;
    width   = usernameImage.frame.size.width ;
    height  = usernameImage.frame.size.height;
    UILabel * user = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    user.text = NSLocalizedString(usernameField, nil);
    user.font = [[Configuration shareConfiguration] hitpaFontWithSize:frame.size.width > 320 ? 18.0 : 15.0];
    user.textColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    [usernameImage addSubview:user];
    
    xPos = 0.0;
    yPos = frame.size.height - (frame.size.width > 320 ? 99.0:69.0);
    width = frame.size.width;
    height = 25.0;//frame.size.width > 320 ? 42.0:32.0
    UIView *bottomColorView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    bottomColorView.layer.cornerRadius  = 2.0;
    bottomColorView.layer.masksToBounds = YES;
    CAGradientLayer *gradient1 = [[Gradients shareGradients]login];
    gradient1.frame = bottomColorView.bounds;
    [bottomColorView.layer insertSublayer:gradient1 atIndex:0];
//    [fullView addSubview:bottomColorView];
    
    // Submit button
    xPos   =  frame.size.width - 140.0;
    yPos   =  userView.frame.origin.y + (frame.size.height > 480 ? 110.0:90.0);
    width  =  120.0;
    height =  40.0;
    self.submitBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.submitBtn addTarget:self action:@selector(submitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.submitBtn.layer.cornerRadius = 6.0;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.borderWidth =3.0;
    self.submitBtn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    
    [self.submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.submitBtn setTitle:NSLocalizedString(submit, nil) forState:UIControlStateNormal];
    [self.submitBtn setHighlighted:YES];
    self.submitBtn.layer.shadowOpacity = 0.4;
    self.submitBtn.layer.shadowRadius = 0.8;
    self.submitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitBtn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientlogin= [[Gradients shareGradients]login];
    gradientlogin.frame = self.submitBtn.bounds;
    [self.submitBtn.layer insertSublayer:gradientlogin atIndex:0];
    [fullView addSubview:self.submitBtn];
    
    // Back button
    xPos   =  20.0;
    self.backBtn = [self createbuttonwithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.backgroundColor = [UIColor colorWithRed:110.0/255 green:163.0/255 blue:52.0/255 alpha:1.0];
    self.backBtn.layer.cornerRadius = 6.0;
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.layer.borderWidth =3.0;
    self.backBtn.layer.borderColor = ([UIColor colorWithRed:199.0/255 green:199.0/255 blue:199.0/255 alpha:1.0]).CGColor;
    [self.backBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.backBtn setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [self.backBtn setHighlighted:YES];
    self.backBtn.layer.shadowOpacity = 0.4;
    self.backBtn.layer.shadowRadius = 0.8;
    self.backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backBtn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    CAGradientLayer *gradientBack = [[Gradients shareGradients]login];
    gradientBack.frame = self.backBtn.bounds;
    [self.backBtn.layer insertSublayer:gradientBack atIndex:0];
    [fullView addSubview:self.backBtn];
    
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
- (IBAction)submitBtnTapped:(id)sender
{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.submitBtn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        self.submitBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
            [params setValue:self.userName.text forKey:@"username"];
            
            NSArray *error = nil;
            
            BOOL isValidate =  [[Helper shareHelper]validateForgotPasswordWithError:&error parmas:params];
            
            if (!isValidate)
            {
                NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
                alertView([[Configuration shareConfiguration] appName], errorMessage, nil, @"Ok", nil, 0);
                return ;
                
            }
            
            [self showHUDWithMessage:@""];

            [[HITPAAPI shareAPI] forgotPasswordWithParams:params completionHandler:^(NSDictionary *response, NSError *error) {
                
                [self didReceiveNewPasswordResponse:response error:error];
            }];
            
        }];
        
    }];
    
}

- (IBAction)backBtnTapped:(id)sender
{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.backBtn.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        self.backBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    }];
    
}

#pragma mark - Handler
- (void)didReceiveNewPasswordResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    
    NSString *str = [response valueForKey:@"responseID"];
    
    if ([str containsString:@"User Detail Not Found"] || response == nil)
    {
        alertView([[Configuration shareConfiguration] appName], kInvalidUserId, nil, @"Ok", nil, kNewPAssword);
    }
    else
    {
        str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        alertView([[Configuration shareConfiguration] appName], kPasswordChanged, self, @"Ok", nil, kNewPAssword);
         alertView([[Configuration shareConfiguration] appName], str, self, @"Ok", nil, kNewPAssword);
    }

//    NSString *newPassword = [NSString stringWithFormat:@"Your New Password is %@", [response valueForKey:@"responseID"]];
//    alertView([[Configuration shareConfiguration] appName], newPassword, self, @"Ok", nil, kNewPAssword);
    
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kNewPAssword) {
        
        if (buttonIndex == 0)
        {
            
            [self.navigationController popViewControllerAnimated:YES];

            
        }else
        {
            return;
        }
        
    }
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

-(void)animateTextField:(UITextField*)textField isUp:(BOOL)isUp
{
    UIView *view = [textField superview];
    
    if (isUp)
    {
        CGRect textFieldRect = [self.view convertRect:view.bounds fromView:textField];
        CGFloat bottomEdge = textFieldRect.origin.y + textField.frame.size.height;
        CGFloat keyboardyPos = self.view.frame.size.height - 250;
        if (bottomEdge >= keyboardyPos) {
            
            CGRect viewFrame = self.view.frame;
            self.shiftForKeyboard = bottomEdge - 200.0f;
            viewFrame.origin.y -= self.shiftForKeyboard;
            [self.view setFrame:viewFrame];
            
        }
        else{
            
            self.shiftForKeyboard = 0.0f;
            
        }
        
    }else
    {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += self.shiftForKeyboard;
        self.shiftForKeyboard = 0.0f;
        [self.view setFrame:viewFrame];
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField isUp:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self animateTextField:textField isUp:NO];
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
