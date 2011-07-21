//
//  ModelProtocols.h
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@protocol ModelDelegate<NSObject>

- (void)modelWillExecute:(Model *)model;
- (void)modelHasChanged:(Model *)model;
- (void)modelHasFailed:(Model *)model withError:(NSError *)error;

@end

@protocol LoginModelDelegate

- (void)loginSuccess;

@end

