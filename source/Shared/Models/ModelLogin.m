//
//  ModelLogin.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelLogin.h"

// iOS toolkit
#import "FDCOAuthViewController.h"
#import "FDCServerSwitchboard.h"

// to avoid entering username and password every time
// #define kPersintentToken

#define kInstanceUrl_key	@"instanceUrl"
#define kAccessToken_key	@"accessToken"
#define kRefreshToken_key	@"refreshToken"

@implementation ModelLogin

@synthesize delegate = _delegate;
@synthesize consumerKey = _consumerKey;

- (void)showLoginViewController {
	// open the OAuth controller 
	[_oAuthViewController release];
	_oAuthViewController = [[FDCOAuthViewController alloc] initWithTarget:self
																 selector:@selector(loginOAuth:error:)
																 clientId:self.consumerKey];
	_oAuthViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self.delegate.navigationController presentModalViewController:_oAuthViewController animated:YES];
}

- (void)loginWithOAuth {
	
#ifdef kPersintentToken
	// load data from previous login if available
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	
	if ([defaults stringForKey:kRefreshToken_key] != nil) {
		// set the previous login informations
		[[FDCServerSwitchboard switchboard] setClientId:self.consumerKey];
        [[FDCServerSwitchboard switchboard] setApiUrlFromOAuthInstanceUrl:[defaults stringForKey:kInstanceUrl_key]];
        [[FDCServerSwitchboard switchboard] setOAuthRefreshToken:[defaults stringForKey:kRefreshToken_key]];
		
		// call the delegate with the previous session
		[self.delegate loginSuccess];
		
	} else {	
		// ask for credentials
		[self showLoginViewController];
	}
#else
	// ask for credentials
	[self showLoginViewController];
#endif
}

- (void)loginOAuth:(FDCOAuthViewController *)oAuthViewController error:(NSError *)error {
    NSLog(@"loginOAuth: %@ error: %@", oAuthViewController, error);
    
    if ([oAuthViewController accessToken] && !error) {
		[[FDCServerSwitchboard switchboard] setClientId:self.consumerKey];
        [[FDCServerSwitchboard switchboard] setApiUrlFromOAuthInstanceUrl:[oAuthViewController instanceUrl]];
        [[FDCServerSwitchboard switchboard] setSessionId:[oAuthViewController accessToken]];
        [[FDCServerSwitchboard switchboard] setOAuthRefreshToken:[oAuthViewController refreshToken]];
		
#ifdef kPersintentToken
		// save the data
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[oAuthViewController instanceUrl] forKey:kInstanceUrl_key];
		[defaults setObject:[oAuthViewController accessToken] forKey:kAccessToken_key];
		[defaults setObject:[oAuthViewController refreshToken] forKey:kRefreshToken_key];
		[defaults synchronize];
#endif
    }
	
	// close the modal view
	[_oAuthViewController dismissModalViewControllerAnimated:YES];
	
	// call the delegate to complete the login
	[self.delegate loginSuccess];
}

- (void)logout {
	// invalidate the OAuth session
	[[FDCServerSwitchboard switchboard] setApiUrlFromOAuthInstanceUrl:nil];
	[[FDCServerSwitchboard switchboard] setSessionId:nil];
	[[FDCServerSwitchboard switchboard] setOAuthRefreshToken:nil];
}

- (void)dealloc {
	[_oAuthViewController release]; _oAuthViewController = nil;
	[super dealloc];
}

@end
