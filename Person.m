//
//  Person.m
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import "Person.h"


@implementation Person

- (id)init
{
	self=[super init];
	if(self)
	{
		personID = [[[NSProcessInfo processInfo] globallyUniqueString] retain];
	}
	return self;
}

- (id)initWithImage:(NSImage*)img name:(NSString*)aName
{
	self=[self init];
	if(self)
	{
		name = [aName copy];
	}
	return self;
}

- (void)dealloc
{
	self.name = nil;
	[personID release];
	[super dealloc];
}

@synthesize name;
@synthesize personID;
@end
