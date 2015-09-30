//
//  SecondViewController.h
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface SecondViewController : UIViewController <FBSessionDelegate, FBDialogDelegate>
{
    NSString * link;
    IBOutlet UIWebView * web;
    IBOutlet UIToolbar * toolbar;
    IBOutlet UIBarButtonItem * fShare;
    IBOutlet UIBarButtonItem * close;
    Facebook * fbGraph;
    NSString * key;
    NSString * lat;
    NSString * lng;
}

@property(nonatomic, retain) NSString * lat;
@property(nonatomic, retain) NSString * lng;
@property(nonatomic, retain) NSString * key;
@property(nonatomic, retain) Facebook * fbGraph;
@property(nonatomic, retain) IBOutlet UIWebView * web;
@property(nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * fShare;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * close;
@property(copy) NSString * link;

-(IBAction)facebookShare:(id)sender;
-(IBAction)closeApp:(id)sender;

@end
