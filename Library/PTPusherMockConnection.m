//
//  PTPusherMockConnection.m
//  libPusher
//
//  Created by Luke Redpath on 11/05/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "PTPusherMockConnection.h"
#import "PTJSON.h"
#import "PTPusherEvent.h"

@interface PTPusherMockConnection ()
- (void)simulateEventNamed:(NSString *)name data:(id)data;
@end

@implementation PTPusherMockConnection

@synthesize connected = _connected;

- (void)connect
{
  _connected = YES;
  
  NSInteger socketID = (NSInteger)[NSDate timeIntervalSinceReferenceDate];

  [self simulateServerEventNamed:PTPusherConnectionEstablishedEvent 
                            data:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:socketID] forKey:@"socket_id"]];
}

- (void)disconnect
{
  _connected = NO;
}

- (void)send:(id)object
{
  [self handleClientEvent:object];
}

#pragma mark - Event simulation

- (void)simulateServerEventNamed:(NSString *)name data:(id)data
{
  [self simulateServerEventNamed:name data:data channel:nil];
}

- (void)simulateServerEventNamed:(NSString *)name data:(id)data channel:(NSString *)channelName
{
  NSMutableDictionary *event = [NSMutableDictionary dictionary];
  
  [event setObject:name forKey:PTPusherEventKey];
  
  if (data) {
    [event setObject:data forKey:PTPusherDataKey];
  }
  
  if (channelName) {
    [event setObject:channelName forKey:PTPusherChannelKey];
  }
  
  NSString *message = [[PTJSON JSONParser] JSONStringFromObject:event];
  
  [self webSocket:nil didReceiveMessage:message];
}

#pragma mark - Client event handling

- (void)handleClientEvent:(NSDictionary *)eventData
{
  PTPusherEvent *event = [PTPusherEvent eventFromMessageDictionary:eventData];
  
  if ([event.name isEqualToString:@"pusher:subscribe"]) {
    [self handleSubscribeEvent:event];
  }
}

- (void)handleSubscribeEvent:(PTPusherEvent *)subscribeEvent
{
  [self simulateServerEventNamed:@"pusher_internal:subscription_succeeded" 
                            data:nil
                         channel:[subscribeEvent.data objectForKey:PTPusherChannelKey]];
}

@end
