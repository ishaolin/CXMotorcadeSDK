//
//  CXMotorcadeDefines.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#ifndef CXMotorcadeDefines_h
#define CXMotorcadeDefines_h

#import <CXUIKit/CXUIKit.h>

typedef NS_ENUM(NSUInteger, CXMotorcadeOnlineState) { // 在线状态
    CXMotorcadeOnlineStateOnline  = 0,  // 在线
    CXMotorcadeOnlineStateOffline = 1   // 下线
};

typedef NS_ENUM(NSUInteger, CXMotorcadeVoiceMode) { // 语音模式
    CXMotorcadeRealTimeVoice = 0,  // 实时语音
    CXMotorcadeTalkbackVoice = 1   // 手抬对讲
};

typedef NS_ENUM(NSUInteger, CXMotorcadeType) {
    CXMotorcadeNormal   = 0,  // 普通小队
    CXMotorcadeOfficial = 1   // 官方小队
};

typedef NS_ENUM(NSUInteger, CXMotorcadeMemberType) {
    CXMotorcadeMemberCaptain = 0,  // 队长
    CXMotorcadeMemberNormal  = 1   // 普通成员
};

#define CX_MOTORCADE_IMAGE(name) CX_POD_IMAGE(name, @"CXMotorcadeSDK")

#endif /* CXMotorcadeDefines_h */
