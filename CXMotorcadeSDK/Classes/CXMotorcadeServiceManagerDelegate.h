//
//  CXMotorcadeServiceManagerDelegate.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import <CoreGraphics/CoreGraphics.h>
#import "CXMotorcadeSocketPushInfo.h"
#import "CXMotorcadeCoordinateResponse.h"
#import "CXMotorcadeOnlineModel.h"

@class CXMotorcadeServiceManager;

@protocol CXMotorcadeServiceManagerDelegate <NSObject>

@optional

/**
 * 小队数据更新（切换小队）
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeOnlineModel:(CXMotorcadeOnlineResultModel *)onlineModel;

/**
 * 退出或者解散小队
 */
- (void)motorcadeServiceManagerDidDissolve:(CXMotorcadeServiceManager *)serviceManager;

/**
 * 即将离开小队页面
 */
- (void)motorcadeServiceManagerWillLeave:(CXMotorcadeServiceManager *)serviceManager;

/**
 * GME房间id变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeGMERoomId:(NSInteger)roomId;

/**
 * 麦克风权限变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeMicrophonePermission:(BOOL)permission;

/**
 * 目的地变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeDestination:(CXMotorcadeDestinationModel *)destinationModel;

/**
 * 成员位置变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeMemberCoordinates:(CXMotorcadeCoordinateResponse *)response;

/**
 * 需重新请求GME房间号，以后考虑内部实现
 */
- (void)motorcadeServiceManagerReloadGMERoomId:(CXMotorcadeServiceManager *)serviceManager;

/**
 * 导航到目的地
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager navigateToCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 * 选择目的地
 */
- (void)motorcadeServiceManagerChooseDestination:(CXMotorcadeServiceManager *)serviceManager;

/**
 * 点击某个成员
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didSelectMemberAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 成员列表变更（全量）
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didReloadMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members;

/**
 * 顶部toolbar的展开和折叠
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager toolbarAnimationFrame:(CGRect)frame forClose:(BOOL)close;

/**
 * 顶部toolbar的高度变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeToolbarFrameHeight:(CGFloat)frameHeight offsetHeight:(CGFloat)offsetHeight;

/**
 * 成员的状态变化
 */
- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeMemberState:(CXSocketPushContentType)stateType userId:(NSString *)userId;

@end
