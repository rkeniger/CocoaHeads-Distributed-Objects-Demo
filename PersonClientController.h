//
//  PersonClientController.h
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PersonServerProtocol.h"

@class Person;

@interface PersonClientController : NSObject 
{
	IBOutlet NSWindow* window;
	IBOutlet NSTextField* status;
	IBOutlet NSTextField* name;
	IBOutlet NSImageView* imageView;
	IBOutlet NSProgressIndicator* progress;
	
	Person* person;
	
	NSDistantObject <PersonServerProtocol>* server;
}


- (IBAction)changeName:(id)sender;

@end
