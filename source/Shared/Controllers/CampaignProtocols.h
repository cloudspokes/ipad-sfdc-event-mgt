//
//  CampaignProtocols.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/17/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKSObject;

// used to load the campaign details
@protocol CampaignSelectDelegate<NSObject>

@property (nonatomic, readonly) NSArray *memberStatusArray;

- (void)didSelectCampaign:(ZKSObject *)campaign;

@end

#pragma mark -

// used to load the member list for the selected campaign
@protocol MemberSelectDelegate<NSObject>

- (void)didSelectMemberForCampaignId:(NSString *)campaignId andStatus:(NSString *)status;

@end

#pragma mark -

// used to load the options for the status and update the status of a member
@protocol MemberStatusSelectDelegate<MemberSelectDelegate>

@property (nonatomic, assign) id<CampaignSelectDelegate> delegate;

- (void)didSelectStatus:(NSString *)status forMember:(ZKSObject *)member;

@end

