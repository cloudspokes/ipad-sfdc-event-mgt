//
//  AppDelegate_iPhone.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "CampaignMasterViewController.h"
#import "ModelLogin.h"


// OAuth token, please change it according to your application
#define kSFOAuthConsumerKey @"3MVG9VmVOCGHKYBRAdUsRjD8L.2AM7KwkXoY_kNf2Z32W6chkp6R94eiewW_qu2sLoIAj8gTTrjrCO1r7BsYt"


@implementation AppDelegate_iPhone

@synthesize window;
@synthesize campaignViewController = _campaignViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // on the iPhone support all the rotations
	self.campaignViewController.portraitMode = YES;
	
	// set the delegates
	self.campaignViewController.delegate = self.campaignViewController;
	
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
	
	// start the login session and set the delegate
	_loginModel = [ModelLogin new];
	_loginModel.consumerKey = kSFOAuthConsumerKey;
	_loginModel.delegate = self.campaignViewController;
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


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
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
