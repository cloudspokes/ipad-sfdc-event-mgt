//
//  CampaignMemberViewController.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "CampaignMemberViewController.h"

#import "CampaignMemberStatusViewController.h"
#import "ModelQuery.h"
#import "ModelUpdate.h"

#import "MBProgressHUD.h"
#import "ZKSObject.h"

#pragma mark -

@interface CampaignMemberViewController(Private)

- (NSArray *)filterResults:(NSArray *)results;

@end

#pragma mark -

@implementation CampaignMemberViewController

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)initCommon {
	// prepare the models
	_modelQuery = [ModelQuery new];
	_modelQuery.objectName = @"CampaignMember";
	_modelQuery.objectFields = [NSArray arrayWithObjects:@"Id", @"Contact.Name", @"Contact.FirstName", @"Contact.LastName", @"Contact.Email",
								@"Lead.Name", @"Lead.FirstName", @"Lead.LastName", @"Lead.Email", @"Status", nil];
	_modelQuery.objectOrderBy = [NSArray arrayWithObject:@"CreatedDate"]; // I need something that doesn't change
	[_modelQuery.delegates addObject:self];
	
	_modelUpdate = [ModelUpdate new];
	_modelUpdate.objectName = @"CampaignMember";
	[_modelUpdate.delegates addObject:self];
}

// used by the iPhone
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self initCommon];
	}
	return self;
}

// used by the iPad
- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self initCommon];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (HUD == nil) {
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.mode = MBProgressHUDModeIndeterminate;
		[self.navigationController.view addSubview:HUD];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (ZKSObject *)contactInfoFromMember:(ZKSObject *)member {
	ZKSObject *contact = [member fieldValue:@"Contact"];
	if (contact == nil) {
		// try with the lead
		contact = [member fieldValue:@"Lead"];
	}
	return contact;
}


#pragma mark -
#pragma mark MemberStatusSelectDelegate

- (void)didSelectMemberForCampaignId:(NSString *)campaignId andStatus:(NSString *)status {
	// create the filters
	ModelQueryFilterItem *campaignFilter = [ModelQueryFilterItem itemWithName:@"CampaignId"
																		value:campaignId
																  andOperator:ModelQueryFilterOperatorEqual];
	// status filter can be nil
	ModelQueryFilterItem *statusFilter = [ModelQueryFilterItem itemWithName:@"Status"
																	  value:status
																andOperator:ModelQueryFilterOperatorEqual];
	
	_modelQuery.objectFilters = [NSArray arrayWithObjects:campaignFilter, statusFilter, nil];
	
	// execute the query
	[_modelQuery execute];
}

- (void)didSelectStatus:(NSString *)status forMember:(ZKSObject *)member {
	if (status != nil) {
		// prepare the update model
		_modelUpdate.objectId = [member getId];
		_modelUpdate.values = [NSDictionary dictionaryWithObject:status forKey:@"Status"];
		
		// execute the query
		[_modelUpdate execute];
	}
}


#pragma mark -
#pragma mark ModelDelegate

- (void)modelWillExecute:(Model *)model {
	HUD.labelText = (model == _modelQuery) ? @"Loading..." : @"Saving...";
	[HUD show:YES];
	
}

- (void)modelHasChanged:(Model *)model {	
	if (model == _modelQuery) {
		[HUD hide:YES];

		// filter the result with the current string
		[_filteredArray release];
		_filteredArray = [[self filterResults:_modelQuery.dataRows] retain];
		
		// reload the table
		[self.tableView reloadData];
		
	} else if (model == _modelUpdate) {
		// update succeded, update the list
		[_modelQuery execute];
	}
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_filteredArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	ZKSObject *member = [_filteredArray objectAtIndex:indexPath.row];
	ZKSObject *contact = [self contactInfoFromMember:member];
	
	NSMutableString *string = [NSMutableString stringWithString:[contact fieldValue:@"Name"]];
	if ([contact fieldValue:@"Email"] != nil) {
		[string appendFormat:@" - %@", [contact fieldValue:@"Email"]];
	}
	
	cell.textLabel.text = string;
	cell.detailTextLabel.text = [member fieldValue:@"Status"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_filteredArray != nil) {
		CampaignMemberStatusViewController *controller = [[CampaignMemberStatusViewController alloc] initWithStyle:UITableViewStylePlain];
		controller.delegate = self;
		controller.member = [_filteredArray objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark UISearchBarDelegate

// order by LastName ascending
NSComparisonResult compare(ZKSObject* firstMember, ZKSObject* secondMember, void* context) {
	ZKSObject *firstContact = [(CampaignMemberViewController *)context contactInfoFromMember:firstMember];
	ZKSObject *secondContact = [(CampaignMemberViewController *)context contactInfoFromMember:secondMember];
	
	return [[firstContact fieldValue:@"LastName"] compare:[secondContact fieldValue:@"LastName"] options:NSCaseInsensitiveSearch];
}

- (NSArray *)filterResults:(NSArray *)results {
	if ([_filterString length] == 0) {
		// sort the whole array
		return [results sortedArrayUsingFunction:compare context:self];
		
	} else {
		NSMutableArray *array = [NSMutableArray array];
		
		// get the strings
		for (ZKSObject *member in results) {
			ZKSObject *contact = [self contactInfoFromMember:member];
			
			// simple algo to filter the results
			NSString *first = [[contact fieldValue:@"FirstName"] lowercaseString];
			NSString *last = [[contact fieldValue:@"LastName"] lowercaseString];
			NSString *email = [[contact fieldValue:@"Email"] lowercaseString];
			
			if ([first hasPrefix:_filterString] ||[last hasPrefix:_filterString] || [email hasPrefix:_filterString]) {
				[array addObject:member];
			}
		}
		
		// sort the filtered array
		return [array sortedArrayUsingFunction:compare context:self];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	// save the new filter string
	[_filterString release];
	_filterString = [[searchText lowercaseString] retain];
	
	if (_modelQuery.dataRows != nil) {
		// compute the new array
		[_filteredArray release];
		_filteredArray = [[self filterResults:_modelQuery.dataRows] retain];
		
		// reload the table
		[self.tableView reloadData];
	}
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
	[_filteredArray release]; _filteredArray = nil;
	[_filterString release]; _filterString = nil;
	[_modelQuery release]; _modelQuery = nil;
	[_modelUpdate release]; _modelUpdate = nil;
    [super dealloc];
}

@end

