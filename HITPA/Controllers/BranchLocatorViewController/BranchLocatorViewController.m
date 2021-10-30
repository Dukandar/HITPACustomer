//
//  BranchLocatorViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 07/11/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "BranchLocatorViewController.h"
#import "HITPAAPI.h"
#import "CoreData.h"
#import "Configuration.h"
#import "BranchLocatorTableViewCell.h"
#import "Constants.h"
#import "Utility.h"
#import "BranchLocator.h"
#import "UIManager.h"

NSUInteger  const kBranchSearchTag       = 300001;
NSUInteger  const kBranchStatusLabelTag  = 300002;
NSUInteger  const kBranchLoadingTag      = 300003;

@interface BranchLocatorViewController ()<UISearchBarDelegate, branchLocatorTableViewCell,UIAlertViewDelegate>

@property (nonatomic, strong)       NSMutableArray         *expandCollapse;
@property (nonatomic, strong)       NSMutableArray         *branchLocationsArray;
@property (nonatomic, strong)       NSArray                *responseArray;
@property (nonatomic, strong)       NSString               *contactNumber;


@end

@implementation BranchLocatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"Locate Branch", @"");
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.expandCollapse = [[NSMutableArray alloc]init];
    self.contactNumber = @"";
    self.branchLocationsArray = [[NSMutableArray alloc]init];
    self.expandCollapse = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
    
    [self searchView];
    
    if ([[[CoreData shareData] getBranchLocationsDetails] count] > 0) {
        
        
        self.responseArray = [[CoreData shareData] getBranchLocationsDetails];
        [self sortBranches:self.responseArray];
        [self reloadTableView];
        
    }else{
//
        [self showHUDWithMessage:@""];
        [[HITPAAPI shareAPI] getBranchLocationsWithCompletionHandler:^(NSDictionary *response ,NSError *error){
            
            [self didReceiveBranchLocatorResponse:response error:error];
            
        }];
        
    }

}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 45.0, frame.size.width, frame.size.height - 110.0);
    [self.view layoutIfNeeded];
}

- (void)branchLocatorView
{
    
}

- (void)searchView
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    width = frame.size.width - 3.0;
    yPos = 4.0;
    xPos = 1.0;
    height = 37.0;
    UIView *search = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    search.backgroundColor = [UIColor whiteColor];
    search.layer.cornerRadius = 2.0;
    search.layer.masksToBounds = YES;
    
    yPos = 0.0;
    UISearchBar *searchName = [[UISearchBar alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    searchName.delegate = self;
    searchName.tag = kBranchSearchTag;
    searchName.searchBarStyle = UISearchBarStyleProminent;
   // UITextField *txfSearchField = [searchName valueForKey:@"_searchField"];
    //txfSearchField.backgroundColor= [UIColor colorWithRed:(207/255.0) green:(207/255.0) blue:(207/255.0) alpha:1.0f];
    searchName.barTintColor = [UIColor clearColor];
    searchName.backgroundImage = [UIImage new];
    searchName.placeholder = NSLocalizedString(@"State or City", @"");
    [search addSubview:searchName];
    [self.view addSubview:search];
    
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - search.frame.size.height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kBranchStatusLabelTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No Branches";
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0]];
    [self.tableView addSubview:statusLabel];
    //Bottom Loading View
    height = 30.0;
    width = frame.size.width;
    xPos = 0.0;
    yPos = frame.size.height - (height + 64.0);
    UIView *bottomLoadingView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7]];
    bottomLoadingView.tag = kBranchLoadingTag;
    [self.view addSubview:bottomLoadingView];
    
    //Loading Label
    xPos = 0.0;
    yPos = 0.0;
    width = bottomLoadingView.frame.size.width;
    height = bottomLoadingView.frame.size.height;
    UILabel *loadingLbl = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Loading ..." fontSize:12.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [bottomLoadingView addSubview:loadingLbl];
    
    [bottomLoadingView setHidden:YES];
    
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
    label.font = [[Configuration shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

#pragma mark - Table Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.branchLocationsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.expandCollapse objectAtIndex:section]boolValue])
    {
        NSArray *branches = [self.branchLocationsArray objectAtIndex:section];
        return branches.count;
    }
    return 0;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *rightImage;
    
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
    UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:15/255.0 green:144/255.0 blue:171/255.0 alpha:1.0]];
    sectionHeader.tag = section;
    
    UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionGestureTapped:)];
    [sectionHeader addGestureRecognizer:sectionTap];
    
    //left Image View
    xPos = 10.0;
    yPos = 10.0;
    width = 30.0;
    height = 30.0;
    UIImageView *leftImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:[UIImage imageNamed:@"icon_quicklocate.png"]];
    [sectionHeader addSubview:leftImageView];
    
     // Laft ImageView Button for Map Navigation
    UIButton *leftImageViewButton = [self createButtonWithFrame:CGRectMake(xPos, yPos, width, height)];
    leftImageViewButton.tag = section;
    [leftImageViewButton addTarget:self action:@selector(leftImageViewButtonTappedForMapLocation:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeader addSubview:leftImageViewButton];
    
    //section title
    xPos = leftImageView.frame.origin.x + leftImageView.frame.size.width + 10.0;
    width = frame.size.width - xPos - 40.0;
    height = 30.0;
    UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[[[self.branchLocationsArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"City"] fontSize:16.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
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
    return 50.0f;
}


-(BranchLocatorTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BranchLocatorTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[BranchLocatorTableViewCell alloc]initWithDelegate:self indexPath:indexPath response:[[self.branchLocationsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
//    HospitalDetailViewController *vctr = [[HospitalDetailViewController alloc]initWithResponse:(self.hospitalType == allHopitalsEnum)? [[self.hospitals valueForKey:@"allHospitals"] objectAtIndex:indexPath.row]:(self.hospitalType == searchHospital)?[[self.hospitals valueForKey:@"searchhospitals"] objectAtIndex:indexPath.row]:[[self.hospitals valueForKey:@"nearMeHospitals"] objectAtIndex:indexPath.row]];
//    
//    [self.navigationController pushViewController:vctr animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return  sectionFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UIButton *)createButtonWithFrame:(CGRect) frame
{
    return [[UIButton alloc]initWithFrame:frame];
}

- (void)leftImageViewButtonTappedForMapLocation:(UIButton *)sender {
    
    NSLog(@"Address: %@", [self.branchLocationsArray objectAtIndex:(long)sender.tag]);
    NSMutableDictionary *branchLocationDict = [[self.branchLocationsArray objectAtIndex:(long)sender.tag] objectAtIndex:0];
//    NSString *address = [NSString stringWithFormat:@"%@, %@, %@",[branchLocationDict valueForKey:@"City"], [branchLocationDict valueForKey:@"District"] , [branchLocationDict valueForKey:@"State"]];
    NSString *address = [NSString stringWithFormat:@"%@",[branchLocationDict valueForKey:@"Pincode"]];
    
    [[UIManager sharedUIManger]gotoMap:address hospitalName:[branchLocationDict valueForKey:@"OfficeName"]];
}


#pragma mark - Response

- (void)didReceiveBranchLocatorResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    if ([response isKindOfClass:[NSArray class]]) {
        
        [[CoreData shareData] setBranchLocationsDetailsWithResponse:response];
        self.responseArray = (NSArray *)response;
        [self sortBranches:self.responseArray];
        [self reloadTableView];

    }
    else {
        
        [(UILabel *)[self.view viewWithTag:kBranchStatusLabelTag] setHidden:NO];
    }
    
}

#pragma mark - Button delegate
- (IBAction)cancelButtonTapped:(id)sender
{
    
    [self.view endEditing:YES];
    [(UILabel *)[self.view viewWithTag:kBranchStatusLabelTag] setHidden:YES];

    self.branchLocationsArray = [[NSMutableArray alloc]init];
    [self sortBranches:self.responseArray];
    [self reloadTableView];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 12123) {
        
        if (buttonIndex == 0)
        {
            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",self.contactNumber];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
            
            NSLog(@"phone call to %@", phoneCallNum);
            
            
        }else
        {
            return;
        }
        
    }
}


#pragma mark  - Search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setToolBar:searchBar];
    [self enableDisableCancelWithsearchBar:searchBar Button:YES];

    
}

- (void)setToolBar:(UISearchBar *)searchbar
{
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped:)],
                           nil];
    [numberToolbar sizeToFit];
    searchbar.inputAccessoryView = numberToolbar;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self cancelButtonTapped:nil];

}

