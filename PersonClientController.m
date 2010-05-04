//
//  PersonClientController.m
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import "PersonClientController.h"
#import "Person.h"
#import <AddressBook/AddressBook.h>


@interface PersonClientController (Private)
- (void)configureClient;
- (void)updatePersonServer;
@end


@implementation PersonClientController
- (id)init
{
	self=[super init];
	if(self)
	{
		//create the person object
		person = [[Person alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[person release];
	[server release];
	[super dealloc];
}


#pragma mark -
#pragma mark NSApplication delegate methods

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	[self configureClient];
}

- (void)applicationWillTerminate:(NSNotification*)notification
{
	@try
	{
		[server deregisterPerson:person];	
	}
	@catch(NSException* e)
	{
		NSLog(@"Failed to deregister client: %@",[e name]);
	}
	
}

#pragma mark -
#pragma mark configure client
- (void)configureClient
{
	[status setStringValue:@"Connecting…"];
	
	//retrieve the current image and name from the address book
	//and assign them to the person
	ABAddressBook* ab = [ABAddressBook sharedAddressBook];
	ABPerson* me = [ab me];
	person.name = [me valueForProperty:kABFirstNameProperty];
	
	[name setStringValue:person.name];
		
	//get the port by asking the socket port name server for it
	//this uses bonjour to connect to the server
	NSPort* port = [[NSSocketPortNameServer sharedInstance] portForName:PersonSocketPortName host:@"*"];
	if(!port)
	{
		[status setStringValue:@"Could not connect to server."];
		return;
	}
	
	
	//create a DO connection to the server
	NSConnection *connection = [NSConnection connectionWithReceivePort:nil sendPort:port];
	if(!connection)
	{
		[status setStringValue:@"Could not connect to server."];
		return;
	}
	
	
	//ask the server for its root proxy object
	@try
	{
		server = (NSDistantObject <PersonServerProtocol>*)[connection rootProxy];
	}
	@catch(NSException* e)
	{
		[status setStringValue:@"Could not connect to server."];
		return;
	}
	
	
	if(!server)
	{
		[status setStringValue:@"Could not connect to server."];
		return;
	}
	
	//register the person object with the server
	@try
	{
		BOOL result = [server registerPerson:person];
		if(!result)
		{
			[status setStringValue:@"Could not register person."];
			return;
		}
			
	}
	@catch(NSException* e)
	{
		[status setStringValue:@"Could not connect to server."];
		return;
	}
	[status setStringValue:@"Connected."];
}

- (IBAction)changeName:(id)sender
{
	person.name = [sender stringValue];
	[self updatePersonServer];
}

- (void)updatePersonServer
{
	//register the person object with the server
	@try
	{
		[server updatePerson:person];	
	}
	@catch(NSException* e)
	{
		NSLog(@"Could not connect to server: %@",[e name]);
		[status setStringValue:@"Could not connect to server."];
		return;
	}
}

@end
