//
//  CampaignMemberViewController.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CampaignProtocols.h"
#import "ModelProtocols.h"

@class ModelQuery;
@class ModelUpdate;
@class MBProgressHUD;

@interface CampaignMemberViewController : UITableViewController<UISearchBarDelegate, MemberStatusSelectDelegate, ModelDelegate> {
	id<CampaignSelectDelegate> _delegate;
	
	ModelQuery *_modelQuery;
	ModelUpdate *_modelUpdate;
	
	MBProgressHUD *HUD;
	
	// fiter
	NSArray *_filteredArray;
	NSString *_filterString;
}

@end
