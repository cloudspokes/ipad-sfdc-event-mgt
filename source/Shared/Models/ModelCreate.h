//
//  ModelCreate.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@class ZKSaveResult;

@interface ModelCreate : Model {
	NSDictionary *_values;
	ZKSaveResult *_result;
}

@property (nonatomic, retain) NSDictionary *values;
@property (nonatomic, readonly) ZKSaveResult *result;

@end
