//
//  CityViewController.m
//  SongFinder
//
//  Created by shriram on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CityViewController.h"
#import "JSON.h"

@implementation CityViewController

static NSString * kAppID = @"270284756355217";

@synthesize lat;
@synthesize lng;
@synthesize toolbar;
@synthesize fShare;
@synthesize close;
@synthesize table;
@synthesize player;
@synthesize populator;
@synthesize sortedKeys;
@synthesize utubeKeys;
@synthesize checkFlag;
@synthesize selectedKey;

-(IBAction)closeApp:(id)sender
{
    NSLog(@"close app ");
    exit(0);
}

-(IBAction)playerFunc:(id)sender
{
    NSLog(@"Play Videos");
}

-(IBAction)facebookShare:(id)sender
{
    
    NSString * linkFormation = @"http://www.youtube.com/watch?v=";
    
    if (!checkFlag) {
        NSLog(@"No Value Selected ! Call Alert !");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Feed Error" message:@"Please Select any Video to fShare" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        linkFormation = [linkFormation stringByAppendingFormat:selectedKey];
        NSLog(@"The going to share link: %@", linkFormation);
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"270284756355217", @"app_id",linkFormation, @"link",@"http://fbrell.com/f8.jpg", @"picture",@"Spot It ! Share It !", @"name",@"Description", @"caption",@"The best way to share the trend, once you Spot it !", @"description",@"Trending now!",  @"message",nil];
        fbGraph = [[Facebook alloc] initWithAppId:kAppID andDelegate:self];
        [fbGraph dialog:@"feed" andParams:params andDelegate:self];
        checkFlag = NO;
    }

    
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    checkFlag = NO;
    utubeKeys = [[NSMutableArray alloc] init];
    NSLog(@"%@,%@", lat, lng);
    NSLog(@"View of City");
    // Do any additional setup after loading the view from its nib.
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://dpnkarthik.cse.ohio-state.edu/application/getallcity.php"]];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString * gotData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * storage = [gotData JSONValue];
    NSArray * keyStorage = [[storage allKeys] sortedArrayUsingSelector:@selector(compare:)];
    /*for (int i=0; i < [keysStorage count]; i++) {
        NSLog(@"%@",[keysStorage objectAtIndex:i]);
    }*/
    NSMutableDictionary * pair = [[NSMutableDictionary alloc] init];
    int count = [keyStorage count] - 1;
    for (int i = 0; i < (count/3); i++) {
        NSString * titlehour = [[NSString alloc] initWithFormat:@"titlehour"];
        NSString * city = [[NSString alloc] initWithFormat:@"city"];
        NSString * hour = [[NSString alloc] initWithFormat:@"hour"];
        titlehour = [titlehour stringByAppendingFormat:@"%d",i+1];
        city = [city stringByAppendingFormat:@"%d",i+1];
        hour = [hour stringByAppendingFormat:@"%d",i+1];
        [pair setObject:[storage objectForKey:titlehour] forKey:[storage objectForKey:city]];
        [utubeKeys addObject:[storage objectForKey:hour]];
    }
        
    self.populator = pair;
    [pair release];
    self.sortedKeys = [self.populator allKeys];
    [self.table reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];        
    }
    //NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.populator objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
   // NSLog(@"added val:%@",cell.textLabel.text);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section number : %d",[indexPath section]);
    NSLog(@"%@",[self.populator objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedKey = [[NSString alloc] initWithString:[utubeKeys objectAtIndex:[indexPath section]]];
    checkFlag = YES;
   
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
        NSLog(@"Reached Correctly");
    }
    else
    {
        NSLog(@"Reload View");
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (checkFlag) {
        SecondViewController * secondView = [segue destinationViewController];
        secondView.link = [[NSString alloc] initWithFormat:@"%@",selectedKey];
        secondView.lat = [[NSString alloc] initWithFormat:@"%@",lat];
        secondView.lng = [[NSString alloc] initWithFormat:@"%@",lng];
        checkFlag = NO;
    }   
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Player Eror" message:@"No Donut for U, until u select one !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


@end
