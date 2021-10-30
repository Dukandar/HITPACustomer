//
//  ContactUsViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/28/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Configuration.h"
#import "Utility.h"
#import <MessageUI/MessageUI.h>

NSUInteger  const kContactCall      = 1011;
NSUInteger  const kContactEmail     = 1022;

@interface ContactUsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation ContactUsViewController
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"Contact Us", @"");
    [self contactUsView];
    // Do any additional setup after loading the view from its nib.
}

- (void)contactUsView
{
    CGRect frame = [self bounds];
    CGFloat xPos ,yPos ,width ,height;
    
    //Top View
    xPos   = 0.0;
    yPos   = 0.0;
    width  = frame.size.width;
    height = 390.0;
    UIView *fullView = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    fullView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fullView];
    
    height = 80.0;
    UIView *callUs = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    callUs.backgroundColor = [UIColor clearColor];
    [fullView addSubview:callUs];
    
    yPos   = callUs.frame.size.height + 10.0;
    UIView *emailUs = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    emailUs.backgroundColor = [UIColor clearColor];
    [fullView addSubview:emailUs];
    
    xPos   = 0.0;
    yPos   = emailUs.frame.size.height + emailUs.frame.origin.y;
    width  = frame.size.width;
    height = fullView.frame.size.height - yPos;
    UIView *writeUs = [self createviewithFrame:CGRectMake(xPos, yPos, width, height)];
    writeUs.backgroundColor = [UIColor clearColor];
    [fullView addSubview:writeUs];
    
    xPos = 12.0;
    yPos = 12.0;
    width = 26.0;
    height = 26.0;
    UIImageView *callUsImage =[self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    callUsImage.image = [UIImage imageNamed:@"icon_call_us.png"];
    [callUs addSubview:callUsImage];
    
    xPos   = 50.0;
    yPos   = 5.0;
    width  =  frame.size.width;
    height = callUs.frame.size.height/2 ;
    UILabel * callUsLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    callUsLabel.text = NSLocalizedString(@"Call Us", @"");
    callUsLabel.textColor = [UIColor colorWithRed:(64.0/255.0) green:(120.0/255.0) blue:(182.0/255.0) alpha:1.0];
    callUsLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:23.0];
    [callUs addSubview:callUsLabel];
    
    xPos   = 13.0;
    yPos   = callUsLabel.frame.size.height;
    width  =  150.0;
    height = callUs.frame.size.height/2 ;
    UILabel * tollFree = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    tollFree.text = NSLocalizedString(@"Toll free number :", @"");
    tollFree.textColor = [UIColor grayColor];
    tollFree.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [callUs addSubview:tollFree];
    
    xPos   = tollFree.frame.size.width + 13.0;
    yPos   = callUsLabel.frame.size.height;
    width  =  150.0;
    height = callUs.frame.size.height/2+20;
    UILabel * tollFreeNumber = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    //OLD Code
