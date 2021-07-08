//
//  CXMotorcadeSocketPushInfo.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import <CoreLocation/CoreLocation.h>
#import <CXSocketSDK/CXSocketSDK.h>
#import <CXFoundation/CXFoundation.h>
#import "CXBaseUserJSONModel.h"

CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushCoordinate;          // 队员的位置信息
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushBeckon;              // 召唤队友
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushUpdateDestination;   // 目的地更新
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushDissolve;            // 解散车队
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushKickOut;             // 踢出成员
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushQuit;                // 退出车队
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushOnTheLine;           // 上线
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushOffTheLine;          // 下线
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushUpdateMotorcadeName; // 修改车队名称
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushNewUserJoinOnline;   // 新用户加入车队并上线
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushChannelGME;          // GME推送换房间号
CX_FOUNDATION_EXTERN CXSocketPushContentType const CXMotorcadeSocketPushMicPermission;       // 麦克风权限变更

@interface CXMotorcadeSocketPushInfo : CXBaseUserJSONModel

@property (nonatomic, copy) NSString *motorcadeId;
@property (nonatomic, copy) NSString *type;            // CXSocketPushContentType
@property (nonatomic, copy) NSString *address;         // 车队目的地地址
@property (nonatomic, copy) NSString *name;            // 车队名称
@property (nonatomic, copy) NSString *userName;        // 用户名
@property (nonatomic, copy) NSString *userImgUrl;      // 用户头像
@property (nonatomic, copy) NSString *toast;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) NSInteger mode;          // 车队语音模式
@property (nonatomic, assign) NSInteger GMEChannelId;  // GME房间id
@property (nonatomic, assign) long leftTime;      // 更换时间
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, assign) NSInteger permission;    // 全员的麦克风权限变更，0-有权限，1-无权限
@property (nonatomic, assign) NSInteger micPermission; // 单个人的权限变更，0-有权限，1-无权限

- (CLLocationCoordinate2D)coordinate;

@end

CX_FOUNDATION_EXTERN BOOL CXIsMotorcadeSocketPushContentType(CXSocketPushContentType type);
