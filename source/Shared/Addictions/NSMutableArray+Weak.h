//
//  NSMutableArray+Weak.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(WeakReferences) 

+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end