//    tollFreeNumber.text = NSLocalizedString(@"1800 102 3600", @"");
    //NEW Code
    tollFreeNumber.text = NSLocalizedString(@"1800 102 3600 / 1800 180 3600", @"");
    tollFreeNumber.numberOfLines = 0;
    tollFreeNumber.textColor = [UIColor blackColor];
    tollFreeNumber.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [callUs addSubview:tollFreeNumber];
    
    xPos = 10.0;
    yPos = 7.0;
    width = 28.0;
    height = 27.0;
    UIImageView *emailUsImage =[self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailUsImage.image = [UIImage imageNamed:@"icon_email_us.png"];
    [emailUs addSubview:emailUsImage];
    
    xPos   = 50.0;
    yPos   = 0.0;
    width  =  frame.size.width;
    height = emailUs.frame.size.height/2;
    UILabel * emailUsLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailUsLabel.text = NSLocalizedString(@"Email Us", @"");
    emailUsLabel.textColor = [UIColor colorWithRed:(64.0/255.0) green:(120.0/255.0) blue:(182.0/255.0) alpha:1.0];
    emailUsLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:23.0];
    [emailUs addSubview:emailUsLabel];
    
    xPos   = 13.0;
    yPos   = emailUsLabel.frame.size.height;
    width  =  60.0;
    height = emailUs.frame.size.height/2 ;
    UILabel * email = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    email.text = NSLocalizedString(@"email :", @"");
    email.textColor = [UIColor grayColor];
    email.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [emailUs addSubview:email];
    
    xPos   = email.frame.size.width + 11.0;
    yPos   = emailUsLabel.frame.size.height;
    width  =  247.0;
    height = emailUs.frame.size.height/2 ;
    UILabel * emailId = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    emailId.text = NSLocalizedString(@"customerservice@hitpa.co.in", @"");
    emailId.textColor = [UIColor blackColor];
    emailId.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [emailUs addSubview:emailId];
    
    xPos = 12.0;
    yPos = 10.0;
    width = 28.0;
    height = 28.0;
    UIImageView *writeUsImage =[self createimageviewwithFrame:CGRectMake(xPos, yPos, width, height)];
    writeUsImage.image = [UIImage imageNamed:@"icon_write_us.png"];
    [writeUs addSubview:writeUsImage];
    
    xPos   = 50.0;
    yPos   = 5.0;
    width  =  frame.size.width;
    height = 40.0;
    UILabel * writeUsLabel = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    writeUsLabel.text = NSLocalizedString(@"Write Us", @"");
    writeUsLabel.textColor = [UIColor colorWithRed:(64.0/255.0) green:(120.0/255.0) blue:(182.0/255.0) alpha:1.0];
    writeUsLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:23.0];
    [writeUs addSubview:writeUsLabel];
    
    xPos   = 13.0;
    yPos   = writeUsLabel.frame.size.height + 5.0;
    width  =  300.0;
    height = 30.0;
    UILabel * write = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    write.text = NSLocalizedString(@"Registered and Corporate office", @"");
    write.textColor = [UIColor grayColor];
    write.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [writeUs addSubview:write];
    
    xPos   = 13.0;
    yPos   = write.frame.origin.y + write.frame.size.height - 25.0;
    width  =  300.0;
    height = writeUs.frame.size.height - (writeUsLabel.frame.size.height + write.frame.size.height);
    UILabel * writeUsAddress = [self createlabelwithFrame:CGRectMake(xPos, yPos, width, height)];
    //OLD Code
//    writeUsAddress.text = NSLocalizedString(@"Health Insurance TPA of India Ltd.\n3rd Floor, A-wing IFCI tower, 61,\nNehru Place, New Delhi - 110019.", @"");
    //New Code
    writeUsAddress.text = NSLocalizedString(@"Health Insurance TPA of India Ltd.\n2rd Floor, Majestic Omnia Building,\nA - 110, Sector - 4, Noida, UP - 201301 \nCIN - U85100DL2013PLC256581.", @"");
    writeUsAddress.textColor = [UIColor blackColor];
    writeUsAddress.numberOfLines = 0;
    writeUsAddress.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:18.0];
    [writeUs addSubview:writeUsAddress];
    
    UITapGestureRecognizer *tapContactCall = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contactCallTapped:)];
    callUs.tag = kContactCall;
    //[callUs addGestureRecognizer:tapContactCall];
    
    UITapGestureRecognizer *tapEmail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contactEmailTapped:)];
    emailUs.tag = kContactEmail;
    //[emailUs addGestureRecognizer:tapEmail];
    
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

#pragma mark - Button delegate
- (void)contactCallTapped:(UITapGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        UIView *callView = (UIView *)[self.view viewWithTag:kContactCall];
        callView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        UIView *callView = (UIView *)[self.view viewWithTag:kContactCall];
        callView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        alertView(@"Do you want to call?", @"1800 102 3600", self, @"Yes", @"No",kContactCall);
        
    }];
    
}

- (void)contactEmailTapped:(UITapGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        UIView *emailView = (UIView *)[self.view viewWithTag:kContactEmail];
        emailView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        UIView *emailView = (UIView *)[self.view viewWithTag:kContactEmail];
        emailView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        NSArray *toRecipents = [NSArray arrayWithObject:@"customerservice@hitpa.co.in"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:toRecipents];
        [self presentViewController:mc animated:YES completion:NULL];

        
//        UIView *emailView = (UIView *)[self.view viewWithTag:kContactEmail];
//        emailView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        alertView(@"Do you want to send email?", @"customerservice@hitpa.co.in", self, @"Yes", @"No",kContactEmail);
        
    }];
    
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kContactCall) {
        
        if (buttonIndex == 0)
        {
            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",@"18001023600" ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
            NSLog(@"phone call to %@", phoneCallNum);
            
        }else
        {
            return;
        }
        
    }
//    else if (alertView.tag == kContactEmail){
//        if (buttonIndex == 0)
//        {
//            
//            NSArray *toRecipents = [NSArray arrayWithObject:@"customerservice@hitpa.co.in"];
//            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//            mc.mailComposeDelegate = self;
//            [mc setToRecipients:toRecipents];
//            [self presentViewController:mc animated:YES completion:NULL];
//            
//            
//        }else
//        {
//            return;
//        }
//    }
    
}

#pragma mark - Mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
