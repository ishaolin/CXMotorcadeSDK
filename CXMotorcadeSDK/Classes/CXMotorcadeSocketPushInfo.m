//
//  CXMotorcadeSocketPushInfo.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeSocketPushInfo.h"
#import <objc/runtime.h>

@implementation CXMotorcadeSocketPushInfo

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

@end

CXSocketPushContentType const CXMotorcadeSocketPushCoordinate = @"carTeamCoordinate";
CXSocketPushContentType const CXMotorcadeSocketPushBeckon = @"beckon";
CXSocketPushContentType const CXMotorcadeSocketPushUpdateDestination = @"updateDestination";
CXSocketPushContentType const CXMotorcadeSocketPushDissolve = @"dissolve";
CXSocketPushContentType const CXMotorcadeSocketPushKickOut = @"kickOut";
CXSocketPushContentType const CXMotorcadeSocketPushQuit = @"quit";
CXSocketPushContentType const CXMotorcadeSocketPushOnTheLine = @"onTheLine";
CXSocketPushContentType const CXMotorcadeSocketPushOffTheLine = @"offTheLine";
CXSocketPushContentType const CXMotorcadeSocketPushUpdateMotorcadeName = @"updateMotorcadeName";
CXSocketPushContentType const CXMotorcadeSocketPushNewUserJoinOnline = @"newUserOnline";
CXSocketPushContentType const CXMotorcadeSocketPushChannelGME = @"channelGME";
CXSocketPushContentType const CXMotorcadeSocketPushMicPermission = @"motorcadeServer_micPermission";

BOOL CXIsMotorcadeSocketPushContentType(CXSocketPushContentType type){
    if(!type){
        return NO;
    }
    
    static NSArray<CXSocketPushContentType> *contentTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentTypes = @[CXMotorcadeSocketPushCoordinate,
                         CXMotorcadeSocketPushUpdateDestination,
                         CXMotorcadeSocketPushDissolve,
                         CXMotorcadeSocketPushKickOut,
                         CXMotorcadeSocketPushQuit,
                         CXMotorcadeSocketPushOnTheLine,
                         CXMotorcadeSocketPushOffTheLine,
                         CXMotorcadeSocketPushUpdateMotorcadeName,
                         CXMotorcadeSocketPushNewUserJoinOnline,
                         CXMotorcadeSocketPushChannelGME,
                         CXMotorcadeSocketPushMicPermission];
    });
    
    return [contentTypes containsObject:type];
}
