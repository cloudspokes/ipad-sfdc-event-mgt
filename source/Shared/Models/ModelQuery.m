//
//  ModelQuery.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelQuery.h"

#import "FDCServerSwitchboard.h"
#import "ZKQueryResult.h"

@implementation ModelQueryFilterItem

@synthesize fieldName = _fieldName;
@synthesize fieldValue = _fieldValue;
@synthesize fieldOp = _fieldOp;
@synthesize addQuote;

+ (ModelQueryFilterItem *)itemWithName:(NSString *)name value:(id)value andOperator:(ModelQueryFilterOperator)op {
	if (name != nil && value != nil) {
		ModelQueryFilterItem *item = [ModelQueryFilterItem new];
		item.fieldName = name;
		item.fieldValue = value;
		item.fieldOp = op;
		item.addQuote = YES;
		return [item autorelease];
	}
	return nil;
}

- (NSString *)description {
	NSString *opString = nil;
	switch (self.fieldOp) {
		case ModelQueryFilterOperatorEqual:
			opString = @"=";
			break;
			
		case ModelQueryFilterOperatorLess:
			opString = @"<";
			break;
			
		case ModelQueryFilterOperatorGreater:
			opString = @">";
			break;
	}
	
	if (self.addQuote) {
		self.fieldValue = [NSString stringWithFormat:@"'%@'", self.fieldValue];
		// avoid to add the quote multiple times
		self.addQuote = NO;
	}
	return [NSString stringWithFormat:@"(%@ %@ %@)", self.fieldName, opString, self.fieldValue];
}

@end

#pragma mark -

@implementation ModelQuery

@synthesize objectFields = _sObjectFields;
@synthesize objectFilters = _sObjectFilters;
@synthesize objectOrderBy = _sObjectOrderBy;
@synthesize objectGroupBy = _sObjectGroupBy;
@synthesize dataRows = _dataRows;
@synthesize queryString = _queryString;

- (void)execute {
	[super execute];
	
	if (self.objectFields == nil) {
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Please specify one or more fields" forKey:NSLocalizedDescriptionKey];
		[self modelFailedWithError:[NSError errorWithDomain:@"ModelQuery"
													   code:-1002
												   userInfo:errorInfo]];
		
	} else {
		[_queryString release];
		_queryString = [[NSMutableString alloc] initWithFormat:@"SELECT %@ FROM %@",
						[self.objectFields componentsJoinedByString:@","],
						self.objectName];
		
		if (self.objectFilters != nil) {
			[_queryString appendFormat:@" WHERE %@", [self.objectFilters componentsJoinedByString:@" AND "]];
		}
		
		if (self.objectGroupBy != nil) {
			[_queryString appendFormat:@" GROUP BY %@", [self.objectGroupBy componentsJoinedByString:@", "]];
		}
		
		if (self.objectOrderBy != nil) {
			[_queryString appendFormat:@" ORDER BY %@", [self.objectOrderBy componentsJoinedByString:@", "]];
		}
		
		[[FDCServerSwitchboard switchboard] query:_queryString
										   target:self
										 selector:@selector(queryResult:error:context:)
										  context:nil];
	}
}

- (void)queryResult:(ZKQueryResult *)result error:(NSError *)error context:(id)context {
    NSLog(@"queryResult:%@ error:%@ context:%@", result, error, context);
    [_dataRows release];
	
	if (result && !error) {
        _dataRows = [[result records] retain];
		[self modelHasChanged];
		
    } else if (error) {
		_dataRows = nil;
        [self modelFailedWithError:error];
    }
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%@)", self.queryString];
}

- (void)dealloc {
	self.objectName = nil;
	self.objectFields = nil;
	self.objectFilters = nil;
	self.objectGroupBy = nil;
	self.objectOrderBy = nil;
	[_queryString release]; _queryString = nil;
	[_dataRows release]; _dataRows = nil;
	[super dealloc];
}

@end
