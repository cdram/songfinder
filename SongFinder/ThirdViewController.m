//
//  ThirdViewController.m
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "JSON.h"

@implementation ThirdViewController

static NSString * kAppID = @"270284756355217";

@synthesize keyFlag;
@synthesize search;
@synthesize populator;
@synthesize sortedKeys;
@synthesize table;
@synthesize toolbar;
@synthesize close;
@synthesize second;
@synthesize fShare;
@synthesize play;
@synthesize fbGraph;
@synthesize youtubeKey;
@synthesize utube;
@synthesize linkFormation;
@synthesize selectedKey;
@synthesize lat;
@synthesize lng;


-(IBAction)citySpot:(id)sender
{
    NSLog(@"city trends");
    youtubeKey = 0;
    
}

-(IBAction)player:(id)sender
{
    NSLog(@"This button takes you to player on clicking");
}

-(IBAction)facebookShare:(id)sender
{
    linkFormation = @"http://www.youtube.com/watch?v=";
    
    if (!youtubeKey) {
        NSLog(@"No Value Selected ! Call Alert !");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Feed Error" message:@"Please Select any Video to fShare" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        linkFormation = [linkFormation stringByAppendingFormat:[utube objectAtIndex:youtubeKey]];
        NSLog(@"The going to share link: %@", linkFormation);
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"270284756355217", @"app_id",linkFormation, @"link",@"http://fbrell.com/f8.jpg", @"picture",@"Spot It ! Share It !", @"name",@"Description", @"caption",@"The best way to share the trend, once you Spot it !", @"description",@"Trending now!",  @"message",nil];
    fbGraph = [[Facebook alloc] initWithAppId:kAppID andDelegate:self];
    [fbGraph dialog:@"feed" andParams:params andDelegate:self];
    youtubeKey = 1000;
    }

}

-(void)viewDidLoad
{
    NSLog(@"%@,%@",lat,lng);
    selectedKey = @"notinitialized";
    keyFlag = NO;
    youtubeKey = 0;
    toolbar = [[UIToolbar alloc] init];
    close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(closeApp:)];
    fShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(facebookShare:)];
    play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(player:)];
    [super viewDidLoad];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    self.table.allowsSelection = NO;
    self.table.scrollEnabled = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.table.allowsSelection = YES;
    self.table.scrollEnabled = YES;
    [search resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"%@",searchBar.text);
    NSString * searchText = searchBar.text;
    NSMutableString * searchString = [NSMutableString stringWithString:searchText];
    searchText = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"%@",searchText);
   NSString * request = @"http://dpnkarthik.cse.ohio-state.edu/application/search.php?q=";
    request = [request stringByAppendingFormat:searchText];
    NSLog(@"%@",request);
    
    NSURLRequest * url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:request]];
    NSData * data = [NSURLConnection sendSynchronousRequest:url_request returningResponse:nil error:nil];
    
    NSString * dataGot = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableArray * storage = [[NSMutableArray alloc] init];
    utube = [[NSMutableArray alloc] init];

   // NSLog(@"Data Got : %@", dataGot);
    
    NSDictionary * jsonStuff = [dataGot JSONValue];
    int count = [jsonStuff count];
    int flag = 1;
    while (flag <= (count/2)) {
        NSString * title = @"title";
        NSString * value = @"value";
        title = [title stringByAppendingFormat:@"%d",flag];
        value = [value stringByAppendingFormat:@"%d",flag];
        NSLog(@"%@,%@", title,value);
        [storage addObject:[jsonStuff objectForKey:title]];
        [utube addObject:[jsonStuff objectForKey:value]];
        flag = flag + 1;
    }
    
    /*for (int i=0; i < [utube count]; i++) {
        NSLog(@"%@",[utube objectAtIndex:i]);
    }*/
    
    NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:storage,@"Results", nil];
    self.populator = temp;
    [temp release];
    
    self.sortedKeys = [self.populator allKeys];
    [self.table reloadData];
    self.table.allowsSelection = YES;
    self.table.scrollEnabled = YES;
    [search resignFirstResponder];
    

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
    NSLog(@"added val:%@",cell.textLabel.text);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listData =[self.populator objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]];
    NSLog(@"section number : %d",[indexPath section]);
	NSUInteger row = [indexPath row];
	NSString *rowValue = [listData objectAtIndex:row];
    NSLog(@"%@",rowValue);
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    youtubeKey = row;
    keyFlag = YES;
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
    NSLog(@"inside segue");
    NSLog(@"%d",keyFlag);
    if (![[segue identifier] isEqualToString:@"CityPlayerSegue"]) {
        if(!keyFlag)
        {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"The Player Error" message:@"No Video Selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (keyFlag && [[segue identifier] isEqualToString:@"SearchPlayerSegue"]) {
        NSLog(@"calling the search player");
            selectedKey = [utube objectAtIndex:youtubeKey];
            NSLog(@"%@",selectedKey);
            SecondViewController * secondView = [segue destinationViewController];
            secondView.link = [[NSString alloc] initWithFormat:@"%@",selectedKey];
            secondView.lat = [[NSString alloc] initWithFormat:@"%@",lat];
            secondView.lng = [[NSString alloc] initWithFormat:@"%@",lng];
            keyFlag = NO;

            
        }
    }
        else if([[segue identifier] isEqualToString:@"CityPlayerSegue"])
        {
            CityViewController * city = (CityViewController *)[segue destinationViewController];
            city.lat = [[NSString alloc] initWithFormat:@"%@",lat];
            city.lng = [[NSString alloc] initWithFormat:@"%@",lng];
        }
        
}

@end
