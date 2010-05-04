//
//  PersonServerProtocol.h
//  Server
//
//  Created by Rob Keniger on 4/05/10.
//  Copyright 2010 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PersonSocketPortName @"PersonSocketPortName"

@class Person;

@protocol PersonServerProtocol
- (BOOL)registerPerson:(Person*)person;
- (BOOL)updatePerson:(Person*)person;
- (BOOL)deregisterPerson:(Person*)person;
@end
