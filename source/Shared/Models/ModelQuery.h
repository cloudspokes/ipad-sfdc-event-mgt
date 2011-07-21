//
//  ModelQuery.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

typedef enum {
    ModelQueryFilterOperatorLess,
    ModelQueryFilterOperatorGreater,
	ModelQueryFilterOperatorEqual
	// TODO: extend
} ModelQueryFilterOperator;

#pragma mark -

@interface ModelQueryFilterItem : NSObject {
	NSString *_fieldName;
	id _fieldValue;
	ModelQueryFilterOperator _fieldOp;
	BOOL addQuote;
}

@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) id fieldValue;
@property (nonatomic, assign) ModelQueryFilterOperator fieldOp;
@property (nonatomic, assign) BOOL addQuote;

+ (ModelQueryFilterItem *)itemWithName:(NSString *)name value:(id)value andOperator:(ModelQueryFilterOperator)op;

@end

#pragma mark -

@interface ModelQuery : Model {
	NSArray *_sObjectFields;
	NSArray *_sObjectFilters;
	NSArray *_sObjectOrderBy;
	NSArray *_sObjectGroupBy;
	
	NSMutableString *_queryString;
	NSArray *_dataRows;
}

@property (nonatomic, retain) NSArray *objectFields;
@property (nonatomic, retain) NSArray *objectFilters;
@property (nonatomic, retain) NSArray *objectOrderBy;
@property (nonatomic, retain) NSArray *objectGroupBy;

// the created query
@property (nonatomic, readonly) NSString *queryString;

// results
@property (nonatomic, readonly) NSArray *dataRows;

@end