- (void)enableDisableCancelWithsearchBar:(UISearchBar *)searchBar Button:(BOOL)isCancel
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self enableDisableCancelWithsearchBar:searchBar Button:NO];

    [searchBar resignFirstResponder];
    
    [self filterContentForSearchText:searchBar.text];
}

- (void)filterContentForSearchText:(NSString*)searchText {
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"(SELF.State CONTAINS[cd] %@) OR (SELF.City CONTAINS[cd] %@)",
                                    searchText, searchText];
    NSArray *sortedArray = [self.responseArray filteredArrayUsingPredicate:resultPredicate];
    if (sortedArray.count > 0) {
        
        self.branchLocationsArray = [[NSMutableArray alloc]init];
        [self sortBranches:sortedArray];
        [self reloadTableView];
        
        NSLog(@"branches %@", sortedArray);

    }
    else {
        self.branchLocationsArray = [[NSMutableArray alloc]init];
        [(UILabel *)[self.view viewWithTag:kBranchStatusLabelTag] setHidden:NO];
        [self reloadTableView];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [self reloadTableView];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [self enableDisableCancelWithsearchBar:searchBar Button:NO];

    [self cancelButtonTapped:nil];

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

#pragma mark - call

- (void)callTappedWithNumber:(NSString *)phoneNumber {
    self.contactNumber = phoneNumber;
    alertView(@"Do you want to call?", phoneNumber, self, @"Yes", @"No",12123);

}

#pragma mark - Sort Branches

- (void)sortBranches:(NSArray *)sortArray {
   
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [sortArray count]; i++) {
        [cityArray addObject:[[sortArray objectAtIndex:i]valueForKey:@"City"]];
    }
    
    //Removing duplicate webrefNumber
    NSMutableArray *filterBranch = [[NSMutableArray alloc]init];
    
    for (id obj in cityArray)
    {
        if (![filterBranch containsObject:obj])
        {
            [filterBranch addObject: obj];
        }
    }
    
    [filterBranch sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (int i = 0; i < [filterBranch count]; i++) {
        NSMutableArray *filter = [[NSMutableArray alloc]init];
        for (int j = 0; j < [sortArray count]; j++) {
            if ([[filterBranch objectAtIndex:i] isEqualToString:[[self.responseArray objectAtIndex:j]valueForKey:@"City"]]) {
                [filter addObject:[sortArray objectAtIndex:j]];
            }
        }
        [self.branchLocationsArray addObject:filter];
    }
    
    for(int i = 0;i < self.branchLocationsArray.count;i++) {
        
        [self.expandCollapse addObject:[NSNumber numberWithBool:NO]];
    }

}

#pragma mark -

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
