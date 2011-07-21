//
//  CampaignMasterViewController.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CampaignProtocols.h"
#import "ModelProtocols.h"

@class ModelQuery;
@class MBProgressHUD;
@class ZKSObject;

@interface CampaignMasterViewController : UIViewController<LoginModelDelegate, ModelDelegate, MemberSelectDelegate, CampaignSelectDelegate> {
	id<MemberSelectDelegate> _delegate;
	
	IBOutlet UITableView *_tableView;
	IBOutlet UIToolbar *_toolBar;
	
	MBProgressHUD *HUD;
	ZKSObject *_object;
	
	ModelQuery *_modelStatusLabels;
	ModelQuery *_modelStatusCounters;
	
	BOOL portraitMode;
}

@property (nonatomic, retain) ZKSObject *object;
@property (nonatomic, assign) id<MemberSelectDelegate> delegate;
@property (nonatomic, assign) BOOL portraitMode;

- (IBAction)reload;
- (IBAction)settings;

@end
