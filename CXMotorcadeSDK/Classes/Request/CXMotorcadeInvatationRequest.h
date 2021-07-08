//
//  CXMotorcadeInvatationRequest.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXBaseMotorcadeURLRequest.h"
#import "CXMotorcadeInvatationModel.h"

typedef NS_ENUM(NSInteger, CXMotorcadeInviteType){
    CXMotorcadeInviteWeChat = 0,
    CXMotorcadeInviteSMS    = 1
};

@interface CXMotorcadeInvatationRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithInviteType:(CXMotorcadeInviteType)inviteType;

@end
