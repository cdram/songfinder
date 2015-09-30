//
//  AppDelegate.h
//  SongFinder
//
//  Created by shriram on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>
{
    UIWindow * window;
    UINavigationController * navigationController;
    Facebook * facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Facebook * facebook;
@property (nonatomic, retain) IBOutlet UIViewController * viewController;
@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@end
