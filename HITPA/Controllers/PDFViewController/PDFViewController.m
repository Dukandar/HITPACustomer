//
//  PDFViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 02/08/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "PDFViewController.h"
#import "UserManager.h"
#import "DocumentDirectory.h"
#import "Utility.h"
#import "Configuration.h"
#import <WebKit/WebKit.h>

@interface PDFViewController () <UIWebViewDelegate>
@property(strong,nonatomic) WKWebView *webView;

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pdfView];
}

- (void)pdfView
{
    CGRect frame = [self bounds];
    _webView = [[WKWebView alloc] initWithFrame:frame];
    NSString *baseurl = [[[Configuration shareConfiguration] baseURL]stringByReplacingOccurrencesOfString:@"api/" withString:@""];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@content/Forms/%@.pdf",baseurl,self.formName]]]];
    _webView.autoresizesSubviews = YES;
    [self.view addSubview:_webView];
 
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
