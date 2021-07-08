//
//  CXMotorcadeSocketHandler.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeSocketHandler.h"
#import <CXSocketSDK/CXSocketSDK.h>
#import "CXMotorcadeSocketPushInfo.h"
#import "CXMotorcadeCoordinateResponse.h"
#import "CXMotorcadeNotificationName.h"
#import "CXMotorcadeManager+CXExtensions.h"

@implementation CXMotorcadeSocketHandler

+ (BOOL)canHandleSocketPushContent:(CXSocketPushContent *)content{
    if([content.type isEqualToString:CXMotorcadeSocketPushCoordinate] ||
       [content.type isEqualToString:CXMotorcadeSocketPushUpdateDestination] ||
       [content.type isEqualToString:CXMotorcadeSocketPushBeckon] ||
       [content.type isEqualToString:CXMotorcadeSocketPushDissolve] ||
       [content.type isEqualToString:CXMotorcadeSocketPushKickOut] ||
       [content.type isEqualToString:CXMotorcadeSocketPushQuit] ||
       [content.type isEqualToString:CXMotorcadeSocketPushOnTheLine] ||
       [content.type isEqualToString:CXMotorcadeSocketPushOffTheLine] ||
       [content.type isEqualToString:CXMotorcadeSocketPushUpdateMotorcadeName] ||
       [content.type isEqualToString:CXMotorcadeSocketPushNewUserJoinOnline] ||
       [content.type isEqualToString:CXMotorcadeSocketPushChannelGME] ||
       [content.type isEqualToString:CXMotorcadeSocketPushMicPermission]){
        return YES;
    }
    return NO;
}

+ (void)handleSocketPushContent:(CXSocketPushContent *)content{
    if([content.type isEqualToString:CXMotorcadeSocketPushCoordinate]){
        CXMotorcadeCoordinateResponse *coordinateResponse = [CXMotorcadeCoordinateResponse cx_modelWithData:content.info];
        [self handleCoordinateResponse:coordinateResponse];
    }else if([content.type isEqualToString:CXMotorcadeSocketPushBeckon]){
        NSURL *URL = [NSURL URLWithString:content.url];
        if(!URL){
            return;
        }
        
        void (^notifySchemeHandlerBlock)(void) = ^{
            CXSchemeEvent *event = [[CXSchemeEvent alloc] initWithOpenURL:URL completion:^(CXSchemeBusinessModule module, CXSchemeBusinessPage page, NSString *error) {
                if(error){
                    [CXHUD showMsg:error];
                }
            }];
            event.pushType = CXSchemePushFromCurrentVC;
            [[CXMotorcadeManager sharedManager] notifyDelegateHandleSchemeEvent:event];
        };
        
        if([CXMotorcadeManager sharedManager].activeMotorcadeId){
            [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
                config.title = @"此操作会从当前小队下线";
                config.buttonTitles = @[@"放弃", @"确定"];
            } completion:^(NSUInteger buttonIndex) {
                if(buttonIndex == 1){
                    notifySchemeHandlerBlock();
                }
            }];
        }else{
            notifySchemeHandlerBlock();
        }
    }else{
        CXMotorcadeSocketPushInfo *motorcadePushInfo = [CXMotorcadeSocketPushInfo cx_modelWithData:content.info];
        motorcadePushInfo.type = content.type;
        if(CXStringIsEmpty(motorcadePushInfo.toast)){
            motorcadePushInfo.toast = content.text;
        }
        [self handleMotorcadeSocketPushInfo:motorcadePushInfo];
    }
}

+ (void)handleCoordinateResponse:(CXMotorcadeCoordinateResponse *)coordinateResponse{
    if(!coordinateResponse){
        return;
    }
    
    [NSNotificationCenter notify:CXMotorcadeSocketPushCoordinateNotification
                        userInfo:@{CXNotificationUserInfoKey0 : coordinateResponse}];
}

+ (void)handleMotorcadeSocketPushInfo:(CXMotorcadeSocketPushInfo *)motorcadePushInfo{
    if(!motorcadePushInfo){
        return;
    }
    
    [NSNotificationCenter notify:CXMotorcadeSocketPushNotification
                        userInfo:@{CXNotificationUserInfoKey0 : motorcadePushInfo}];
    
}

@end
