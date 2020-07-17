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
#import <SocketRocketTact/SRWebSocket.h>

@interface PTPusherConnection () <SRWebSocketDelegate>
@end

@implementation PTPusherMockConnection {
  NSMutableArray *sentClientEvents;
}

@synthesize sentClientEvents;

- (id)init
{
  if ((self = [super initWithURL:nil])) {
    sentClientEvents = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)connect
{
  [self webSocketDidOpen:[[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@""]]];
  
  NSInteger socketID = (NSInteger)[NSDate timeIntervalSinceReferenceDate];

  [self simulateServerEventNamed:PTPusherConnectionEstablishedEvent 
                            data:@{@"socket_id": @(socketID)}];
}

- (void)disconnect
{
  [self webSocket:[[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@""]] didCloseWithCode:self.disconnectionCode reason:nil wasClean:YES];
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
  
  event[PTPusherEventKey] = name;
  
  if (data) {
    event[PTPusherDataKey] = data;
  }
  
  if (channelName) {
    event[PTPusherChannelKey] = channelName;
  }
  
  NSString *message = [[PTJSON JSONParser] JSONStringFromObject:event];
  
  [self webSocket:[[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@""]] didReceiveMessage:message];
}

- (void)simulateUnexpectedDisconnection
{
  [self webSocket:[[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@""]] didCloseWithCode:kPTPusherSimulatedDisconnectionErrorCode reason:nil wasClean:NO];
}

#pragma mark - Client event handling

- (void)handleClientEvent:(NSDictionary *)eventData
{
  PTPusherEvent *event = [PTPusherEvent eventFromMessageDictionary:eventData];
  
  [sentClientEvents addObject:event];
  
  if ([event.name isEqualToString:@"pusher:subscribe"]) {
    [self handleSubscribeEvent:event];
  }
}

- (void)handleSubscribeEvent:(PTPusherEvent *)subscribeEvent
{
  [self simulateServerEventNamed:@"pusher_internal:subscription_succeeded" 
                            data:nil
                         channel:(subscribeEvent.data)[PTPusherChannelKey]];
}

@end
