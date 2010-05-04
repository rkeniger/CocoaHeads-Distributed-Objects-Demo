//
//  PersonServer.h
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PersonServerProtocol.h"

extern NSString* PersonUpdatedNotification;

@interface PersonServer : NSObject <PersonServerProtocol>
{
	//this is the Distributed Objects server
	NSConnection* server;
	
	//this is our list of people
	NSMutableArray* people;
	
	BOOL serverRunning;
}

@property (readonly) NSMutableArray* people;
@property BOOL serverRunning;

//initializes and starts the server
+ (PersonServer*)sharedServer;

- (BOOL)startServer;
@end
