//
//  CityViewController.h
//  SongFinder
//
//  Created by shriram on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SecondViewController.h"

@interface CityViewController : UIViewController<FBSessionDelegate, FBDialogDelegate>
{
    Facebook * fbGraph;
    IBOutlet UIToolbar * toolbar;
    IBOutlet UIBarButtonItem * fShare;
    IBOutlet UIBarButtonItem * player;
    IBOutlet UIBarButtonItem * close;
    IBOutlet UITableView * table;
    NSString * lat;
    NSString * lng;
    NSArray * sortedKeys;
    NSDictionary * populator;
    NSMutableArray * utubeKeys;
    NSString * selectedKey;
    BOOL checkFlag;
}

@property (nonatomic, retain) NSString * selectedKey;
@property (nonatomic) BOOL checkFlag;
@property (nonatomic, retain) NSMutableArray * utubeKeys;
@property (nonatomic, retain) NSArray * sortedKeys;
@property (nonatomic, retain) NSDictionary * populator;
@property (copy) NSString * lat;
@property (copy) NSString * lng;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * fShare;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * player;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * close;

-(IBAction)facebookShare:(id)sender;
-(IBAction)closeApp:(id)sender;
-(IBAction)playerFunc:(id)sender;

@end
