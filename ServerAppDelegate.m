//
//  ServerAppDelegate.m
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import "ServerAppDelegate.h"
#import "PersonServer.h"

@interface ServerAppDelegate (Private)
- (void)startServer;
@end

@implementation ServerAppDelegate
@synthesize window,status,progress;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	[self performSelector:@selector(startServer) withObject:nil afterDelay:0];
}

- (void)startServer
{
	[progress startAnimation:self];
	[status setStringValue:@"Registering server…"];
	server = [PersonServer sharedServer];
	if(!server)
	{
		NSRunAlertPanel(@"The server could not be started.", @"The application will now terminate.", @"Quit", nil, nil);
		[NSApp terminate:self];
	}
	[progress stopAnimation:self];
	[status setStringValue:@"Server Running"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverUpdated:) name:PersonUpdatedNotification object:nil];
}

- (void)serverUpdated:(NSNotification*)notification
{
	[tableView reloadData];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [server.people count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if([[aTableColumn identifier] isEqualToString:@"textColumn"])
	{
		return [[server.people objectAtIndex:rowIndex] name];
	}
	return nil;
}



@end
