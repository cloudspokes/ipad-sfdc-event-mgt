//
//  ModelLogin.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelProtocols.h"

@class FDCOAuthViewController;

@interface ModelLogin : NSObject {
	UIViewController<LoginModelDelegate> *_delegate;
	FDCOAuthViewController *_oAuthViewController;
	
	NSString *_consumerKey;
}

@property (nonatomic, assign) UIViewController<LoginModelDelegate> *delegate;
@property (nonatomic, copy) NSString *consumerKey;

- (void)loginWithOAuth;
- (void)logout;

@end
