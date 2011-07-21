//
//  ModelUpdate.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/18/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelUpdate.h"

#import "FDCServerSwitchboard.h"
#import "ZKSaveResult.h"
#import "ZKSObject.h"

@implementation ModelUpdate

@synthesize objectId = _objectId;
@synthesize values = _values;
@synthesize result = _result;

- (void)execute {
	[super execute];
	
	if (self.objectId == nil) {
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Missing object ID" forKey:NSLocalizedDescriptionKey];
		[self modelFailedWithError:[NSError errorWithDomain:@"ModelUpdate"
													   code:-1004
												   userInfo:errorInfo]];
		
	} else {
		// init the sObject with the ID
		ZKSObject *object = [ZKSObject withTypeAndId:self.objectName sfId:self.objectId];
		for (NSString *key in [self.values allKeys]) {
			// populate the fields
			[object setFieldValue:[self.values objectForKey:key] field:key];
		}
		
		// send to the API
		[[FDCServerSwitchboard switchboard] update:[NSArray arrayWithObject:object]
											target:self
										  selector:@selector(createResult:error:context:)
										   context:nil];
	}
}


- (void)createResult:(NSArray *)result error:(NSError *)error context:(id)context {
    NSLog(@"updateResult:%@ error:%@ context:%@", result, error, context);
	
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
