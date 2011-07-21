//
//  CampaignMemberStatusViewController.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CampaignProtocols.h"

@class ZKDescribeField;
@class ZKSObject;

@interface CampaignMemberStatusViewController : UITableViewController {
	id<MemberStatusSelectDelegate> _delegate;
	ZKSObject *_member;
}

@property (assign, nonatomic) id<MemberStatusSelectDelegate> delegate;
@property (assign, nonatomic) ZKSObject *member;

@end
