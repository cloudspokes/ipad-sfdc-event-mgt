//
//  AppDelegate_iPad.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "AppDelegate_iPad.h"

#import "CampaignMasterViewController.h"
#import "CampaignMemberViewController.h"
#import "ModelLogin.h"


// OAuth token, please change it according to your application
#define kSFOAuthConsumerKey @"3MVG9VmVOCGHKYBRAdUsRjD8L.2AM7KwkXoY_kNf2Z32W6chkp6R94eiewW_qu2sLoIAj8gTTrjrCO1r7BsYt"


@implementation AppDelegate_iPad

@synthesize window;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// on the iPad just support the landscape mode
	self.leftViewController.portraitMode = NO;
	
	// Create the master-detail relationship
	self.leftViewController.delegate = self.rightViewController;
	self.rightViewController.delegate = self.leftViewController;
	
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
	
	// start the login session and set the delegate
	_loginModel = [ModelLogin new];
	_loginModel.consumerKey = kSFOAuthConsumerKey;
	_loginModel.delegate = self.leftViewController;
	[_loginModel loginWithOAuth];
	
    return YES;
}

- (IBAction)logOut {
	// to renew the token or change user
	[_loginModel loginWithOAuth];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[_loginModel release]; _loginModel = nil;
    [window release];
    [super dealloc];
}


@end
