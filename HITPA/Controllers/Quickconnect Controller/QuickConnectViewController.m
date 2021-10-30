//
//  QuickConnectViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/7/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "QuickConnectViewController.h"
#import "Constants.h"
#import "Configuration.h"
#import "Utility.h"
#import <MessageUI/MessageUI.h>
#import "HITPAAPI.h"
#import "QuickConnet.h"
#import "CoreData.h"
#import "BranchLocatorViewController.h"

NSUInteger  const kQuickconnectCall      = 101;
NSUInteger  const kQuickconnectEmail     = 102;
NSUInteger  const kQuickconnectLocate    = 103;
NSUInteger  const kQuickconnectAdvisor   = 104;

@interface QuickConnectViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic)QuickConnet *quickConnect;

@end

@implementation QuickConnectViewController
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self quickconnectView];
    
    if ([[[CoreData shareData] getQuickConnectDetail] count] > 0) {
        
        self.quickConnect = [QuickConnet getQuickConnectDetailsByResponse:[[CoreData shareData] getQuickConnectDetail]];
        
    }else{
        
        [self showHUDWithMessage:@""];
        [[HITPAAPI shareAPI] getQuickConnectDetailsWithParams:nil completionHandler:^(NSDictionary *response ,NSError *error){
            
            [self didReceiveQuickConnectResponse:response error:error];
            
        }];
        
    }
    
}

- (void)quickconnectView
{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.userInteractionEnabled = NO;
    self.tableView.scrollEnabled = NO;
//    self.navigationItem.title = NSLocalizedString(@"Quick Connect", @"");
    self.navigationItem.title = NSLocalizedString(@"Contact Us", @"");
    CGFloat xPos, yPos, startXPos, startYPos, endXPos, endYPos, width, height;
    CGRect frame = [self bounds];
    
    //call  view
    startXPos    =   10.0 ;
    startYPos    =   10.0;
//    width   =   frame.size.width - 20.0 ;
    width   =   (frame.size.width-30)/2 ;
    height  =   115.0;
    UIView *callView =[[UIView alloc]initWithFrame:CGRectMake(startXPos, startYPos, width, height)];
    callView.backgroundColor = [UIColor colorWithRed:61.0/255.0f green:144.0/255.0f blue:136.0/255.0f alpha:1.0];
    callView.tag = kQuickconnectCall;
    callView.layer.cornerRadius = 2.0;
    callView.layer.masksToBounds = YES;
    callView.layer.shadowColor = [UIColor blackColor].CGColor;
    callView.layer.shadowOpacity = 0.8;
    callView.layer.shadowRadius = 5.0;
    callView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    [self.view addSubview:callView];
    
    //Email View
//    yPos = callView.frame.origin.y + callView.frame.size.height + 16.0;
    endXPos =  callView.frame.size.width + 20;
    endYPos = startYPos;
    UIView *emailView =[[UIView alloc]initWithFrame:CGRectMake(endXPos, endYPos, width, height)];
    emailView.backgroundColor = [UIColor colorWithRed:218.0/255.0f green:66.0/255.0f blue:73.0/255.0f alpha:1.0];
    emailView.tag = kQuickconnectEmail;
    emailView.layer.cornerRadius = 2.0;
    emailView.layer.masksToBounds = YES;
    emailView.layer.shadowColor = [UIColor blackColor].CGColor;
    emailView.layer.shadowOpacity = 0.8;
    emailView.layer.shadowRadius = 5.0;
    emailView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    [self.view addSubview:emailView];
    
    //Locate View
    startYPos = callView.frame.origin.y + callView.frame.size.height + 10.0;
    UIView *locateView = [[UIView alloc]initWithFrame:CGRectMake(startXPos, startYPos, width, height)];
    locateView.backgroundColor = [UIColor colorWithRed:219.0/255.0f green:170.0/255.0f blue:43.0/255.0f alpha:1.0];
    locateView.tag = kQuickconnectLocate;
    locateView.layer.cornerRadius = 2.0;
    locateView.layer.masksToBounds = YES;
    locateView.layer.shadowColor = [UIColor blackColor].CGColor;
    locateView.layer.shadowOpacity = 0.8;
    locateView.layer.shadowRadius = 5.0;
    locateView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    [self.view addSubview:locateView];
    
    // call tool free label
    xPos   = 0.0;
    yPos   = callView.frame.size.height - 40.0;
    width  = callView.frame.size.width;
    height = 40.0;
    UILabel *callLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    callLabel.text =NSLocalizedString(quickcalltollFree, nil);
    callLabel.textAlignment = NSTextAlignmentCenter;
    callLabel.textColor = [UIColor whiteColor];
    if (IS_IPHONE) {
        callLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0];
    } else {
        callLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:20.0];
    }
    
    [callView addSubview:callLabel];
    
    //Email label
    xPos   = 0.0;
    yPos   = emailView.frame.size.height - 40.0;
    width  = emailView.frame.size.width;
    height = 40.0;
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    emailLabel.text =NSLocalizedString(quickEmail, nil);
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.textColor = [UIColor whiteColor];
    if (IS_IPHONE) {
        emailLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0];
    } else {
        emailLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:20.0];
    }
    
    [emailView addSubview:emailLabel];
    
    //  Locate a branch label
    xPos    = 0.0;
    yPos    = locateView.frame.size.height - 40.0;
    width   = locateView.frame.size.width;
    height  = 40.0;
    UILabel *locateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    locateLabel.text = NSLocalizedString(quicklocateBranch, nil);
    locateLabel.textAlignment = NSTextAlignmentCenter;
    locateLabel.textColor = [UIColor whiteColor];
     if (IS_IPHONE) {
         locateLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:16.0];
     } else {
         locateLabel.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:20.0];
     }
    
    [locateView addSubview:locateLabel];
    
    width   = 50.0;
    height  = 50.0;
    yPos    = 10.0;
    xPos    = callView.frame.size.width/2-width/2;
    UIImageView *callImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:[UIImage imageNamed:@"icon_quickcall"]];
    [callView addSubview:callImageView];
    
    width   = 60.0;
    height  = 60.0;
    yPos    = 8.0;
    xPos    = emailView.frame.size.width/2-width/2;
    UIImageView *mailImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:[UIImage imageNamed:@"icon_quickemail"]];
    [emailView addSubview:mailImageView];
    
    
    width   = 70.0;
    height  = 70.0;
    yPos    = 6.0;
    xPos    = locateView.frame.size.width/2-width/2;
    UIImageView *branchImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:[UIImage imageNamed:@"icon_quicklocate"]];
    [locateView addSubview:branchImageView];
    
    UITapGestureRecognizer *callGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callGuestureTapped:)];
    [callView addGestureRecognizer:callGuesture];
    
    UITapGestureRecognizer *emailGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emailGuestureTapped:)];
    [emailView addGestureRecognizer:emailGuesture];
    
    UITapGestureRecognizer *locateGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locateGuestureTapped:)];
    [locateView addGestureRecognizer:locateGuesture];
    
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 140.0, frame.size.width, frame.size.height - 140.0);
    [self.view layoutIfNeeded];
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

