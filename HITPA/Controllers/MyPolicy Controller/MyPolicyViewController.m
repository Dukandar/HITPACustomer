//
//  MyPolicyViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 03/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "MyPolicyViewController.h"
#import "Configuration.h"
#import "MyPolicyTableViewCell.h"
#import "Constants.h"
#import "MyPolicyModel.h"
#import "CoreData.h"
#import "HITPAAPI.h"
#import "UserManager.h"
#import "HITPAUserDefaults.h"
#import "DocumentDirectory.h"

NSInteger const kSegmentControlTag  = 80000;
NSInteger const kTableHeaderTag     = 90000;
NSInteger const kMyPolicyStatusTag  = 54321;

@interface MyPolicyViewController () <UITableViewDataSource, UITableViewDelegate, myPolicyTableViewCell>

@property (nonatomic, strong)       NSMutableArray        * expandCollapse;
@property (nonatomic, strong)       MyPolicyModel         * myPolicyDetails;
@property (nonatomic, strong)       UISegmentedControl    * segmentedControl;
@property (nonatomic, readwrite)    PolicySectionType       policySectionType;
@property (nonatomic, strong)       NSMutableDictionary   * cardDetails;

@end

@implementation MyPolicyViewController
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.policySectionType = PolicyDetails;
    self.expandCollapse = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],nil];
    [self policyHandler];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 40.0, frame.size.width, frame.size.height - 98.0);
    [self.view layoutIfNeeded];
    
}

- (void)myPolicyView
{
    
    self.navigationItem.title = NSLocalizedString(@"My Policy", @"");
    CGRect frame = [self bounds];
    CGFloat xPos = 5.0;
    CGFloat yPos = 4.0;
    CGFloat width =  frame.size.width - 2 * xPos;
    CGFloat height = 30.0;
    //segment control
    NSArray *itemArray = [NSArray arrayWithObjects: @"POLICY DETAILS", @"MCARD", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake(xPos, yPos, width, height);
    self.segmentedControl.tintColor = [UIColor colorWithRed:15/255.0 green:144/255.0 blue:171/255.0 alpha:1.0];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.layer.cornerRadius = 5.0;
    self.segmentedControl.layer.masksToBounds = YES;
    self.segmentedControl.tag = kSegmentControlTag;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];
    [self headerView];
    
}

