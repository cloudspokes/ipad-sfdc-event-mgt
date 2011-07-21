
================================================
iPad Event Management with SFDC
http://www.cloudspokes.com/challenge_detail.html?contestID=216
================================================


Video Tutorial:
================================================
http://www.screenr.com/0e7s



Description
================================================
The challenge was to build a campaign manager to modify the status of the members on-the-fly. The app
starts asking the saleforce.com credential and it's using the OAuth protocol to authenticate with the 
server. Once the credentials are verified the user can choose the campaign from the list of active
available in the org. The iPad screen is divided in two parts, on the left there are the basic 
details of the campaign and the associated statuses with the number of members for each status.
The status cell also acts as a filter for the members visualized in the main part of the screen.
The user can select the member to change the current status and the app will save the new status in 
saleforce.com. The user can also filter the current list using the search bar. The text is used to 
find record where first name, last name or email are starting with the input string.
In the left part of the screen the user can reload the record and the counters or change the selected
campaign with the 2 icons at the bottom of the screen



Main points
================================================
++ universal app optimized for iPad and iPhone
+ select one of the available campaigns for the account
+ members of a campaign can be selected by status
+ members of a campaign can be searched by (first name, last name and email)
+ counter of the number of members for each status
+ only standard UI components are used to provide the same look&feel of other iOS applications



Code
================================================
The models are the operations via the salesforce.com
- ModelLogin: to verify the credentials
- ModelCreate: to send the information to create an SObject 
- ModelQuery: a wrapper for a SOQL query
- ModelUpdate: to update an SObject

The controllers
- CampaignMasterViewController: shows the detail of the campaign with the list of available status
- CampaignMemberViewController: shows the list of members for each filter and include the search bar
- CampaignMemberStatusViewController: controller to change the status of a member
- CampaignSelectViewController: modal controller to select the campaign

In ModelLogin.m
- kPersintentToken: if defined, the app will reuse the latest credential without asking (for Development)

In AppDelegate_iPad.m & AppDelegate_iPhone.m
- kSFOAuthConsumerKey: OAuth token (you can customize it here)


3rd party lib
================================================
- iOS toolkit to connect to salesforce.com with the OAuth session
- MBProgressHUD for the activity indicator




