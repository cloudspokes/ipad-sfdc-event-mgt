//
//  AppDelegate_iPhone.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CampaignMasterViewController;
@class ModelLogin;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CampaignMasterViewController *_campaignViewController;
	ModelLogin *_loginModel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CampaignMasterViewController *campaignViewController;

- (IBAction)logOut;

@end

