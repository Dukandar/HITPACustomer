//
//  NearMeViewController.m
//  MedSync
//
//  Created by Sunilkumar Basappa on 29/09/15.
//  Copyright © 2015 iNube. All rights reserved.
//

#import "NearMeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoreData.h"
#import "MBProgressHUD.h"
#import "HITPAAPI.h"
#import "Utility.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface NearMeViewController ()<CLLocationManagerDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property(nonatomic,strong)     CLLocationManager   *locationManager;
@property(nonatomic,strong)     CLLocation          *currentLocation;
@property (nonatomic, readwrite) BOOL               isLocationUpdated;
@property (nonatomic, readwrite) NSInteger          isCurrentPage,isAnnotationIndex;
@property (nonatomic, strong)    MBProgressHUD      *progressHUD;
@property (nonatomic, readwrite) Hospital           *Hospital;
@property(nonatomic,strong) NSMutableArray          *Hospitals,*annoations;
@property (nonatomic, strong) MKMapView             *mapView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSIndexPath       *indexPath;


@end

@implementation NearMeViewController

@synthesize  delegate = _delegate;

- (instancetype)initWithDelegate:(id<nearMe>)delegate
{
    
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Near Me";
    [self rightBarItem];
    [self setSubView];
    [self locationUpdation];
    // Do any additional setup after loading the view.
}



- (void)rightBarItem
{
    
    CGFloat xPos = 20.0;
    CGFloat yPos = -5.0;
    CGFloat width = 38.0;
    CGFloat height = 38.0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [imageView setImage:[UIImage imageNamed:@"icon_dhslogo.png"]];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = left;
    
}

- (void)setSubView
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width = frame.size.width;
    CGFloat height = roundf(frame.size.height / 2) - 30.0;
    
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    yPos = self.mapView.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [self.view addSubview:self.tableView];
    
    
}

- (void)reloadTableView
{
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
    
    
}


#pragma mark - LocationUpdation
- (void)locationUpdation
{
   
    
    self.isLocationUpdated = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self locationServiceAuthorization];
    self.locationManager.distanceFilter=10;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationServiceAuthorization
{
    
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (!self.isLocationUpdated) {
        
        self.isLocationUpdated = YES;
        NSLog(@"%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
        
        self.isCurrentPage = 1;
        //Old Code
//        int pin = [self getLocationFromAddressString:self.locationManager.location.coordinate.latitude longitute:self.locationManager.location.coordinate.longitude];
//        [self getNearMeWithPincode:[NSString stringWithFormat:@"%d",pin]];
        //New Code
//        NSString *pin = [self getAddressFromLatitudeAndLongitude:self.locationManager.location];
//        NSLog(@"Pin Number1:%@", pin);
//        [self getNearMeWithPincode:pin];
       [self getAddressFromLatitudeAndLongitude:self.locationManager.location];
    }
    
    [self.locationManager stopUpdatingLocation];

    
}
/*
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
*/

//- (NSString *) getAddressFromLatitudeAndLongitude:(CLLocation *)bestLocation
- (void) getAddressFromLatitudeAndLongitude:(CLLocation *)bestLocation
{
    __block NSString *pin;
    
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         pin = placemark.postalCode;
         NSLog(@"reverseGeocodeLocation:%@", pin);
         [self getNearMeWithPincode:pin];
     }];
//    return pin;
}

#pragma mark - Handler
- (void)getNearMeWithPincode:(NSString *)pincode
{
    [self showHUDWithMessage:@""];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:2];
    [params setValue:pincode forKey:@"pincode"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)1] forKey:@"page"];
    
    [[HITPAAPI shareAPI] getSearchNearMeHospitalWithParams:params completionHandler:^(NSDictionary *response ,NSError *error){
        
        [self didReceiveNearMeHospitalsWithResponse:response error:error];
        
    }];
    
}

- (void)didReceiveNearMeHospitalsWithResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    
    self.Hospitals = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in response) {
        
        HospitalModel *home = [HospitalModel getHospitalStringByResponse:dictionary];
        [self.Hospitals addObject:home];
        
    }
    
    [self addAnotation];
    [self reloadTableView];
    
    
}







