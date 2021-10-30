//
//  UpdatesViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/9/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "UpdatesViewController.h"
#import "Configuration.h"
#import "HITPAUserDefaults.h"
#import "MyPolicyModel.h"
#import "Updates.h"
#import "HITPAAPI.h"
#import "UpdatesDetailViewController.h"
#import "UserManager.h"
#import "CoreData.h"
#import "MyPolicyModel.h"
#import "ClaimsJunction.h"

NSInteger  const kUpdateStausLabelTag = 55555;


@interface UpdatesViewController ()
@property (nonatomic , readwrite)       MyPolicyModel       *updateDetail;
@property (nonatomic, strong)           NSMutableDictionary *updatesDetails;
@property (nonatomic, strong)           MyPolicyModel       *myPolicyDetails;

@end

@implementation UpdatesViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Live Track", @"");
    self.tableView.backgroundColor = [UIColor clearColor];
    self.updatesDetails = [[NSMutableDictionary alloc]init];
    
    CGRect frame = [self bounds];
    CGFloat xPos,yPos, width, height;
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kUpdateStausLabelTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No Updates";
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0]];
    [self.tableView addSubview:statusLabel];
    
//    [self updatesHandler];
    // Do any additional setup after loading the view.
}



-(void)viewDidLayoutSubviews
{
    
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 8.0, frame.size.width, frame.size.height - 75.0);
    [self.view layoutIfNeeded];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self updatesHandler];
}

#pragma mark - Handler
- (void)updatesHandler
{
    [(UILabel *)[self.view viewWithTag:kUpdateStausLabelTag] setHidden:YES];

    /*if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        

        NSDictionary *response = [[CoreData shareData] getPolicyDetail];
        NSMutableArray *updatesDetail = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionary in [response valueForKey:@"PolicyDetails"]) {
            MyPolicyModel *home = [MyPolicyModel getPolicyHistoryDetailsByResponse:dictionary];
            [updatesDetail addObject:home];
        }
        [self.updatesDetails setValue:updatesDetail forKey:@"updates"];
        
        if ([updatesDetail count] == 0) {
            
            [(UILabel *)[self.view viewWithTag:kUpdateStausLabelTag] setHidden:NO];
            
        }
        
        [self reloadTableView];
        
    }else{
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyResponse:response error:error];
        }];
    }*/
    [self showHUDWithMessage:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[[UserManager sharedUserManager] userName] forKey:@"userid"];
    [param setValue:@"LiveTransactions" forKey:@"statusType"];
    [[HITPAAPI shareAPI] getIntimationWithParam:param completionHandler:^(NSDictionary *response, NSError *error){
        
        [self didReceiveClaimsHistoryResponse:response error:error];
        
    }];

    
}

- (void)didReceiveClaimsHistoryResponse:(NSDictionary *)response error:(NSError *)error
{
    [(UILabel *)[self.view viewWithTag:kUpdateStausLabelTag] setHidden:YES];

    [self hideHUD];
    
    
    NSMutableArray *updatesDetail = [[NSMutableArray alloc]init];
    self.myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:[[CoreData shareData] getPolicyDetail]];

    for (NSDictionary *dictionary in response) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [dict setValue:self.myPolicyDetails.contactNo forKey:@"Contactno"];
            [dict setValue:self.myPolicyDetails.email forKey:@"Email"];
            ClaimsJunction *history = [ClaimsJunction getClaimsHistoryDetailsByResponse:dict];
            [updatesDetail addObject:history];

        }
        
    }
    
    [self.updatesDetails setValue:updatesDetail forKey:@"updates"];

    if ([updatesDetail count] == 0) {
        
        [(UILabel *)[self.view viewWithTag:kUpdateStausLabelTag] setHidden:NO];

    }
    
    [self reloadTableView];
    
    
}


#pragma mark - Table View Data source and  Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.updatesDetails valueForKey:@"updates"] count];
    
}

-(UpdatesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UpdatesTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[UpdatesTableViewCell alloc]initWithDelegate:self indexPath:indexPath response:(NSMutableArray *)[[[self.updatesDetails valueForKey:@"updates"]reverseObjectEnumerator]allObjects]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    UpdatesDetailViewController *vctr = [[UpdatesDetailViewController alloc]initWithResponse:[[[[self.updatesDetails valueForKey:@"updates"]reverseObjectEnumerator]allObjects] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vctr animated:YES];
    
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
