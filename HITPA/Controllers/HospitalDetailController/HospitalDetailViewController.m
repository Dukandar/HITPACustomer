//
//  HospitalDetailViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 1/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "HospitalDetailViewController.h"

@interface HospitalDetailViewController ()

@property (nonatomic, strong) NSMutableDictionary *hospitalDetail;

@end

@implementation HospitalDetailViewController


#pragma mark - instancetype
- (instancetype)initWithResponse:(NSMutableDictionary *)response
{
    self.hospitalDetail = [[NSMutableDictionary alloc]init];
    
    self = [super init];
    if (self)
    {
        
        self.hospitalDetail = response;
        
    }
    
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Hospital Details", @"");
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self reloadTableView];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 172.0);
    [self.view layoutIfNeeded];
    
    
}

#pragma Table Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 100.0;
    }else{
        return 50.0;
    }
    
}

-(HospitalDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HospitalDetailTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[HospitalDetailTableViewCell alloc]initWithDelegate:self indexPath:indexPath response:self.hospitalDetail];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
    }
    
    return cell;
    
    
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
