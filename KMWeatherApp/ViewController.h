//
//  ViewController.h
//  KMWeatherApp
//
//  Created by Student P_02 on 19/10/16.
//  Copyright © 2016 Karishma Mahajan. All rights reserved.
//


#define kWeatherAPIKey @"7ca564a51e2877f8bb930e5db70cc1f2"
#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

{
    NSString *kLatitude;
    NSString *KLongitude;
    CLLocationManager *locationManager;
    
}
@property (strong, nonatomic) IBOutlet UILabel *labelCity;


@property (strong, nonatomic) IBOutlet UILabel *labelTemperature;

@property (strong, nonatomic) IBOutlet UILabel *labelCondition;

- (IBAction)GetCurrentAction:(id)sender;




@end

