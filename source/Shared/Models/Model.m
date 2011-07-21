//
//  Model.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "Model.h"
#import "ModelProtocols.h"

#import "NSMutableArray+Weak.h"

@implementation Model

@synthesize objectName = _sObjectName;
@synthesize lastUpdate = _lastUpdate;

- (NSMutableArray *)delegates {
	if (_delegates == nil) {
		_delegates = [NSMutableArray mutableArrayUsingWeakReferences];
	}
	return _delegates;
}

- (void)execute {
	if (self.objectName == nil) {
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Missing object name" forKey:NSLocalizedDescriptionKey];
		[self modelFailedWithError:[NSError errorWithDomain:@"Model"
													   code:-1001
												   userInfo:errorInfo]];
		
	} else {
		for (id<ModelDelegate> delegate in self.delegates) {
			if ([delegate respondsToSelector:@selector(modelWillExecute:)]) {
				[delegate modelWillExecute:self];
			}
		}
	}
}

- (void)modelHasChanged {
	for (id<ModelDelegate> delegate in self.delegates) {
		if ([delegate respondsToSelector:@selector(modelHasChanged:)]) {
			[delegate modelHasChanged:self];
		}
	}
	
	// update the date
	[_lastUpdate release];
	_lastUpdate = [[NSDate date] retain];
}

- (void)modelFailedWithError:(NSError *)error {
	for (id<ModelDelegate> delegate in self.delegates) {
		if ([delegate respondsToSelector:@selector(modelHasFailed:withError:)]) {
			[delegate modelHasFailed:self withError:error];
		}
	}
}

- (void)dealloc {
	[_delegates release]; _delegates = nil;
	[_lastUpdate release]; _lastUpdate = nil;
	[super dealloc];
}

@end