- (void)locationError:(NSError *)error {
    NSLog(@"%@", [error description]);
    
}

/*
- (void)addAnotation
{
    MKCoordinateRegion region = { {200.0, 0.0 }, { 200.0, 0.0 } };
    
    for (HospitalModel *hospital in self.Hospitals) {
        
        CLLocationCoordinate2D centre =[self geoCodeUsingAddress:[NSString stringWithFormat:@"%@",hospital.address]];
        
        double latitude = centre.latitude, longitude = centre.longitude;
        region.center.latitude = latitude;
        region.center.longitude = longitude;
        MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
        point.coordinate=centre;
        point.title=hospital.hospitalName;
        NSLog(@"Address:%@", hospital.address);
        region.span.longitudeDelta = 0.05f;
        region.span.latitudeDelta = 0.05f;
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotation:point];
    }
}
*/

- (void)addAnotation
{
    for (HospitalModel *hospital in self.Hospitals) {
        [self getLocationFromAddressString:hospital.address andHospitalName:hospital.hospitalName];
    }
}

-(void) getLocationFromAddressString: (NSString*)addressStr andHospitalName:(NSString*)hospitalName {
    
    NSArray *addressArray = [addressStr componentsSeparatedByString:@","];
    NSString *cityName = [addressArray lastObject];
    NSString *cityAndHospital = [NSString stringWithFormat:@"%@, %@", cityName, hospitalName];
    
    __block double latitude = 0, longitude = 0;
    __block CLLocationCoordinate2D center;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:cityAndHospital completionHandler:^(NSArray *placemarks2, NSError *error)
     {
         if ([placemarks2 count] > 0) {
             
             CLPlacemark *placemark = [placemarks2 lastObject];
             CLLocation *location = placemark.location;
             
             latitude = location .coordinate.latitude;
             longitude = location.coordinate.longitude;
         }
         if(error) {
             NSLog(@"Error");
             //NSString *hospitalAddress = [NSString stringWithFormat:@"%@ Address is not Correct.", hospitalName];
             //alertView(@"Map Address",hospitalAddress , nil, @"Ok", nil, 0);
         }
         
         center.latitude = latitude;
         center.longitude = longitude;
         CLLocationCoordinate2D coordinates= center;
         MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
         annotation.coordinate = coordinates;
         annotation.title = hospitalName;
         NSLog(@"cityAndHospital:%@", cityAndHospital);
         NSLog(@"Address:%@", addressStr);
         NSLog(@"Hospital:%@", hospitalName);
         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, 200, 200);
         [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
         [self.mapView addAnnotation:annotation];
     }];
}
//#pragma mark-Map View Delegate
//-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    
//    [annotation description];
//    
//    MKPinAnnotationView *pinView = nil;
//    if(annotation != self.mapView .userLocation)
//    {
//        static NSString *defaultPinID = @"com.DHS.pin";
//        
//        pinView = (MKPinAnnotationView *)[self.mapView  dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
//                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//        
//        pinView.pinColor = MKPinAnnotationColorPurple;
//        pinView.tag = self.isAnnotationIndex;
//        pinView.canShowCallout = YES;
//        pinView.animatesDrop = YES;
//        
//        id annotation = pinView.annotation;
//        if (self.isAnnotationIndex == 0)
//            [self performSelector:@selector(selectUserLocation:) withObject:annotation afterDelay:0.1f];
//        
//        if (!self.annoations)
//            self.annoations = [[NSMutableArray alloc]init];
//        
//        if (annotation != nil)
//            [self.annoations addObject:annotation];
//        
//        self.isAnnotationIndex++;
//        
//    }
//    else
//    {
//        [self.mapView.userLocation setTitle:@"I am here"];
//        pinView.annotation = annotation;
//    }
//    
//    
//    
//    return pinView;
//}


- (void)selectUserLocation:(id)annotation{
    
    [self.mapView selectAnnotation:annotation animated:YES];
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    self.indexPath = [NSIndexPath indexPathForRow:view.tag inSection:0];
    [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"location\" :" intoString:nil] && [scanner scanString:@"\"location\" :" intoString:nil]) {
            if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
                [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
                [scanner scanDouble:&longitude];
        }
        
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}



