//
//  PersonServer.m
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import "PersonServer.h"
#import "Person.h"

NSString* PersonUpdatedNotification = @"PersonsUpdatedNotification";

@implementation PersonServer

#pragma mark -
#pragma mark singleton handling
static PersonServer* sharedInstance = nil;
+ (PersonServer*)sharedServer
{
	if (self == [PersonServer class] && sharedInstance == nil) 
	{
		[[self alloc] init];
		if(![sharedInstance startServer])
		{
			[sharedInstance release];
			return nil;
		}
	}
	return sharedInstance;
}

//make sure that if someone manually allocs a shared controller we return the singleton
+ (id)allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}


#pragma mark -
#pragma mark initialization

- (id)init
{
	self=[super init];
	if(self)
	{
		people = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void)dealloc
{
	[people release];
	[server release];
	[super dealloc];
}

#pragma mark -
#pragma mark start the server

- (BOOL)startServer
{
	if(self.serverRunning)
		return NO;
	
	//create an NSSocketPort and initialise the NSConnection object
	NSSocketPort *port = [[[NSSocketPort alloc] init] autorelease];
	server = [[NSConnection alloc] initWithReceivePort:port sendPort:nil];
	if(!server)
	{
		return NO;
	}
	
	//make ourselves the root object of the server
	//Distributed Object method calls will be sent to this object
	[server setRootObject:self];
	
	//register the port with the name server, this advertises the port on the local network using Bonjour
	if(![[NSSocketPortNameServer sharedInstance] registerPort:port name:PersonSocketPortName])
	{
		return NO;
	}
	
	self.serverRunning = YES;
	return YES;
}

#pragma mark -
#pragma mark person server protocol implementation
- (BOOL)registerPerson:(Person*)person
{
	NSArray* ids = [people valueForKey:@"personID"];
	if([ids containsObject:person.personID])
	{
		return NO;
	}
	[people addObject:person];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PersonUpdatedNotification object:self];

	return YES;
}

- (BOOL)updatePerson:(Person*)person;
{
	NSLog(@"update person: %@",person);
	NSUInteger idx = NSUIntegerMax;
	for(Person* currentPerson in people)
	{
		if([currentPerson.personID isEqualToString:person.personID])
		{
			idx = [people indexOfObject:currentPerson];
			break;
		}
	}
	if(idx != NSUIntegerMax)
	{
		[people replaceObjectAtIndex:idx withObject:person];
	}
	else
	{
		[people addObject:person];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PersonUpdatedNotification object:self];
	
	return YES;
}

- (BOOL)deregisterPerson:(Person*)person;
{
	Person* personToRemove = nil;
	for(Person* currentPerson in people)
	{
		if([currentPerson.personID isEqualToString:person.personID])
		{
			personToRemove = currentPerson;
			break;
		}
	}
	if(personToRemove)
	{
		[people removeObjectAtIndex:[people indexOfObject:personToRemove]];
		return YES;
	}
	return NO;
}

@synthesize serverRunning, people;
@end
