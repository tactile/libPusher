//
//  PTPusherSpec.m
//  libPusher
//
//  Created by Luke Redpath on 26/11/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpecHelper.h"
#import "PTURLRequestOperation.h"

@interface PTURLRequestOperationSpecs : XCTestCase

@property (nonatomic, strong) PTURLRequestOperation *subject;
@property (nonatomic, weak) id<NSURLSessionDelegate> sessionDelegate;
@property (nonatomic, weak) NSURLSession *session;

@end

@implementation PTURLRequestOperationSpecs

- (void)setUp
{
  @autoreleasepool {
    NSURL *authURL = [NSURL URLWithString:@"http://example.com/authorize"];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    self.subject = [[PTURLRequestOperation alloc] initWithURLRequest:request];
    [self.subject start];
    XCTAssertNotNil(self.subject.URLSession);
    XCTAssertNotNil(self.subject.URLSession.delegate);
    self.sessionDelegate = self.subject.URLSession.delegate;
    self.session = self.subject.URLSession;
  }
}

- (void)testFinishShouldInvalidateTheSessionDestroyingTheSessionDelegateOnDeallocation
{
  [self.subject finish];
  self.subject = nil;
  
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
  
  XCTAssertNil(self.session);
  XCTAssertNil(self.sessionDelegate);
}

@end