#pragma mark - tableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Hospitals count];
    
}

- (CGFloat )getHeightWithText:(NSMutableAttributedString *)text font:(UIFont *)font
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    CGFloat xPos = 10.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width - 20.0;
    CGFloat height = 20.0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [label setAttributedText:text];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    return label.frame.size.height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    HospitalModel *hospital = (HospitalModel *)[ self.Hospitals objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    
    NSMutableAttributedString *title;
    NSMutableAttributedString *value;
    
    title = [[NSMutableAttributedString alloc]initWithString:@"Hospital Name:\n"];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
    [attributedString appendAttributedString:title];
    
   value = [[NSMutableAttributedString alloc]initWithString:hospital.hospitalName];
    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
    [attributedString appendAttributedString:value];
    
    title = [[NSMutableAttributedString alloc]initWithString:@"\nAddress:\n"];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
    [attributedString appendAttributedString:title];
    
    value = [[NSMutableAttributedString alloc]initWithString:hospital.address];
    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
    [attributedString appendAttributedString:value];
    
//    title = [[NSMutableAttributedString alloc]initWithString:@"\nPincode : "];
//    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
//    [attributedString appendAttributedString:title];
//    
//    //value = [[NSMutableAttributedString alloc]initWithString:hospital.pinCode];
//    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
//    [attributedString appendAttributedString:value];

    
    CGFloat height = [self getHeightWithText:attributedString font:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    
    return height + 4.0;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Identifier";
    
    UITableViewCell *cell;
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
    }
    
    
    HospitalModel *hospital = (HospitalModel *)[ self.Hospitals objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    
    NSMutableAttributedString *title;
    NSMutableAttributedString *value;
    
    title = [[NSMutableAttributedString alloc]initWithString:@"Hospital Name:\n"];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
    [attributedString appendAttributedString:title];
    
    value = [[NSMutableAttributedString alloc]initWithString:hospital.hospitalName];
    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
    [attributedString appendAttributedString:value];
    
    title = [[NSMutableAttributedString alloc]initWithString:@"\nAddress:\n"];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
    [attributedString appendAttributedString:title];
    
    value = [[NSMutableAttributedString alloc]initWithString:hospital.address];
    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
    [attributedString appendAttributedString:value];
    
//    title = [[NSMutableAttributedString alloc]initWithString:@"\nPincode : "];
//    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] range:NSMakeRange(0, title.length)];
//    [attributedString appendAttributedString:title];
//    
//    //value = [[NSMutableAttributedString alloc]initWithString:hospital.pinCode];
//    [value addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, value.length)];
//    [attributedString appendAttributedString:value];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 3.0;
    CGFloat yPos = 2.0;
    CGFloat width = frame.size.width;
    CGFloat height = 30.0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [label setAttributedText:attributedString];
    [label setNumberOfLines:0];
    [label sizeToFit];
    [cell.contentView addSubview:label];
    
    if (self.indexPath.row == indexPath.row){
        
        [cell setBackgroundColor:[UIColor blueColor]];
        [label setTextColor:[UIColor whiteColor]];
        
    }else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
        [label setTextColor:[UIColor blackColor]];
        
    }
    

    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([self.delegate respondsToSelector:@selector(hospitaWithDetail:)])
    {
        [self.delegate hospitaWithDetail:(HospitalModel *)[self.Hospitals objectAtIndex:indexPath.row]];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
//    self.indexPath  = indexPath;
//    [self reloadTableView];
//    [self.mapView selectAnnotation:[self.annoations objectAtIndex:indexPath.row] animated:YES];
    
    
}

#pragma mark - HUD


- (void)showHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    [self.progressHUD show:YES];
}

- (void)showSuccessHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    self.progressHUD.delegate = self;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:2.0];
}

- (void)showErrorHUDWithMessage:(NSString *)message
{
    if (self.progressHUD != nil)
    {
        [self hideHUD];
        self.progressHUD = nil;
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    self.progressHUD.margin = 10.f;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    
    [self.progressHUD hide:YES afterDelay:2.0];
}

- (void)hideHUD
{
    [self.progressHUD hide:YES];
}


- (void)showNetworkActivityIndicator
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}


- (void)hideNetworkActivityIndicator
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
