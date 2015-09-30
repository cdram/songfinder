//
//  SecondViewController.m
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

static NSString * kAppID = @"270284756355217";

@synthesize key;
@synthesize link;
@synthesize web;
@synthesize toolbar;
@synthesize fShare;
@synthesize close;
@synthesize fbGraph;
@synthesize lat;
@synthesize lng;

-(IBAction)facebookShare:(id)sender
{
    NSString * url = @"http://www.youtube.com/watch?v=";
    url = [url stringByAppendingFormat:key];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"270284756355217", @"app_id",url, @"link",@"http://fbrell.com/f8.jpg", @"picture",@"Spot It ! Share It !", @"name",@"Description", @"caption",@"The best way to share the trend, once you Spot it !", @"description",@"Trending now!",  @"message",nil];
    fbGraph = [[Facebook alloc] initWithAppId:kAppID andDelegate:self];
    [fbGraph dialog:@"feed" andParams:params andDelegate:self];

    
}

-(IBAction)closeApp:(id)sender
{
    NSLog(@"Quitting App");
    exit(0);
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"SecondView:%@",link);
    key = link;
    NSString * temp = [[NSString alloc] initWithFormat:@"http://m.youtube.com/watch?v="];
    temp = [temp stringByAppendingFormat:@"%@",link];
    NSLog(@"%@",temp);
    link = temp;
    //[temp release];
    NSLog(@"exact link : %@",link);
   // web = [[UIWebView alloc] init];
    NSLog(@"%@,%@",lat,lng);
    NSString * request = [[NSString alloc] initWithFormat:@"http://dpnkarthik.cse.ohio-state.edu/application/addvideo.php?lat="];
    request = [request stringByAppendingFormat:lat];
    request = [request stringByAppendingFormat:@"&lng="];
    request = [request stringByAppendingFormat:lng];
    request = [request stringByAppendingFormat:@"&vid="];
    request = [request stringByAppendingFormat:key];
    NSLog(@"%@",request);
    [web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:link]]];
    NSURLRequest * addRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:request]];
   // NSData * data = [NSURLConnection sendSynchronousRequest:addRequest returningResponse:nil error:nil];
    [NSURLConnection sendAsynchronousRequest:addRequest queue:nil completionHandler:nil];
    //NSString * dataStore = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //if([dataStore isEqualToString:@""])
   

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"Leaving The Player");

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
