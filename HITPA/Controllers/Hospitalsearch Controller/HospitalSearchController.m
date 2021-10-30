//
//  HospitalSearchController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/4/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "HospitalSearchController.h"
#import "Configuration.h"
#import "HITPAUserDefaults.h"
#import "HospitalModel.h"
#import "HITPAAPI.h"
#import "HospitalDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Utility.h"

NSUInteger  const kHospitalSearchTag    = 300000;
NSUInteger  const kHospitalAllTag       = 400000;
NSUInteger  const kHospitalNearMeTag    = 500000;
NSUInteger  const kHospitalTopRatedTag  = 600000;
NSUInteger  const kStausLabelTag        = 320000;
NSUInteger  const kLoadingTag           = 111222;

NSString    *   const kHospitalLoading                = @"";
NSString    *   const kHospitalSearchText             = @"searchValue";

@interface HospitalSearchController ()<UISearchBarDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic, strong)       HospitalModel       *   hospitalModel;
@property (nonatomic, readwrite)    HospitalType            hospitalType;
@property (nonatomic, readwrite)    NSInteger               isNearMePageCount;
@property (nonatomic, readwrite)    NSInteger               isAllPageCount;
@property (nonatomic, strong)       NSMutableDictionary *   hospitals;
@property (nonatomic, strong)       NSString            *   pincode;
@property (nonatomic, strong)       CLLocationManager   *   locationManager;
@property (nonatomic, strong)       NSString            *   searhString;

@end

@implementation HospitalSearchController

#pragma mark - instancetype
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.isNearMePageCount = 1;
    self.isAllPageCount = 1;
    self.hospitals = [[NSMutableDictionary alloc]init];
    
    self.navigationItem.title = NSLocalizedString(@"Hospital", @"");
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.hospitalType = allHopitalsEnum;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setValue:@"All" forKey:@"pincode"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.isAllPageCount] forKey:@"page"];
    
    [self allHospitalsWithParams:params];
    [self searchView];
    [self headerView];
    // Do any additional setup after loading the view.
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
    searchName.tag = kHospitalSearchTag;
    searchName.searchBarStyle = UISearchBarStyleProminent;
//    UITextField *txfSearchField = [searchName valueForKey:@"_searchField"];
//    txfSearchField.backgroundColor= [UIColor colorWithRed:(207/255.0) green:(207/255.0) blue:(207/255.0) alpha:1.0f];
    searchName.barTintColor = [UIColor clearColor];
    searchName.backgroundImage = [UIImage new];
//    searchName.placeholder = NSLocalizedString(@"Hospital Search", @"");
    searchName.placeholder = NSLocalizedString(@"Hospital Name, City, State, Pin Code", @"");
    [search addSubview:searchName];
    [self.view addSubview:search];
    
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - search.frame.size.height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kStausLabelTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No Hospitals Found";
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
    bottomLoadingView.tag = kLoadingTag;
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

- (void)headerView
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    xPos = 0.0;
    yPos = 53.0;
    width = frame.size.width;
    height = 50.0;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = headerView.frame.size.width/2;
    height = headerView.frame.size.height - 5;
    UIView *allView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    allView.tag = allHopitalsEnum;
    [headerView addSubview:allView];
    
    xPos = allView.frame.size.width;
    UIView *nearMeView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    nearMeView.tag = nearMeHospitalsEnum;
    [headerView addSubview:nearMeView];
    
    xPos = 0.0;
    width = allView.frame.size.width;
    height = allView.frame.size.height;
    UILabel *allLabel = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"ALL" fontSize:16.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
    allLabel.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
    [allView addSubview:allLabel];
    
    UILabel *nearMeLabel = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"NEAR ME" fontSize:16.0 fontColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
    nearMeLabel.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
    [nearMeView addSubview:nearMeLabel];
    
    
    CGSize size = [allLabel.text sizeWithAttributes:
                   @{NSFontAttributeName: [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0]}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    yPos = allLabel.frame.size.height - 3.0;
    width = adjustedSize.width + 20.0;
    height = 2.0;
    xPos = (allView.frame.size.width - width)/2;
    UIView *allUnderLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:(148.0/255.0) green:(71.0/255.0) blue:(204.0/255.0) alpha:1.0f]];
    allUnderLine.tag = kHospitalAllTag;
    [allView addSubview:allUnderLine];
    
    size = [nearMeLabel.text sizeWithAttributes:
            @{NSFontAttributeName: [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0]}];
    adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    width = adjustedSize.width + 5.0;
    xPos = (nearMeView.frame.size.width - width)/2;
    UIView *nearMeUnderLine = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:(148.0/255.0) green:(71.0/255.0) blue:(204.0/255.0) alpha:1.0f]];
    nearMeUnderLine.tag = kHospitalNearMeTag;
    nearMeUnderLine.hidden = YES;
    [nearMeView addSubview:nearMeUnderLine];
    
    UITapGestureRecognizer *allHospitalsGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allHospitalsGuestureTapped:)];
    [allView addGestureRecognizer:allHospitalsGuesture];
    
    UITapGestureRecognizer *nearMeGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nearMeGuestureTapped:)];
    [nearMeView addGestureRecognizer:nearMeGuesture];
    
    
}

