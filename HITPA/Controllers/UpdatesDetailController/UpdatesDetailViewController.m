//
//  UpdatesDetailViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "UpdatesDetailViewController.h"
#import "Utility.h"
#import "Configuration.h"
#import "FeedbackViewController.h"
#import "UserManager.h"


NSString * const kFeedbackMessagee           = @"Feedback is already given!";

@interface UpdatesDetailViewController ()

@property (nonatomic, strong) MyPolicyModel *updatesDetail;

@end

@implementation UpdatesDetailViewController

- (instancetype)initWithResponse:(MyPolicyModel *)response
{
    
    
    self = [super init];
    if (self)
    {
        
        self.updatesDetail = response;
    }
    
    return self;
    
    
}
#pragma mark  -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Claim Details", @"");
    self.tableView.backgroundColor = [UIColor clearColor];
    [self reloadTableView];
    // Do any additional setup after loading the view.
}


-(void)viewDidLayoutSubviews
{
    
    CGRect frame  = [self bounds];
    if([self.updatesDetail.claimStatus isEqualToString:@"Claim Settled"] || [self.updatesDetail.claimStatus isEqualToString:@"Settled"]) {
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 70);
    } else {
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 50);
    }
    
    [self.view layoutIfNeeded];
    
    
}

#pragma mark -  Table View data source and delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.updatesDetail.claimStatus isEqualToString:@"Claim Settled"] || [self.updatesDetail.claimStatus isEqualToString:@"Settled"]) {
            return 15;
        }
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.updatesDetail.claimStatus isEqualToString:@"Claim Settled"] || [self.updatesDetail.claimStatus isEqualToString:@"Settled"]) {
        if(indexPath.row == 14) {
            return 40.0;
        } else {
            return 36.0;
        }
    }
    return 36.0;
    
}

-(UpdatesDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UpdatesDetailTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[UpdatesDetailTableViewCell alloc]initWithDelegate:self indexPath:indexPath updateDetails:self.updatesDetail];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
    }
    
    return cell;
    
    
}

- (void)feedbackWithIndex:(NSInteger)index feedbackStatus:(NSString *)status andUpdateDetails:(ClaimsJunction *)updateDetails {
    
    if([status isEqualToString:@"True"]) {
//    if([status isEqualToString:@"False"]) { //Feedback Test
        alertView([[Configuration shareConfiguration] appName], kFeedbackMessagee, nil, @"Ok", nil, 0);
    }
    else {
//        ClaimsJunction *details = [[self.claimsHistoryDetails valueForKey:@"history"]objectAtIndex:index];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [dict setValue:updateDetails.claimNumber forKey:@"ClaimNo"];
        [dict setValue:updateDetails.coverage forKey:@"amountEnhanced"];
        [dict setValue:updateDetails.consumed forKey:@"dischargeAmount"];
        FeedbackViewController *vctr = [[FeedbackViewController alloc]initWithUpdateDetails:dict];
        [self.navigationController pushViewController:vctr animated:YES];
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