- (void)headerView
{
    
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    //table header view
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = frame.size.height / 3.0;
    UIView *tableHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    tableHeader.tag = kTableHeaderTag;
    NSMutableArray *tableDetails;
    if ([self.myPolicyDetails.policyType isEqualToString:@"Corporate"])
    {
        tableDetails = [[NSMutableArray alloc]initWithObjects:@"Policy Number :", @"From :", @"To :", @"Member ID :", @"Member Name :", @"Member Age :", @"Relationship :", @"Gender :", @"Employee ID :", @"Company :", nil];
    }
    else {
        tableDetails = [[NSMutableArray alloc]initWithObjects:@"Policy Number :", @"From :", @"To :", @"Member ID :", @"Member Name :", @"Member Age :", @"Relationship :", @"Gender :", nil];
    }
    
    if ([self.myPolicyDetails.policyStatus isEqualToString:@"Floater"])
    {
        [tableDetails addObject:@"SI :"];
        [tableDetails addObject:@"BSI :"];
    }
    
    NSString *strFromDate = self.myPolicyDetails.policyFrom;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *fromDate = [dateFormatter dateFromString:strFromDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *fromDateString = [dateFormatter stringFromDate:fromDate];
    

    NSString *strToDate = self.myPolicyDetails.policyTo;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    NSDate *toDate = [dateFormatter dateFromString:strToDate];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *toDateString = [dateFormatter stringFromDate:toDate];
    
//    NSString *stringTo = self.myPolicyDetails.policyTo;
//    stringTo = [stringTo substringToIndex:[stringTo length] - 9];
//    NSString *stringFrom = self.myPolicyDetails.policyFrom;
//    stringFrom = [stringFrom substringToIndex:[stringFrom length] - 9];
    
    NSArray *memberDetails = self.myPolicyDetails.memberDetails;
    NSLog(@"memberDetails:%@", memberDetails);
    NSString *filter = @"%K CONTAINS[cd] %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter,@"MemberRelationship",@"Self"];
    memberDetails = [memberDetails filteredArrayUsingPredicate:predicate];
     NSArray *tableValues;
    if ([self.myPolicyDetails.policyType isEqualToString:@"Corporate"])
    {
        tableValues = [[NSArray alloc]initWithObjects:self.myPolicyDetails.policyNumber, fromDateString, toDateString, self.myPolicyDetails.memberID, self.myPolicyDetails.memberName, self.myPolicyDetails.memberAge, self.myPolicyDetails.relationship, self.myPolicyDetails.policyGender, self.myPolicyDetails.employeeID, self.myPolicyDetails.policyCompany,(self.myPolicyDetails.SI != nil)?self.myPolicyDetails.SI:@"NA",(self.myPolicyDetails.BSI != nil)?self.myPolicyDetails.BSI:@"", nil];
    }else
    {
        tableValues = [[NSArray alloc]initWithObjects:self.myPolicyDetails.policyNumber, fromDateString, toDateString, self.myPolicyDetails.memberID, self.myPolicyDetails.memberName, self.myPolicyDetails.memberAge, self.myPolicyDetails.relationship, self.myPolicyDetails.policyGender,([memberDetails count] > 0)?[[memberDetails objectAtIndex:0] valueForKey:@"sumInsured"]:@"",([memberDetails count] > 0)?[[memberDetails objectAtIndex:0] valueForKey:@"balanceSumInsured"]:@"", nil];
    }
    NSLog(@"tableValues :%@", tableValues);
    yPos = 20.0;
    width = frame.size.width;
    height = frame.size.height / 3.0 - 2 * yPos;
    UIView *view = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor whiteColor]];
    [tableHeader addSubview:view];
    yPos = 5.0;
    for (int i = 0; i < [tableDetails count]; i++)
    {
        xPos = 10.0;
        width = frame.size.width / 3.0 - 10.0;
        height = 20.0;
        UILabel *policyNo = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[tableDetails objectAtIndex:i] fontSize:12.0 fontColor:[UIColor grayColor]  alignment:NSTextAlignmentRight];
        [view addSubview:policyNo];
        
        xPos = policyNo.frame.origin.x + policyNo.frame.size.width + 10.0;
        width = frame.size.width - xPos - 5.0;
        height = 20.0;
        UILabel *policyNoValue = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:([tableValues objectAtIndex:i] !=nil && ![[tableValues objectAtIndex:i] isKindOfClass:[NSNull class]])?[tableValues objectAtIndex:i]:@"NA" fontSize:13.0 fontColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        policyNoValue.numberOfLines = 0;
        [policyNoValue sizeToFit];
        [view addSubview:policyNoValue];
        policyNo.frame = CGRectMake(policyNo.frame.origin.x, policyNo.frame.origin.y, policyNo.frame.size.width, policyNoValue.frame.size.height);
        yPos = policyNoValue.frame.origin.y + policyNoValue.frame.size.height + 5.0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, yPos);
        tableHeader.frame = CGRectMake(tableHeader.frame.origin.x, tableHeader.frame.origin.y, tableHeader.frame.size.width, view.frame.size.height + 40.0);
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        self.tableView.tableHeaderView = tableHeader;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    
    [self reloadTableView];
    
}

- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    return view;
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

#pragma mark - Policy Handler
- (void)policyHandler
{
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        
        self.myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:[[CoreData shareData] getPolicyDetail]];
        [self myPolicyView];
        
    }else{
        
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyResponse:response error:error];
        }];
    }
    
    [self writeMyPolicyImagesIntoDocumentDirectory];
}

- (void)didReceivePolicyResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    
    CGRect frame = [self bounds];
    CGFloat xPos,yPos,width,height;
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kMyPolicyStatusTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No policy details";
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0]];
    [self.tableView addSubview:statusLabel];
    
    if ([[response valueForKey:@"Message"] length] > 0) {
        
        [(UILabel *)[self.view viewWithTag:kMyPolicyStatusTag] setHidden:NO];

    }
    else
    {
        [[CoreData shareData] setMyPolicyDetailsWithResponse:response];
        self.myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:response];
        [self myPolicyView];
    }
    
}

- (void)writeMyPolicyImagesIntoDocumentDirectory {
    //    policyDetail.memberDetails
    //NSLog(@"Member Details:%@", self.myPolicyDetails.memberDetails);
    for (MyPolicyModel *myPolicyDetailsObj in self.myPolicyDetails.memberDetails) {
        NSString *stringName = [myPolicyDetailsObj valueForKey:@"MemberName"];
        NSString *imageNamee = [stringName stringByReplacingOccurrencesOfString: @" " withString:@"_"];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", imageNamee];
        [[DocumentDirectory shareDocumentDirectory] removeImageOrPdfWithName:imageName];
        
        if ([myPolicyDetailsObj valueForKey:@"Photo"] != nil) {
            NSString *originalString = [NSString stringWithFormat:@"%@", [myPolicyDetailsObj valueForKey:@"Photo"]];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:originalString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if ([[DocumentDirectory shareDocumentDirectory] writeImageOrPdfIntoDocumentDirectory:imageData imageName:imageName]) {
                NSLog(@"Image Data Written into Document");
            }
        }
    }
}

