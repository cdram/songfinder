//
//  ViewController.h
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBConnect.h"
#import "ThirdViewController.h"
#import "SecondViewController.h"




@interface ViewController : UIViewController<CLLocationManagerDelegate, FBDialogDelegate, FBSessionDelegate>
{
    NSTimer * timer;
    CLLocationManager *manager;
    CLLocation * currentLocation;
    UIWindow *window;
    Facebook * fbGraph;
    NSArray * sortedKeys;
    NSDictionary * populator;
    ThirdViewController * thirdViewHandle;
    IBOutlet UITableView * table;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *reload;
    IBOutlet UIBarButtonItem *close;
    IBOutlet UIBarButtonItem *next;
    NSInteger sectionNumber;
    NSInteger rowNumber;
    NSMutableArray * keyHour;
    NSMutableArray * keyDay;
    NSMutableArray * keyWeek;
    NSString * latitudeString;
    NSString * longitudeString;
    NSString * selectedKey;

    
}

@property (nonatomic, retain) NSString * selectedKey;
@property (nonatomic, retain) NSString * latitudeString;
@property (nonatomic, retain) NSString * longitudeString;
@property (nonatomic, retain) NSMutableArray * keyHour;
@property (nonatomic, retain) NSMutableArray * keyDay;
@property (nonatomic, retain) NSMutableArray * keyWeek;
@property (nonatomic) NSInteger sectionNumber;
@property (nonatomic) NSInteger rowNumber;
@property (nonatomic, retain) NSArray * sortedKeys;
@property (nonatomic, retain) ThirdViewController * thirdViewHandle;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) CLLocation * currentLocation;
@property (nonatomic, retain) NSDictionary * populator;
@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) Facebook * fbGraph;
@property (nonatomic, retain) CLLocationManager *manager;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reload;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *close;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *next;


-(IBAction)reloadPage:(id)sender;
-(IBAction)closeApp:(id)sender;
-(IBAction)nextPage:(id)sender;
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
-(void)stopUpdatingLocations;

@end