#pragma mark - Handler

- (void)didReceiveQuickConnectResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    [[CoreData shareData] setQuickConnectDetailsWithResponse:response];
    self.quickConnect = [QuickConnet getQuickConnectDetailsByResponse:response];
    
}

#pragma mark - Guesture
- (void)callGuestureTapped:(UITapGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        UIView *callView = (UIView *)[self.view viewWithTag:kQuickconnectCall];
        callView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        
    } completion:^(BOOL finished) {
        
        UIView *callView = (UIView *)[self.view viewWithTag:kQuickconnectCall];
        callView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        NSArray *arrayNumbers = [[self.quickConnect valueForKey:@"tollfreeNumber"] componentsSeparatedByString:@"/"];
        
        if ([arrayNumbers count] > 0) {
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[[Configuration shareConfiguration] appName] message:@"Do you want to call ?" preferredStyle:UIAlertControllerStyleAlert];
                
            UIAlertAction *firstNumber = [UIAlertAction actionWithTitle:[arrayNumbers objectAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
            NSString *stringNumber = [[arrayNumbers objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",stringNumber];
                    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
                    
            NSLog(@"phone call to %@", phoneCallNum);
                    
            }];
                
            UIAlertAction *secondNumber = [UIAlertAction actionWithTitle:[arrayNumbers objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
            NSString *stringNumber = [[arrayNumbers objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",stringNumber];
                    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
                    
            NSLog(@"phone call to %@", phoneCallNum);
                    
            }];
            
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];

            [actionSheet addAction:firstNumber];
            [actionSheet addAction:secondNumber];
            [actionSheet addAction:alertCancel];
            
            [self presentViewController:actionSheet animated:YES completion:nil];
            
        }else{
            
            alertView(@"Do you want to call?", @"No Numbers", nil, @"Ok", nil,kQuickconnectCall);
            return ;
        }
        
    }];
    
}

- (void)locateGuestureTapped:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        UIView *mapView = (UIView *)[self.view viewWithTag:kQuickconnectLocate];
        mapView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
    } completion:^(BOOL finished) {
        
        UIView *mapView = (UIView *)[self.view viewWithTag:kQuickconnectLocate];
        mapView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
//        NSString *str = [NSString stringWithFormat:@"1. %@\n\n2. %@",[self.quickConnect valueForKey:@"address"],[self.quickConnect valueForKey:@"address"]];
        
        BranchLocatorViewController *vctr = [[BranchLocatorViewController alloc]init];
        [self.navigationController pushViewController:vctr animated:YES];
                
    }];
    
}

- (void)emailGuestureTapped:(UITapGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:1];
        UIView *emailView = (UIView *)[self.view viewWithTag:kQuickconnectEmail];
        emailView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
    } completion:^(BOOL finished) {
        
        NSArray *toRecipents = [NSArray arrayWithObject:[self.quickConnect valueForKey:@"mailID"]];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:toRecipents];
        // Present mail view controller on screen
        if (mc != nil) {
            [self presentViewController:mc animated:YES completion:NULL];
        }
        UIView *emailView = (UIView *)[self.view viewWithTag:kQuickconnectEmail];
        emailView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
    
}

#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kQuickconnectCall) {
        
        if (buttonIndex == 0)
        {
            
            
        }else
        {
            return;
        }
        
    }else if (alertView.tag == kQuickconnectEmail){
        if (buttonIndex == 0)
        {
            
            
        }else
        {
            return;
        }
    }
    else if (alertView.tag == kQuickconnectLocate){
        if (buttonIndex == 0)
        {
            
            
        }else
        {
            return;
        }
    }
    
}

#pragma mark - Mail compose delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
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
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
