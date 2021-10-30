//
//  BaseViewController.h
//  HITPA
//
//  Created by Bhaskar C M on 12/3/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HITPAAppDelegate.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (CGRect)bounds;

- (void)reloadTableView;

- (void)showHUDWithMessage:(NSString *)message;

- (void)showSuccessHUDWithMessage:(NSString *)message;

- (void)showErrorHUDWithMessage:(NSString *)message;

- (void)hideHUD;

- (void)rightBarBackButton;

@property (nonatomic, strong) HITPAAppDelegate *appDelegate;;

@end
