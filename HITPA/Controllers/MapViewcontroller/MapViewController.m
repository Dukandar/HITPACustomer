//
//  MapViewController.m
//  HITPA
//
//  Created by Bathi Babu on 1/6/16.
//  Copyright © 2016 Bathi Babu. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Utility.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@end
MKMapView *map;
typedef void (^completionHandler)(NSArray *array, NSError *error);

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Map";
    NSLog(@"Address: %@", self.addreses);
    NSLog(@"Hospital Name: %@", self.hospitalName);
    [self mapView];
    // Do any additional setup after loading the view from its nib.
}

- (void)mapView
{
    CGRect frame = [self bounds];
    map = [[MKMapView alloc]initWithFrame:frame];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    map.delegate = self;
    [self.view addSubview:map];
    map.showsUserLocation = YES;
   
    /*
      // OLD CODE
     CLLocationCoordinate2D coordinates=  [self getLocationFromAddressString:self.addreses];
     MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
     annotation.coordinate = coordinates;
     annotation.title = self.hospitalName;
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, 200, 200);
     [map setRegion:[map regionThatFits:region] animated:YES];
     [map addAnnotation:annotation];
    */
    
     // NEW CODE
//     NSString *addessAndHospital = [NSString stringWithFormat:@"%@,%@", self.addreses, self.hospitalName];
     [self getLocationFromAddressString:self.addreses];
    
}


/*
  // OLD CODE
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*)addressStr {
   // [map clearsContextBeforeDrawing];
    double latitude = 0, longitude = 0;
    
    NSString *esc_addr =  [addressStr
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString
                     stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@",
                     esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL
                                                          URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] &&
            [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] &&
                [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
           
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}
*/

// NEW CODE
-(void) getLocationFromAddressString: (NSString*)addressStr {
 
    NSArray *addressArray = [addressStr componentsSeparatedByString:@","];
    NSString *cityName = [addressArray lastObject];
    NSString *cityAndHospital = [NSString stringWithFormat:@"%@",cityName];
    //NSString *cityAndHospital = [NSString stringWithFormat:@"%@",addressStr];
 
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
              NSString *hospitalAddress = [NSString stringWithFormat:@"%@ Address is not Correct.", self.hospitalName];
             alertView(@"Map Address",hospitalAddress , nil, @"Ok", nil, 0);
         }
         
         center.latitude = latitude;
         center.longitude = longitude;
         CLLocationCoordinate2D coordinates= center;
         MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
         annotation.coordinate = coordinates;
         annotation.title = self.hospitalName;
         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, 40000, 40000);
         [map setRegion:[map regionThatFits:region] animated:YES];
         [map addAnnotation:annotation];
     }];
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
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