-(void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + 112.0, frame.size.width, frame.size.height - 172.0);
    [self.view layoutIfNeeded];
    
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

#pragma mark - Location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    int pin = [self getLocationFromAddressString:currentLocation.coordinate.latitude longitute:currentLocation.coordinate.longitude];
    self.pincode = [NSString stringWithFormat:@"%d",pin];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    currentLocation = [locations objectAtIndex:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             self.pincode = placemark.postalCode;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             //CountryArea = NULL;
         }
         /*---- For more results
         placemark.region);
         placemark.country);
         placemark.locality);
         placemark.name);
         placemark.ocean);
         placemark.postalCode);
         placemark.subLocality);
         placemark.location);
          ------*/
     }];
}
- (int) getLocationFromAddressString: (double) addressStr longitute:(double)longitute
{
    int pin;
    NSString *req = [NSString
                     stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",
                     addressStr,longitute];
    NSURL *url = [NSURL URLWithString:req];
    NSString *field;
    NSString * result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        NSMutableCharacterSet *whitespaceAndPunctuationSet = [NSMutableCharacterSet punctuationCharacterSet];
        [whitespaceAndPunctuationSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        scanner.charactersToBeSkipped = whitespaceAndPunctuationSet;
        NSCharacterSet *newLine = [NSCharacterSet newlineCharacterSet]; // 2
        NSString *name;
        NSString *currentLine = nil;
        if ([scanner scanUpToString:@"formatted_address" intoString:&currentLine])
        {
            
            field = [currentLine stringByTrimmingCharactersInSet: newLine];
            NSScanner *scan = [NSScanner scannerWithString:field];
            scan.charactersToBeSkipped = whitespaceAndPunctuationSet;
            while ([scan scanUpToCharactersFromSet:whitespaceAndPunctuationSet intoString:&name])
            {
                [scan scanInt:&pin];
                
            }
        }
    }
    return pin;
}

#pragma mark  - Handler
- (void)allHospitalsWithParams:(NSDictionary *)params
{
    [self showHUDWithMessage:@""];
    
    [[HITPAAPI shareAPI] getSearchAllHopitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
        
        [self didReceiveAllHospitalsWithResponse:response error:error];
        
    }];
}

- (void)didReceiveAllHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:YES];

    [self hideHUD];
    
    NSMutableArray *arrayAll = [[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [arrayAll addObject:home];
        
    }
    
    if (arrayAll.count == 0) {
        
        [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:NO];

    }
    
    [self.hospitals setValue:arrayAll forKey:@"allHospitals"];
    
    [self reloadTableView];
    
}

- (void)nearMeHospitalsWithParams:(NSDictionary *)params
{
    [self showHUDWithMessage:@""];
    
    [[HITPAAPI shareAPI] getSearchNearMeHospitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
        
        [self didReceiveNearMeHospitalsWithResponse:response error:error];
        
    }];
}

- (void)didReceiveNearMeHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:YES];
    [self hideHUD];
    
    NSMutableArray *arrayNearMe = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [arrayNearMe addObject:home];
        
    }
    
    if (arrayNearMe.count == 0) {
        
        
        [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:NO];
        
    }
    
    [self.hospitals setValue:arrayNearMe forKey:@"nearMeHospitals"];

    [self reloadTableView];
    
  
}

