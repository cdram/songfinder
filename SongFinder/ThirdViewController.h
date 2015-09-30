//
//  ThirdViewController.h
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"
#import "Facebook.h"
#import "CityViewController.h"

@interface ThirdViewController : UIViewController <UISearchBarDelegate,FBSessionDelegate, FBDialogDelegate>
{
    IBOutlet UISearchBar * search;
    IBOutlet UITableView * table;
    NSDictionary * populator;
    NSArray * sortedKeys;
    Facebook * fbGraph;
    IBOutlet UIToolbar * toolbar;
    IBOutlet UIBarButtonItem * close;
    IBOutlet UIBarButtonItem * fShare;
    IBOutlet UIBarButtonItem * play;
    SecondViewController * second;
    NSInteger youtubeKey;
    NSMutableArray * utube;
    NSString * linkFormation;
    NSString * selectedKey;
    NSString * lat;
    NSString * lng;
    BOOL keyFlag;
}
@property (nonatomic) BOOL keyFlag;
@property(nonatomic, retain) NSString * lat;
@property(nonatomic, retain) NSString * lng;
@property(nonatomic, retain) NSString * selectedKey;
@property(nonatomic, retain) NSString * linkFormation;
@property(nonatomic, retain) NSMutableArray * utube;
@property(nonatomic) NSInteger youtubeKey;
@property(nonatomic, retain) Facebook * fbGraph;
@property(nonatomic, retain) SecondViewController * second;
@property(nonatomic, retain) IBOutlet UISearchBar * search;
@property(nonatomic, retain) IBOutlet UITableView * table;
@property(nonatomic, retain) NSDictionary * populator;
@property(nonatomic, retain) NSArray * sortedKeys;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * close;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * fShare;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * play;
@property(nonatomic, retain) IBOutlet UIToolbar * toolbar;

-(IBAction)citySpot:(id)sender;
-(IBAction)facebookShare:(id)sender;
-(IBAction)player:(id)sender;


@end