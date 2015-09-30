//
//  ViewController.m
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"

static NSString * kAppID = @"270284756355217";
static double staticLongitude = 0.0;
static double staticLatitude = 0.0;

@implementation ViewController

@synthesize latitudeString;
@synthesize longitudeString;
@synthesize thirdViewHandle;
@synthesize sortedKeys;
@synthesize currentLocation;
@synthesize populator;
@synthesize table;
@synthesize manager;
@synthesize close;
@synthesize next;
@synthesize reload;
@synthesize toolbar;
@synthesize window;
@synthesize fbGraph;
@synthesize timer;
@synthesize sectionNumber;
@synthesize rowNumber;
@synthesize keyDay;
@synthesize keyHour;
@synthesize keyWeek;
@synthesize selectedKey;

int test = 0;
double latitude = 0.0;
double longitude = 0.0;
typedef double CFTimeInterval;
CFTimeInterval startTime = 0.0;
int reloadFlag = 0;
NSArray * lastHour;
NSArray * lastWeek;
NSArray * lastDay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(IBAction)nextPage:(id)sender
{
    NSLog(@"Next Page");
    reloadFlag = 1;
    //[self stopUpdatingLocations];
  //  [self viewDidUnload];   
}

-(IBAction)reloadPage:(id)sender
{
    if ([selectedKey isEqualToString:@"notinitialized"]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Feed Error" message:@"Please select the video you want to share !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        NSString * link = [[NSString alloc] initWithFormat:@"http://www.youtube.com/watch?v="];
        link = [link stringByAppendingFormat:selectedKey];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"270284756355217", @"app_id",link, @"link",@"http://fbrell.com/f8.jpg", @"picture",@"Spot It ! Share It !", @"name",@"Description", @"caption",@"The best way to share the trend, once you Spot it !", @"description",@"Trending now!",  @"message",nil];
    fbGraph = [[Facebook alloc] initWithAppId:kAppID andDelegate:self];
    [fbGraph dialog:@"feed" andParams:params andDelegate:self];
    selectedKey = @"notinitialized";
    }
}

-(IBAction)closeApp:(id)sender
{
    NSLog(@"Inside Close");
    reloadFlag = 0;

}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    NSLog(@"view did load");
    reloadFlag = 0;
    [super viewDidLoad];
    selectedKey = [[NSString alloc] initWithFormat:@"notinitialized"];
    // toolbar buttons init
    
    toolbar = [UIToolbar new];
    reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(reloadPage:)];
    next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(nextPage:)];
    close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(closeApp:)];
    
    // Managing the Location Stuff
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.distanceFilter = kCLDistanceFilterNone;
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;    
    
    
    startTime = CFAbsoluteTimeGetCurrent();
    
    CLLocation * current = [self.manager location];
    CLLocationCoordinate2D coords = [current coordinate];
    if(coords.latitude != staticLatitude || coords.longitude != staticLongitude)
    {
        keyHour = [[NSMutableArray alloc] init];
        keyDay = [[NSMutableArray alloc] init];
        keyWeek = [[NSMutableArray alloc] init];
    [self.manager startUpdatingLocation];
    NSLog(@"cllocation : %g,%g", coords.latitude, coords.longitude);
        staticLatitude = coords.latitude;
        staticLongitude = coords.longitude;
    }
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error in handling location");
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Please check Wifi / 3G" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

