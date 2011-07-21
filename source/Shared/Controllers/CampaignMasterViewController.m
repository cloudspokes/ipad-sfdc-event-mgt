//
//  CampaignMasterViewController.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "CampaignMasterViewController.h"

#import "CampaignMemberViewController.h"
#import "CampaignSelectViewController.h"
#import "ModelQuery.h"

#import "MBProgressHUD.h"
#import "ZKSObject.h"

@implementation CampaignMasterViewController

@synthesize object = _object;
@synthesize delegate = _delegate;
@synthesize portraitMode;

#pragma mark -
#pragma mark View lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	switch (interfaceOrientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			return YES;
	}
    return self.portraitMode;
}


#pragma mark -
#pragma mark Actions

- (IBAction)reload {
	// refresh the member status for the selected campaign
	if (self.object != nil) {
		ModelQueryFilterItem *filter = [ModelQueryFilterItem itemWithName:@"CampaignId"
																	value:[self.object getId]
															  andOperator:ModelQueryFilterOperatorEqual];
		_modelStatusLabels.objectFilters = [NSArray arrayWithObject:filter];
		[_modelStatusLabels execute];
	}
	
	// refresh the table with the new data
	[_tableView reloadData];
}

- (IBAction)settings {
	// present the available campaigns modally
	CampaignSelectViewController *controller = [[CampaignSelectViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.title = @"Select Campaign";
	controller.delegate = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[controller release];
}


#pragma mark -
#pragma mark LoginModelDelegate

- (void)loginSuccess {
	// open the settings page when the login is completed
	[self performSelector:@selector(settings) withObject:nil afterDelay:1];
	
	// create the model to describe the campaign member
	if (_modelStatusLabels == nil) {
		_modelStatusLabels = [ModelQuery new];
		_modelStatusLabels.objectName = @"CampaignMemberStatus";
		_modelStatusLabels.objectFields = [NSArray arrayWithObject:@"Label"];
		_modelStatusLabels.objectOrderBy = _modelStatusLabels.objectFields;
		[_modelStatusLabels.delegates addObject:self];
	}
	
	// and the model to get the counters for each status
	if (_modelStatusCounters == nil) {
		_modelStatusCounters = [ModelQuery new];
		_modelStatusCounters.objectName = @"CampaignMember";
		_modelStatusCounters.objectFields = [NSArray arrayWithObjects:@"Status", @"COUNT(Id) Members", nil];
		_modelStatusCounters.objectGroupBy = [NSArray arrayWithObject:@"ROLLUP(Status)"];
		[_modelStatusCounters.delegates addObject:self];
	}
	
	if (HUD == nil) {
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.mode = MBProgressHUDModeIndeterminate;
		HUD.labelText = @"Updating...";
		[self.navigationController.view addSubview:HUD];
	}
}


#pragma mark -
#pragma mark CampaignSelectDelegate

- (void)didSelectCampaign:(ZKSObject *)campaign {
	self.object = campaign;	
	
	// refresh everything
	[self reload];
	
	// show the whole list of members in the detail view (iPad only)
	if (self.delegate != self) {
		[self.delegate didSelectMemberForCampaignId:[campaign getId] andStatus:nil];
	}
}

- (NSArray *)memberStatusArray {
	return _modelStatusLabels.dataRows;
}


#pragma mark -
#pragma mark MemberSelectDelegate

- (void)didSelectMemberForCampaignId:(NSString *)campaignId andStatus:(NSString *)status {
	CampaignMemberViewController *controller = [[CampaignMemberViewController alloc] initWithNibName:@"CampaignMemberViewController" bundle:nil];
	controller.title = (status == nil) ? @"Member List" : status;
	controller.delegate = self;
	[controller didSelectMemberForCampaignId:campaignId andStatus:status];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark -
#pragma mark ModelDelegate

- (void)modelWillExecute:(Model *)model {
	// don't repeat the HUD when we are updating the labels
	if (model == _modelStatusLabels) {
		[HUD show:YES];
	}
}

- (void)modelHasChanged:(Model *)model {
	if (model == _modelStatusLabels) {
		// load the counters for the selected campaign
		_modelStatusCounters.objectFilters = _modelStatusLabels.objectFilters;
		[_modelStatusCounters execute];
		
	} else {
		// i'm done
		[HUD hide:YES];
	}
	
	// refresh the data
	[_tableView reloadData];
}

- (void)modelHasFailed:(Model *)model withError:(NSError *)error {
	[HUD hide:YES];
	
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil 
													 message:[error localizedDescription]
													delegate:nil 
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil]
						  autorelease];
	[alert show];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	// Show the second if the model to describe the member status is ready
    return (self.object != nil && self.memberStatusArray != nil) ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		return @"Members Per Status";
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (self.object != nil) {
		if (section == 0) {
			// informative section
			return [[self.object orderedFieldNames] count] - 2; // remove the IDs
			
		} else if (self.memberStatusArray != nil) {
			// member status if ready
			return [self.memberStatusArray count] + 1;
		}
	}
	return 0;
}

- (NSString *)numberMembersPerStatus:(NSString *)status {
	for (ZKSObject *label in _modelStatusCounters.dataRows) {
		NSString *string = [label fieldValue:@"Status"];
		if (string == status /* nil */ || [string isEqualToString:status]) {
			return [label fieldValue:@"Members"];
		}
	}
	
	// didn't find... return 0
	return @"0";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierInfo = @"infoCell";
    static NSString *CellIdentifierStatus = @"statusCell";
    
	UITableViewCell *cell = nil;
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierInfo];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifierInfo] autorelease];
			cell.detailTextLabel.numberOfLines = 0;
		}
		
		// Configure the cell for campaign info
		NSString *fieldName = [[self.object orderedFieldNames] objectAtIndex:indexPath.row + 2]; // skip the first 2 rows (IDs)
		cell.textLabel.text = fieldName;
		cell.detailTextLabel.text = [self.object fieldValue:fieldName];
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierStatus];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierStatus] autorelease];
			cell.detailTextLabel.numberOfLines = 0;
		}
		
		// Configure the cell for member status
		if (indexPath.row == 0) {
			cell.textLabel.text = @"ALL MEMBERS";
			// nil is the total because of the group by ROLLUP
			cell.detailTextLabel.text = [self numberMembersPerStatus:nil];
			
		} else {
			ZKSObject *status = [self.memberStatusArray objectAtIndex:indexPath.row - 1]; // add ALL
			cell.textLabel.text = [status fieldValue:@"Label"];
			cell.detailTextLabel.text = [self numberMembersPerStatus:cell.textLabel.text];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NSString *fieldName = [[self.object orderedFieldNames] objectAtIndex:indexPath.row + 2]; // skip the first 2 rows (IDs)
		NSString *fieldValue = [self.object fieldValue:fieldName];
		
		CGSize textHeight = [fieldValue sizeWithFont:[UIFont systemFontOfSize:14.0f]
								   constrainedToSize:CGSizeMake(220.0, 999.0)];
		return MAX(44.0, textHeight.height + 25.0);
		
	} else {
		return 44.0;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		// get the status value
		ZKSObject *status = (indexPath.row == 0) ? nil /* ALL */ :[self.memberStatusArray objectAtIndex:indexPath.row - 1];
		
		// call the delegate
		[self.delegate didSelectMemberForCampaignId:[self.object getId] andStatus:[status fieldValue:@"Label"]];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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


- (void)dealloc {
	[_modelStatusLabels release]; _modelStatusLabels = nil;
	[_modelStatusCounters release]; _modelStatusCounters = nil;
	self.object = nil;
    [super dealloc];
}


@end

