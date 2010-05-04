//
//  ServerAppDelegate.h
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PersonServer;

@interface ServerAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
	NSTextField* status;
	NSProgressIndicator* progress;
	IBOutlet NSTableView* tableView;
	PersonServer* server;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField* status;
@property (assign) IBOutlet NSProgressIndicator* progress;

@end
