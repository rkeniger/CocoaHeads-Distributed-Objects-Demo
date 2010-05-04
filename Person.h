//
//  Person.h
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Person : NSObject 
{
	NSString* name;
	NSString* personID;
}

@property (copy) NSString* name;
@property (readonly) NSString* personID;

@end