// Battery Gate due to location handler
-(void)stopUpdatingLocations
{
    NSLog(@"Stoppd updating location");
    test = 1;
    [self.manager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [self stopUpdatingLocations];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Location Stuff
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
       self.currentLocation = newLocation;
       NSLog(@"inside updater: %g, %g",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
       NSString * latitude = [[NSString alloc] initWithFormat:@"%g",self.currentLocation.coordinate.latitude];
        NSString * longitude = [[NSString alloc] initWithFormat:@"%g",self.currentLocation.coordinate.longitude];
    latitudeString = latitude;
    longitudeString = longitude;
    [self stopUpdatingLocations];
        NSString * request = @"http://dpnkarthik.cse.ohio-state.edu/application/getsuggestion.php?lat=";
        request = [request stringByAppendingFormat:latitude];
        NSString * formationLng = @"&lng=";
        formationLng = [formationLng stringByAppendingFormat:longitude];
        request = [request stringByAppendingFormat:formationLng];
        
        NSLog(@"Request URL: %@", request);
        

        NSURLRequest * sendRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:request]];
        NSData * data  = [NSURLConnection sendSynchronousRequest:sendRequest returningResponse:nil error:nil];
        
        NSString * gotData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSLog(@"%@", gotData);
        
        NSDictionary * storage = [gotData JSONValue];
        NSArray * storedKeys =[[storage allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //for (int i=0; i < [storedKeys count]; i++) {
      //  NSLog(@"%@",[storedKeys objectAtIndex:i] );
    //}
   // NSArray * necessaryKeys = [[NSArray alloc] initWithObjects:@"hour1",@"hour2","@day1",@"day2",@"week1",nil];
    //NSArray * necessaryTitles = [[NSArray alloc] initWithObjects:@"titlehour1",@"titlehour2",@"titleday1",@"titleday2",@"titleweek1", nil];
    NSMutableArray * lastHourm = [[NSMutableArray alloc] init];
    NSMutableArray * lastDaym = [[NSMutableArray alloc] init];
    NSMutableArray * lastWeekm = [[NSMutableArray alloc] init];
    
   if([[storage objectForKey:@"status"] isEqualToString:@"ok"])
    {
        for (int i = 0; i < [storedKeys count]; i++) {
             NSString * title = @"title";
            if ([[storedKeys objectAtIndex:i] isEqualToString:@"hour1"] || [[storedKeys objectAtIndex:i] isEqualToString:@"hour2"]) {
                title = [title stringByAppendingFormat:[storedKeys objectAtIndex:i]];
                [lastHourm addObject:[storage objectForKey:title]];
                [keyHour addObject:[storage objectForKey:[storedKeys objectAtIndex:i]]];
                NSLog(@"keyhour : %@", [storage objectForKey:[storedKeys objectAtIndex:i]]);
            }
            else if([[storedKeys objectAtIndex:i] isEqualToString:@"day1"] || [[storedKeys objectAtIndex:i] isEqualToString:@"day2"])
            {
                title = [title stringByAppendingFormat:[storedKeys objectAtIndex:i]];
                [lastDaym addObject:[storage objectForKey:title]];
                [keyDay addObject:[storage objectForKey:[storedKeys objectAtIndex:i]]];
                NSLog(@"keyday : %@", [storage objectForKey:[storedKeys objectAtIndex:i]]);


            }
            else if([[storedKeys objectAtIndex:i] isEqualToString:@"week1"])
            {
                title = [title stringByAppendingFormat:[storedKeys objectAtIndex:i]];
                [lastWeekm addObject:[storage objectForKey:title]];
                [keyWeek addObject:[storage objectForKey:[storedKeys objectAtIndex:i]]];
                NSLog(@"keyweek : %@", [storage objectForKey:[storedKeys objectAtIndex:i]]);

            }
        }
    }
    else
    {
        // Call Alert
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Actual Location Error" message:@"The Actual Location Data might be undr some problems ! Please Try Again !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
        
        lastHour = [[NSArray alloc]initWithArray:lastHourm];
        lastDay = [[NSArray alloc]initWithArray:lastDaym];
        lastWeek = [[NSArray alloc]initWithArray:lastWeekm];
        NSDictionary *temp =[[NSDictionary alloc]initWithObjectsAndKeys:lastHour,@"Popular Videos of the Hour",lastDay,@"Popular Videos of the Day",lastWeek,@"Popular Videos of the Week",nil];
       
        self.populator = temp;
        [temp release];
        //NSLog(@"table %@",self.populator);
        //NSLog(@"table with Keys %@",[self.populator allKeys]);
        self.sortedKeys =[[self.populator allKeys] sortedArrayUsingSelector:@selector(compare:)];
        //NSLog(@"sorted %@",self.sortedKeys);
        [self.table reloadData];
    
   
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"table sections");
    return [self.sortedKeys count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   // NSLog(@"%@",[keys objectAtIndex:section]);
    return [self.sortedKeys objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * listData = [populator objectForKey:[self.sortedKeys objectAtIndex:section]];
     for(int i=0;i<[listData count];i++)
         NSLog(@"%@",[listData objectAtIndex:i]);

    return [listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * listData = [self.populator objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
    
    static NSString * identifier = @"MyIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];        
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
  //  NSLog(@"added val:%@",cell.textLabel.text);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData =[self.populator objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
  //  NSLog(@"section number : %d",[indexPath section]);
    sectionNumber = [indexPath section];
	rowNumber = [indexPath row];
	NSString *rowData = [listData objectAtIndex:rowNumber];
    NSLog(@"%@",rowData);
    NSLog(@"%d",sectionNumber);
    NSLog(@"%d",rowNumber);
   
    if(sectionNumber == 0)
    {
        selectedKey = [keyDay objectAtIndex:rowNumber];
    }
    else if(sectionNumber == 1)
    {
        selectedKey = [keyHour objectAtIndex:rowNumber];
    }
    else if(sectionNumber == 2)
    {
       selectedKey = [keyWeek objectAtIndex:rowNumber];
  
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
     //   NSLog(@"Reached Correctly");
    }
    else
    {
       // NSLog(@"Reload View");
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ThirdViewControllerSegue"])
    {
        
        ThirdViewController * third = (ThirdViewController *)[segue destinationViewController];
        NSLog(@"%@,%@",latitudeString,longitudeString);
        third.lat = [[NSString alloc] initWithFormat:@"%@",latitudeString];
        third.lng = [[NSString alloc] initWithFormat:@"%@",longitudeString];
        

    }
    else if([[segue identifier] isEqualToString:@"SecondViewControllerSegue"])
    {
        NSString * youtubeKey;
        if(sectionNumber == 0)
        {
            youtubeKey = [[NSString alloc] initWithFormat:[keyDay objectAtIndex:rowNumber]];
        }
        else if(sectionNumber == 1)
        {
            youtubeKey = [[NSString alloc] initWithFormat:[keyHour objectAtIndex:rowNumber]];
        }
        else if(sectionNumber == 2)
        {
            youtubeKey = [[NSString alloc] initWithFormat:[keyWeek objectAtIndex:rowNumber]];   
        }
        NSLog(@"youtube key: %@",youtubeKey);
        SecondViewController * second = (SecondViewController *)[segue destinationViewController];
        second.lat = [[NSString alloc] initWithFormat:@"%@",latitudeString];
        second.lng = [[NSString alloc] initWithFormat:@"%@",longitudeString];
        second.link = youtubeKey;
        
    }
}

@end
