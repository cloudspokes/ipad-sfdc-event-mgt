//
//  CampaignMemberStatusViewController.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "CampaignMemberStatusViewController.h"

#import "ZKSObject.h"

@implementation CampaignMemberStatusViewController

@synthesize delegate = _delegate;
@synthesize member = _member;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ZKSObject *contact = [self.member fieldValue:@"Contact"];
	if (contact == nil) {
		// try with the lead
		contact = [self.member fieldValue:@"Lead"];
	}
	
	self.title = [contact fieldValue:@"Name"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.delegate.delegate.memberStatusArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	ZKSObject *status = [self.delegate.delegate.memberStatusArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [status fieldValue:@"Label"];
	
	// Show the check for the previous selected option
	NSString *value = [self.member fieldValue:@"Status"];
	cell.accessoryType = ([value isEqualToString:cell.textLabel.text]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// notify the delegate of the new status if it's changed
	ZKSObject *status = [self.delegate.delegate.memberStatusArray objectAtIndex:indexPath.row];
	NSString *newStatus = [status fieldValue:@"Label"];
	NSString *oldStatus = [self.member fieldValue:@"Status"];
	
	if (![newStatus isEqualToString:oldStatus]) {
		[self.delegate didSelectStatus:newStatus forMember:self.member];
	}
	
	// remove the view from the navigation controller
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

