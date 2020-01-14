//
//  LRURLConnectionOperation.h
//  LRResty
//
//  Created by Luke Redpath on 04/10/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTURLRequestOperationURLSessionDelegate : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@interface PTURLRequestOperation : NSOperation <NSURLSessionDelegate, NSURLSessionDataDelegate> {
  BOOL _isExecuting;
  BOOL _isFinished;

  NSURLRequest *URLRequest;
  NSURLResponse *URLResponse;
  NSError *connectionError;
  NSMutableData *responseData;
}

@property (nonatomic, strong) NSURLRequest *URLRequest;
@property (nonatomic, strong, readonly) NSURLSession *URLSession;
@property (nonatomic, strong, readonly) NSURLResponse *URLResponse;
@property (nonatomic, strong, readonly) NSError *connectionError;
@property (nonatomic, strong, readonly) NSData *responseData;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (void)finish;
- (void)cancelImmediately;
- (void)checkForCancellation;
@end