#pragma mark - TabelView data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([(UISegmentedControl *)[self.view viewWithTag:kSegmentControlTag]selectedSegmentIndex] == 0)
    {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.policySectionType == PolicyDetails)
    {
        if([[self.expandCollapse objectAtIndex:section]boolValue])
        {
            
            return (self.myPolicyDetails.memberDetails.count > 0)?self.myPolicyDetails.memberDetails.count:1;
        }
        
    }else if(self.policySectionType == MemberCard)
    {
        return [self.myPolicyDetails.memberDetails count];
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.policySectionType == PolicyDetails)
    {
        if([[self.expandCollapse objectAtIndex:indexPath.section]boolValue])
        {
            return (self.myPolicyDetails.memberDetails.count > 0)?([self.myPolicyDetails.policyStatus isEqualToString:@"Floater"])?130:190:44.0;
        }

    }else if (self.policySectionType == MemberCard)
    {
        return 290.0;
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *leftImage, *rightImage;
    NSString *title;
    UIColor *color;
    switch (section)
    {
        case 0:
            leftImage = [UIImage imageNamed:@"icon_policy-2.png"];
            title = @"Members Enrolled in Family";
            color = [UIColor colorWithRed:206/255.0 green:161/255.0 blue:40/255.0 alpha:1.0];;
            break;
        default:
            break;
    }
    
    if([[self.expandCollapse objectAtIndex:section]boolValue])
    {
        rightImage = minusImage;
    }
    else
    {
        rightImage = plusImage;
    }
    
    CGRect frame = [self bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width =  frame.size.width;
    CGFloat height = 50.0;
    UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:color];
    sectionHeader.tag = section;
    
    UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionGestureTapped:)];
    [sectionHeader addGestureRecognizer:sectionTap];
    
    //left Image View
    xPos = 10.0;
    yPos = 10.0;
    width = 30.0;
    height = 30.0;
    UIImageView *leftImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:leftImage];
    [sectionHeader addSubview:leftImageView];
    
    //section title
    xPos = leftImageView.frame.origin.x + leftImageView.frame.size.width + 10.0;
    width = frame.size.width - xPos - 40.0;
    height = 30.0;
    UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:title fontSize:16.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [sectionHeader addSubview:sectionTitle];
    
    //right Image View
    xPos = sectionTitle.frame.origin.x + sectionTitle.frame.size.width + 10.0;
    yPos = 15.0;
    width = 20.0;
    height = 20.0;
    UIImageView *rightImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:rightImage];
    rightImageView.tag = 2222;
    [sectionHeader addSubview:rightImageView];
    return sectionHeader;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.policySectionType == PolicyDetails) {
        return 50.0f;

    }
    else
    {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return  sectionFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}


- (MyPolicyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyPolicyTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[MyPolicyTableViewCell alloc]initWithIndexPath:indexPath delegate:self policyDetail:self.myPolicyDetails policySectionType:self.policySectionType cardDetails:self.cardDetails];
    }
    if([[self.expandCollapse objectAtIndex:indexPath.section]boolValue])
    {
        cell.backgroundColor = (self.policySectionType == PolicyDetails)?[UIColor whiteColor]:[UIColor clearColor];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        
    }
    return cell;
}

#pragma  mark  - Protocol

- (void)postClaimsWithParams:(NSMutableDictionary *)params
{
    
}

#pragma mark - Gesture Recognizer
- (void)sectionGestureTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:gestureRecognizer.view.tag];
    BOOL isBoolValue = [[self.expandCollapse objectAtIndex:indexPath.section] boolValue];
    isBoolValue = !isBoolValue;
    [self.expandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
    NSRange range = NSMakeRange(indexPath.section, 1);
    NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - SegmentControl Delegate

- (void)segmentChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.policySectionType = PolicyDetails;
        [self headerView];

    }
    else if (sender.selectedSegmentIndex == 1)
    {
        self.policySectionType = MemberCard;
        [self headerView];
        
        [self intilizationsCardDetails];
        [self reloadTableView];

    }
    
}

#pragma mark -
- (void)intilizationsCardDetails
{
    if (!self.cardDetails)
        self.cardDetails = [[NSMutableDictionary alloc]init];
    
    NSArray *cardDetails = self.myPolicyDetails.memberDetails;
    
    for (int i = 0; i < [cardDetails count] + 1; i++) {
        
        [self.cardDetails setValue:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
    
}

- (void)cardTypeWithIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[self.cardDetails valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue]  == 0)
    {
        [self.cardDetails setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if ([[self.cardDetails valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] integerValue]  == 1)
    {
        [self.cardDetails setValue:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
//    NSArray *indexpaths = [[NSArray alloc]initWithObjects:indexPath, nil];
//    [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationFade];

    [self reloadTableView];
    
//    [UIView transitionWithView:self.tableView
//                      duration:0.40f
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^(void) {[self reloadTableView];}
//                    completion:nil];

}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
