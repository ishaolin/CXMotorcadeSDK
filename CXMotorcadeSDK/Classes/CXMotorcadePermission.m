//
//  CXMotorcadePermission.m
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXMotorcadePermission.h"
#import <AVFoundation/AVFoundation.h>
#import <CXFoundation/CXFoundation.h>
#import <CXUIKit/CXUIKit.h>

@implementation CXMotorcadePermission

+ (void)checkMicPermission:(CXMotorcadePermissionBlock)block{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized:{
            !block ?: block(YES, NO);
        }
            break;
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                [CXDispatchHandler asyncOnMainQueue:^{
                    !block ?: block(granted, YES);
                }];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:{
            [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
                config.message = [NSString stringWithFormat:@"请打开系统设置中“隐私->麦克风”，允许“%@”访问您的麦克风。", [NSBundle mainBundle].cx_appName];
                config.buttonTitles = @[@"取消", @"去设置"];
            } completion:^(NSUInteger buttonIndex) {
                if(buttonIndex == 1){
                    [CXAppUtil openOSSettingPage];
                }
            }];
            
            !block ?: block(NO, NO);
        }
            break;
        default:
            break;
    }
}

@end
