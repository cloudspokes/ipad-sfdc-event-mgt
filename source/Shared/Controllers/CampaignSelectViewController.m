//
//  CampaignSelectViewController.m
//  EventManager
//
//  Created by Stefano Acerbetti on 6/16/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "CampaignSelectViewController.h"

#import "MBProgressHUD.h"
#import "ModelQuery.h"
#import "ZKSObject.h"

@implementation CampaignSelectViewController

@synthesize delegate = _delegates;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set the canvel button	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self
																						   action:@selector(cancel)]
											 autorelease];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Loading...";
    [self.navigationController.view addSubview:HUD];
	
	// init the model
	_model = [ModelQuery new];
	_model.objectName = @"Campaign";
	_model.objectFields = [NSArray arrayWithObjects:@"Id", @"Name", @"Type", @"Status", @"StartDate", @"EndDate", @"Description", nil];
	_model.objectOrderBy = [NSArray arrayWithObject:@"Name"];
	
	// consider only active campaigns
	ModelQueryFilterItem *filter = [ModelQueryFilterItem itemWithName:@"IsActive"
																value:@"true"
														  andOperator:ModelQueryFilterOperatorEqual];
	filter.addQuote = NO; // because it's a boolean
	_model.objectFilters = [NSArray arrayWithObject:filter];
	[_model.delegates addObject:self];
	
	// load the data
	[_model execute];
}

- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ModelDelegate

- (void)modelWillExecute:(Model *)model {
	[HUD show:YES];
}

- (void)modelHasChanged:(Model *)model {
	[HUD hide:YES];
	
	[self.tableView reloadData];
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
    return [_model.dataRows count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	ZKSObject *obj = [_model.dataRows objectAtIndex:indexPath.row];
	cell.textLabel.text = [obj fieldValue:@"Name"];
	cell.detailTextLabel.text = [obj fieldValue:@"Status"];
    
    return cell;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// call the delegate with the selected campaign
    [self.delegate didSelectCampaign:[_model.dataRows objectAtIndex:indexPath.row]];
	
	// close the modal view
	[self dismissModalViewControllerAnimated:YES];
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
	[HUD release]; HUD = nil;
	[_model release]; _model = nil;
    [super dealloc];
}

@end

