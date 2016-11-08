//
//  ViewController.m
//  KMWeatherApp
//
//  Created by Student P_02 on 19/10/16.
//  Copyright © 2016 Karishma Mahajan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startLocating];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocating
{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"lattitude = %f",currentLocation.coordinate.latitude);
    
    NSLog(@"longitude = %f",currentLocation.coordinate.longitude);
    
    kLatitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude ];
    KLongitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    
    if (currentLocation !=nil) {
        [locationManager stopUpdatingLocation];
    }
}

-(void)getCurrentWeatherDataWithLatitude:(double)latitude
                               longitude:(double)longitude
                                  APIKey:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric",latitude,longitude,key];
    NSLog(@"%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updteUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}

-(void)updteUI:(NSDictionary *)resultDictionary {
    NSLog(@"%@",resultDictionary);
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE :%@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);

    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    self.labelCity.text = city;
    self.labelCondition.text = condition;
    self.labelTemperature.text = temperature;

}

- (IBAction)GetCurrentAction:(id)sender {
    
    [locationManager startUpdatingLocation];
    [self getCurrentWeatherDataWithLatitude:kLatitude.intValue longitude:KLongitude.intValue APIKey:kWeatherAPIKey];
}

@end
