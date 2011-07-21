//
//  AppDelegate_iPad.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CampaignMemberViewController;
@class CampaignMasterViewController;
@class ModelLogin;

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CampaignMasterViewController *_leftViewController;
    CampaignMemberViewController *_rightViewController;
	ModelLogin *_loginModel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CampaignMasterViewController *leftViewController;
@property (nonatomic, retain) IBOutlet CampaignMemberViewController *rightViewController;

- (IBAction)logOut;

@end

