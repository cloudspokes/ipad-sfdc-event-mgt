//
//  Model.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject {
	NSString *_sObjectName;
	NSDate *_lastUpdate;
	
	NSMutableArray *_delegates;
}

@property (nonatomic, copy) NSString *objectName;
@property (nonatomic, readonly) NSMutableArray *delegates;
@property (nonatomic, readonly) NSDate *lastUpdate;

- (void)execute;
- (void)modelHasChanged;
- (void)modelFailedWithError:(NSError *)error;

@end
