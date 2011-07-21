//
//  ModelUpdate.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/18/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@class ZKSaveResult;

@interface ModelUpdate : Model {
	NSString *_objectId;
	NSDictionary *_values;
	ZKSaveResult *_result;
}

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, retain) NSDictionary *values;
@property (nonatomic, readonly) ZKSaveResult *result;

@end
