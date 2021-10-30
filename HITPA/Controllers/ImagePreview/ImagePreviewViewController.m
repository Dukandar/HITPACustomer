//
//  ImagePreviewViewController.m
//  HITPA
//
//  Created by Sunilkumar Basappa on 02/12/20.
//  Copyright © 2020 Bathi Babu. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "Gradients.h"
#import "DocumentDirectory.h"
#import <WebKit/WebKit.h>


@interface ImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Wellness Tip", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self barItems];
    NSURL *url = [NSURL fileURLWithPath:self.imagePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