- (void)searchHospitalsWithSearchText:(NSString *)searchText
{
    [self showHUDWithMessage:@""];
    
    NSArray *searchArray = [searchText componentsSeparatedByString: @","];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (searchArray.count == 1) {
        [params setValue:searchArray[0] forKey:@"hospitalname"];
    } else if (searchArray.count == 2) {
        [params setValue:searchArray[0] forKey:@"hospitalname"];
        [params setValue:searchArray[1] forKey:@"city"];
        [params setValue:@"" forKey:@"pinCode"];
    } else if (searchArray.count == 3) {
        [params setValue:searchArray[0] forKey:@"hospitalname"];
        [params setValue:searchArray[1] forKey:@"city"];
        [params setValue:searchArray[2] forKey:@"pinCode"];
        [params setValue:@"1" forKey:@"page"];
    } else if (searchArray.count != 0) {
        [params setValue:searchArray[0] forKey:@"hospitalname"];
        [params setValue:searchArray[1] forKey:@"city"];
        [params setValue:searchArray[2] forKey:@"pinCode"];
        [params setValue:@"1" forKey:@"page"];
    }
    
    if (searchArray.count == 1) {
        [[HITPAAPI shareAPI] getSearchHospitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
            
            [self didReceiveSearchHospitalsWithResponse:response error:error];
            
        }];
    } else {
        [[HITPAAPI shareAPI] getSearchHospitalWithMultipleParams:params completionHandler:^(NSDictionary *response ,NSError *error){
            
            [self didReceiveSearchHospitalsWithResponse:response error:error];
            
        }];
    }
}

- (void)didReceiveSearchHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:YES];
    [self hideHUD];
    
    NSMutableArray *arraySearch = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [arraySearch addObject:home];
        
    }
    
    if (arraySearch.count == 0) {
        [(UILabel *)[self.view viewWithTag:kStausLabelTag] setHidden:NO];
    }
    /*
    //Need to show Alert Message
    if (response == nil) {
        alertView(@"Hospital Address", @"Hospital Address is not Found", nil, @"Ok", nil, 0);
    }
    */
    [self.hospitals setValue:arraySearch forKey:@"searchhospitals"];
    
    [self reloadTableView];
    
}

- (void)didReceiveNextAllHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    
    [(UIView *)[self.view viewWithTag:kLoadingTag] setHidden:YES];

    
    NSMutableArray *arrayAll = [NSMutableArray arrayWithArray:[self.hospitals valueForKey:@"allHospitals"]];
    
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [arrayAll addObject:home];
        
    }
    
    [self.hospitals setValue:arrayAll forKey:@"allHospitals"];
    
    if (response != nil) {
        
        [self reloadTableView];

    }
//    [self reloadTableView];
    
}

- (void)didReceiveNextNearMeHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    [(UIView *)[self.view viewWithTag:kLoadingTag] setHidden:YES];

    
    NSMutableArray *nearMe = [self.hospitals valueForKey:@"nearMeHospitals"];
    
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [nearMe addObject:home];
        
    }
    
    [self.hospitals setValue:nearMe forKey:@"nearMeHospitals"];
    
    if (response != nil)
    {
        [self reloadTableView];

    }
//    [self reloadTableView];
    
}

#pragma mark - Guesture
- (void)allHospitalsGuestureTapped:(UITapGestureRecognizer *)geustre
{
    [(UISearchBar *)[self.view viewWithTag:kHospitalSearchTag] setText:[NSString stringWithFormat:@""]];

    self.hospitalType = allHopitalsEnum;
    [(UIView *)[self.view viewWithTag:kHospitalAllTag] setHidden:NO];
    [(UIView *)[self.view viewWithTag:kHospitalNearMeTag] setHidden:YES];
    [(UIView *)[self.view viewWithTag:kHospitalTopRatedTag] setHidden:YES];
    
    [self reloadTableView];
  
}

- (void)nearMeGuestureTapped:(UITapGestureRecognizer *)geustre
{
    [(UISearchBar *)[self.view viewWithTag:kHospitalSearchTag] setText:[NSString stringWithFormat:@""]];

    
    self.hospitalType = nearMeHospitalsEnum;
    [(UIView *)[self.view viewWithTag:kHospitalAllTag] setHidden:YES];
    [(UIView *)[self.view viewWithTag:kHospitalNearMeTag] setHidden:NO];
    [(UIView *)[self.view viewWithTag:kHospitalTopRatedTag] setHidden:YES];
    
    if ([[self.hospitals valueForKey:@"nearMeHospitals"] count] <= 0 )
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
        [params setValue:self.pincode forKey:@"pincode"];
        [params setValue:[NSString stringWithFormat:@"%ld",(long)self.isNearMePageCount] forKey:@"page"];
        [self nearMeHospitalsWithParams:params];
        
    }else
    {
        [self reloadTableView];
        
    }
    
}

