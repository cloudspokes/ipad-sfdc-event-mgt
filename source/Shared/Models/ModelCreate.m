//
//  ModelCreate.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelCreate.h"

#import "FDCServerSwitchboard.h"
#import "ZKSaveResult.h"
#import "ZKSObject.h"

@implementation ModelCreate

@synthesize values = _values;
@synthesize result = _result;

- (void)execute {
	[super execute];
	
	// init the sObject
	ZKSObject *object = [ZKSObject withType:self.objectName];
	for (NSString *key in [self.values allKeys]) {
		// populate the fields
		[object setFieldValue:[self.values objectForKey:key] field:key];
	}
	
	// send to the API
	[[FDCServerSwitchboard switchboard] create:[NSArray arrayWithObject:object]
										target:self
									  selector:@selector(createResult:error:context:)
									   context:nil];
}


- (void)createResult:(NSArray *)result error:(NSError *)error context:(id)context {
    NSLog(@"createResult:%@ error:%@ context:%@", result, error, context);
	
	if (result && !error) {
		// retain the first and only result since I'm doing a single request
		_result = [[result objectAtIndex:0] retain];
		[self modelHasChanged];
		
    } else if (error) {
		_result = nil;
        [self modelFailedWithError:error];
    }
}

- (void)dealloc {
	self.values = nil;
	[_result release]; _result = nil;
	[super dealloc];
}

@end
