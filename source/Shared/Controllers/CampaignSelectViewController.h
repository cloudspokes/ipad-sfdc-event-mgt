//
//  CampaignSelectViewController.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CampaignProtocols.h";
#import "ModelProtocols.h"

@class ModelQuery;
@class MBProgressHUD;

@interface CampaignSelectViewController : UITableViewController<ModelDelegate> {
	ModelQuery *_model;
	id<CampaignSelectDelegate> _delegate;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, assign) id<CampaignSelectDelegate> delegate;

@end