#pragma mark - Button delegate
- (IBAction)cancelButtonTapped:(id)sender
{
    
    [self.view endEditing:YES];
    
}

#pragma mark  - Search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setToolBar:searchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.hospitalType = searchHospital;
    self.searhString = searchBar.text;
//    [[HITPAUserDefaults shareUserDefaluts] setValue:searchBar.text forKey:kHospitalSearchText];
    [searchBar resignFirstResponder];
    
    [self searchHospitalsWithSearchText:self.searhString];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    self.hospitalType = allHopitalsEnum;
    [(UIView *)[self.view viewWithTag:kHospitalAllTag] setHidden:NO];
    [(UIView *)[self.view viewWithTag:kHospitalNearMeTag] setHidden:YES];
    [(UIView *)[self.view viewWithTag:kHospitalTopRatedTag] setHidden:YES];
    
    [self reloadTableView];
    
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

#pragma mark - Table Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 137.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.hospitalType == allHopitalsEnum) {
        
        return [[self.hospitals valueForKey:@"allHospitals"]count];
        
    }else if (self.hospitalType == searchHospital) {
        
        return [[self.hospitals valueForKey:@"searchhospitals"]count];
        
    }else{
        
        return [[self.hospitals valueForKey:@"nearMeHospitals"]count];
        
    }
    
}

-(HospitalSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HospitalSearchTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[HospitalSearchTableViewCell alloc]initWithDelegate:self indexPath:indexPath response:(self.hospitalType == allHopitalsEnum)? [self.hospitals valueForKey:@"allHospitals"]:(self.hospitalType == searchHospital)?[self.hospitals valueForKey:@"searchhospitals"]:[self.hospitals valueForKey:@"nearMeHospitals"]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    HospitalDetailViewController *vctr = [[HospitalDetailViewController alloc]initWithResponse:(self.hospitalType == allHopitalsEnum)? [[self.hospitals valueForKey:@"allHospitals"] objectAtIndex:indexPath.row]:(self.hospitalType == searchHospital)?[[self.hospitals valueForKey:@"searchhospitals"] objectAtIndex:indexPath.row]:[[self.hospitals valueForKey:@"nearMeHospitals"] objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:vctr animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.hospitalType == allHopitalsEnum)
    {
        if (indexPath.row == [[self.hospitals valueForKey:@"allHospitals"]count] - 1) {
            
            [(UIView *)[self.view viewWithTag:kLoadingTag] setHidden:NO];

            
            self.isAllPageCount++;
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
            [params setValue:@"All" forKey:@"pincode"];
            [params setValue:[NSString stringWithFormat:@"%ld",(long)self.isAllPageCount] forKey:@"page"];
            [[HITPAAPI shareAPI] getSearchAllHopitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
                
                [self didReceiveNextAllHospitalsWithResponse:response error:error];
                
            }];

        }
        
    }
    else if (self.hospitalType == nearMeHospitalsEnum)
    {
        if (indexPath.row == [[self.hospitals valueForKey:@"nearMeHospitals"]count] - 1) {
            
            
            [(UIView *)[self.view viewWithTag:kLoadingTag] setHidden:NO];

            self.isNearMePageCount ++;
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
            [params setValue:self.pincode forKey:@"pincode"];
            [params setValue:[NSString stringWithFormat:@"%ld",(long)self.isNearMePageCount] forKey:@"page"];
            
            
            [[HITPAAPI shareAPI] getSearchNearMeHospitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
                
                [self didReceiveNextNearMeHospitalsWithResponse:response error:error];
                
            }];
            
        }
    }
    
}

#pragma mark - SearchBar for Removing Double Space
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //Check for double space
    return !(range.location > 0 &&
             [text length] > 0 &&
             [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[text characterAtIndex:0]] &&
             [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[[searchBar text] characterAtIndex:range.location - 1]]);
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
