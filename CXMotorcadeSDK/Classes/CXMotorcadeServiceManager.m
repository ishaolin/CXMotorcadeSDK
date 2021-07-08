//
//  CXMotorcadeServiceManager.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeServiceManager.h"
#import "CXMotorcadeSettingVC.h"
#import "CXMotorcadeInvitationVC.h"
#import "CXMotorcadeManager+CXExtensions.h"
#import "CXMotrocadePollingRequest.h"
#import "CXMotorcadeOfflineRequest.h"
#import "CXMotorcadeMicListRequest.h"
#import "CXMicPermissionChangeModel.h"
#import "CXMotorcadeUserListRequest.h"
#import "CXMotorcadeNotificationName.h"
#import "CXMotorcadeRequestUtils.h"

@interface CXMotorcadeServiceManager () <CXMotorcadeMemberToolbarDataSource, CXMotorcadeMemberToolbarDelegate,  CXMotorcadeSettingVCDelegate> {
    CXMotorcadeMemberToolbar *_memberToolbar;
    
    CXTimer *_pollingTimer;
    long _coordinateTimestamp;
    NSNumber *_networkState;
}

@property (nonatomic, weak) CXBaseViewController *viewController;
@property (nonatomic, weak) CXMotrocadePollingRequest *pollingRequest;

@end

@implementation CXMotorcadeServiceManager

- (instancetype)initWithViewController:(CXBaseViewController *)viewController onlineModel:(CXMotorcadeOnlineResultModel *)onlineModel{
    if(self = [super init]){
        self.viewController = viewController;
        _onlineModel = onlineModel;
    }
    
    return self;
}

- (void)viewDidLoad{
    _networkState = @([CXNetworkReachabilityManager isReachable]);
    
    self.viewController.navigationBar.hiddenBottomHorizontalLine = YES;
    self.viewController.navigationBar.contentInset = UIEdgeInsetsMake(0, 5.0, 0, 10.0);
    
    CXNavigationTitleView *titleView = self.viewController.navigationBar.navigationItem.titleView;
    [titleView setSubtitleFont:CX_PingFangSC_RegularFont(11.0)];
    [titleView setSubtitleColor:CXHexIColor(0x666666)];
    [titleView setTitleLineBreakMode:NSLineBreakByTruncatingMiddle];
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePageTitleActionForTapGestureRecognizer:) ]];
    self.viewController.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithImage:CX_MOTORCADE_IMAGE(@"motorcade_setting") highlightedImage:nil target:self action:@selector(handleActionForSettingButtonItem:)];
    
    _memberToolbar = [[CXMotorcadeMemberToolbar alloc] init];
    _memberToolbar.delegate = self;
    _memberToolbar.dataSource = self;
    CGFloat memberToolbar_X = 0;
    CGFloat memberToolbar_Y = CGRectGetMaxY(self.viewController.navigationBar.frame);
    CGFloat memberToolbar_W = CGRectGetWidth(self.viewController.navigationBar.frame);
    CGFloat memberToolbar_H = 0;
    _memberToolbar.frame = (CGRect){memberToolbar_X, memberToolbar_Y, memberToolbar_W, memberToolbar_H};
    [self.viewController.view addSubview:_memberToolbar];
    
    [self addNotificationObserver];
    [self setOnlineModel:_onlineModel];
}

- (void)setOnlineModel:(CXMotorcadeOnlineResultModel *)onlineModel{
    _onlineModel = onlineModel;
    
    if(_memberToolbar){
        _memberToolbar.destinationViewHidden = ![_onlineModel shouldShowAddressView];
        _memberToolbar.voiceMode = _onlineModel.motorcadeInfo.groupChat;
        [_memberToolbar setDestinationName:_onlineModel.motorcadeInfo.destModel.destinationName];
        
        [self setUpdateToolbarFrameHeightIfNeed];
        [_memberToolbar reloadMembers];
    }
    
    [self reloadViewControllerTitle];
    [self notifyDelegateChangeOnlineModel:onlineModel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startPolling];
    });
}

- (void)reloadMembersRequest{
    CXMotorcadeUserListRequest *request = [[CXMotorcadeUserListRequest alloc] initWithMotorcadeId:self.onlineModel.motorcadeInfo.id];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXMotorcadeUserListModel *model = (CXMotorcadeUserListModel *)data;
        if(model.isValid){
            self.onlineModel.data = model.result.data;
            self.onlineModel.motorcadeInfo.totalCount = @(model.result.data.count);
            __block NSUInteger onlineCount = 0;
            [model.result.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.onLineStatus == CXMotorcadeOnlineStateOnline){
                    onlineCount ++;
                }
            }];
            self.onlineModel.motorcadeInfo.onlineCount = @(onlineCount);
            
            [self->_memberToolbar reloadMembers];
            [self notifyDelegateReloadMembers:model.result.data];
            [self reloadViewControllerTitle];
        }
    } failure:nil];
}

- (void)handleActionForSettingButtonItem:(CXBarButtonItem *)buttonItem{
    CXDataRecord(@"30000074");
    
    __block CXMotorcadeUserInfoModel *userInfoModel = nil;
    [self.onlineModel.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isSelf]){
            userInfoModel = obj;
            *stop = YES;
        }
    }];
    
    CXMotorcadeSettingVC *settingVC = [[CXMotorcadeSettingVC alloc] initWithMotorcadeModel:self.onlineModel.motorcadeInfo isCaptain:userInfoModel.type == CXMotorcadeMemberCaptain];
    settingVC.delegate = self;
    [self.viewController.navigationController pushViewController:settingVC animated:YES];
}

- (void)handlePageTitleActionForTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    [_memberToolbar setClose:!_memberToolbar.isClosed animated:YES];
    
    [self reloadViewControllerTitle];
}

- (void)reloadViewControllerTitle{
    CXMotorcadeOnlineInfoModel *info = self.onlineModel.motorcadeInfo;
    self.viewController.title = [NSString stringWithFormat:@"%@(%@/%@)",
                                 info.name, @(MAX(info.onlineCount, 1)),
                                 @(MAX(info.totalCount, 1))];
    NSString *subtitle = [NSString stringWithFormat:@"口令 %@", info.command];
    
    CXNavigationTitleView *titleView = self.viewController.navigationBar.navigationItem.titleView;
    UILabel *subtitleLabel = [titleView valueForKey:@"subtitleLabel"];
    subtitleLabel.hidden = NO;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", subtitle]];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    if(_memberToolbar.isClosed){
        attachment.image = CX_MOTORCADE_IMAGE(@"motorcade_map_toptool_up");
        self.viewController.navigationBar.shadowEnabled = YES;
    }else{
        attachment.image = CX_MOTORCADE_IMAGE(@"motorcade_map_toptool_down");
        self.viewController.navigationBar.shadowEnabled = NO;
    }
    attachment.bounds = CGRectMake(0, -2.5, 13.0, 13.0);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    [attributedString insertAttributedString:attachmentString atIndex:0];
    subtitleLabel.attributedText = [attributedString copy];
    [subtitleLabel setNeedsLayout];
    
    [CXMotorcadeManager setUpdateActiveMotorcadeOnlineCount:info.onlineCount];
}

- (void)addNotificationObserver{
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeSocketPushNotification:)
                                 name:CXMotorcadeSocketPushNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeSocketPushCoordinateNotification:)
                                 name:CXMotorcadeSocketPushCoordinateNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeMemberRemovedNotification:)
                                 name:CXMotorcadeMemberRemovedNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeNameChangedNotification:)
                                 name:CXMotorcadeNameChangedNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeDestinationChangedNotification:)
                                 name:CXMotorcadeDestinationChangedNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeMicPermissionChangedNotification:)
                                 name:CXMotorcadeMicPermissionChangedNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(networkingReachabilityDidChangeNotification:)
                                 name:CXNetworkingReachabilityDidChangeNotification];
}

- (void)motorcadeSocketPushNotification:(NSNotification *)notification{
    CXMotorcadeSocketPushInfo *pushInfo = notification.userInfo[CXNotificationUserInfoKey0];
    if(![pushInfo.motorcadeId isEqualToString:self.onlineModel.motorcadeInfo.id]){
        // 丢弃不是当前车队的数据
        return;
    }
    
    if([pushInfo.type isEqualToString:CXMotorcadeSocketPushUpdateDestination]){
        // 车队更换目的地
        NSDictionary<NSString *, id> *dictionary = @{@"destinationName" : CXJSONValidValue(pushInfo.address),
                                                     @"mclatitude" : @(pushInfo.lat),
                                                     @"mclongitude" : @(pushInfo.lng)};
        self.onlineModel.motorcadeInfo.destination = [NSJSONSerialization cx_stringWithJSONObject:dictionary];
        [_memberToolbar setDestinationName:self.onlineModel.motorcadeInfo.destModel.destinationName];
        _memberToolbar.destinationViewHidden = NO;
        [self setUpdateToolbarFrameHeightIfNeed];
        [self notifyDelegateChangeDestination:self.onlineModel.motorcadeInfo.destModel];
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushKickOut]){
        // 被踢出群聊
        if([pushInfo isSelf]){
            [self aletLeaveMotorcadeMsg:pushInfo.toast];
        }else{
            [self reloadMembersRequest];
            [self notifyDelegateChangeMemberState:pushInfo.type userId:pushInfo.userId];
        }
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushNewUserJoinOnline] ||
             [pushInfo.type isEqualToString:CXMotorcadeSocketPushOnTheLine] ||
             [pushInfo.type isEqualToString:CXMotorcadeSocketPushOffTheLine]) {
        // 新成员上线|上线|下线
        [self reloadMembersRequest];
        [self notifyDelegateChangeMemberState:pushInfo.type userId:pushInfo.userId];
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushQuit]){
        // 成员退出车队
        if([pushInfo isSelf]){
            if(pushInfo.source != 3){
                [self aletLeaveMotorcadeMsg:pushInfo.toast];
            }
        }else{
            [self reloadMembersRequest];
            [self notifyDelegateChangeMemberState:pushInfo.type userId:pushInfo.userId];
        }
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushDissolve]) {
        // 解散车队
        if([pushInfo isSelf] && pushInfo.source == 3){
            return;
        }
        
        [self aletLeaveMotorcadeMsg:pushInfo.toast];
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushUpdateMotorcadeName]){
        // 更改车队名称
        self.onlineModel.motorcadeInfo.name = pushInfo.name;
        [self reloadViewControllerTitle];
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushChannelGME]){
        // 更改GME房间号
        self.onlineModel.motorcadeInfo.roomNo = pushInfo.GMEChannelId;
        [self notifyDelegateChangeGMERoomId:pushInfo.GMEChannelId];
    }else if([pushInfo.type isEqualToString:CXMotorcadeSocketPushMicPermission]){
        // 麦克风权限变更
        bool permission = pushInfo.permission ?: pushInfo.micPermission;
        self.onlineModel.ownMicPermission = permission;
        if(pushInfo.permission != nil){
            [self handleAllMicrophonePermissionChange:pushInfo notifyDelegateBlock:^{
                [self notifyDelegateChangeMicrophonePermission:permission];
            }];
        }else{
            [self handleUserMicrophonePermissionChange:pushInfo];
            [self notifyDelegateChangeMicrophonePermission:permission];
        }
    }
}

- (void)handleAllMicrophonePermissionChange:(CXMotorcadeSocketPushInfo *)pushInfo
                        notifyDelegateBlock:(void (^)(void))notifyDelegateBlock{
    if(pushInfo.permission){
        _memberToolbar.allMicDisabled = NO;
        [_memberToolbar reloadMembers];
        notifyDelegateBlock();
    }else{
        // 全员禁麦，队长收到的消息不处理
        if([self.onlineModel isCaptain]){
            return;
        }
        
        [CXHUD showMsg:pushInfo.toast];
        _memberToolbar.allMicDisabled = YES;
        [_memberToolbar reloadMembers];
        notifyDelegateBlock();
    }
}

- (void)handleUserMicrophonePermissionChange:(CXMotorcadeSocketPushInfo *)pushInfo{
    __block NSUInteger index = NSNotFound;
    [self.onlineModel.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.userId isEqualToString:pushInfo.userId]){
            index = idx;
            obj.micPermission = pushInfo.micPermission;
            *stop = YES;
        }
    }];
    
    if(!pushInfo.micPermission){
        [CXHUD showMsg:pushInfo.toast];
    }
    
    [_memberToolbar reloadMemberAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)aletLeaveMotorcadeMsg:(NSString *)msg{
    [self notifyDelegateWillLeave];
    
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.title = msg;
    } completion:^(NSUInteger buttonIndex) {
        [CXMotorcadeManager quitMotorcadePage];
    }];
}

- (void)motorcadeSocketPushCoordinateNotification:(NSNotification *)notification{
    CXMotorcadeCoordinateResponse *response = notification.userInfo[CXNotificationUserInfoKey0];
    if(![response.carTeamId isEqualToString:self.onlineModel.motorcadeInfo.id]){
        // 丢弃不是当前车队的数据
        return;
    }
    
    if(_coordinateTimestamp > 0 && response.timestamp <= _coordinateTimestamp){
        // 数据晚于上一次的时间，数据丢弃
        return;
    }
    
    _coordinateTimestamp = response.timestamp;
    if(self.onlineModel.motorcadeInfo.roomNo != response.gmeChannelId){
        [self notifyDelegateChangeGMERoomId:response.gmeChannelId];
    }
    
    [self notifyDelegateChangeMemberCoordinates:response];
}

- (void)startPolling{
    if(_pollingTimer || !self.onlineModel){
        return;
    }
    
    CXInvocation *invocation = [CXInvocation invocationWithTarget:self action:@selector(pollingAction)];
    CXTimerConfig *config = [CXTimerConfig configWithInterval:30.0 repeats:YES];
    _pollingTimer = [CXTimer taskTimerWithInvocation:invocation config:config];
}

- (void)stopPolling{
    [self.pollingRequest cancel];
    
    if(_pollingTimer.isValid){
        [_pollingTimer invalidate];
    }
    
    _pollingTimer = nil;
}

- (void)pollingAction{
    CXMotrocadePollingRequest *pollingRequest = [[CXMotrocadePollingRequest alloc] initWithMotorcadeId:self.onlineModel.motorcadeInfo.id];
    [pollingRequest loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        self.pollingRequest = nil;
        if(!model.isValid){
            switch(model.code){
                case 200009:{  // 车机端切换车队
                    LOG_BREAKPOINT(model.msg);
                }
                    return;
                case 200010:   // 车机端退出车队
                case 200011:   // 已被移除车队
                case 200012:   // 车队已解散
                case 200013:{  // 在车机端上线
                    [self aletLeaveMotorcadeMsg:model.msg];
                }
                default:
                    return;
            }
        }
        
        CXMotrocadePollingResultModel *result = ((CXMotrocadePollingModel *)model).result;
        if(self->_coordinateTimestamp > 0 && result.createTime < self->_coordinateTimestamp){
            // 数据过期
            return;
        }
        
        if(self.onlineModel.motorcadeInfo.groupChat == CXMotorcadeRealTimeVoice){
            NSString *motorcadeId = self.onlineModel.motorcadeInfo.id;
            NSTimeInterval remainingTime = result.remainingTime / 1000.0;
            if(remainingTime > 0 && remainingTime < 30.0){
                // 小于30秒，不够下一次轮询
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(remainingTime + 1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 没有切换小队
                    if([self.onlineModel.motorcadeInfo.id isEqualToString:motorcadeId]){
                        [self notifyDelegateReloadGMERoomId];
                    }
                });
            }else{
                if(self.onlineModel.motorcadeInfo.roomNo != result.roomNo){
                    [self notifyDelegateChangeGMERoomId:result.roomNo];
                }
            }
        }
        
        self.onlineModel.ownMicPermission = result.ownMicPermission;
        self.onlineModel.motorcadeInfo.onlineCount = result.onlineCount;
        self.onlineModel.motorcadeInfo.totalCount = result.totalCount;
        self.onlineModel.motorcadeInfo.allMotorcadePermission = result.allMicPermission;
        self.onlineModel.data = result.data;
        
        self->_memberToolbar.allMicDisabled = !result.allMicPermission;
        [self->_memberToolbar reloadMembers];
        [self reloadViewControllerTitle];
        
        [self notifyDelegateChangeMicrophonePermission:result.ownMicPermission];
        [self notifyDelegateReloadMembers:result.data];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        self.pollingRequest = nil;
    }];
    
    self.pollingRequest = pollingRequest;
}

- (void)motorcadeMemberRemovedNotification:(NSNotification *)notification{
    [self reloadMembersRequest];
}

- (void)motorcadeNameChangedNotification:(NSNotification *)notification{
    self.onlineModel.motorcadeInfo.name = notification.userInfo[CXNotificationUserInfoKey0];
    [self reloadViewControllerTitle];
}

- (void)motorcadeDestinationChangedNotification:(NSNotification *)notification{
    self.onlineModel.motorcadeInfo.destination = notification.userInfo[CXNotificationUserInfoKey0];
    [_memberToolbar setDestinationName:self.onlineModel.motorcadeInfo.destModel.destinationName];
    _memberToolbar.destinationViewHidden = ![self.onlineModel shouldShowAddressView];
    [self setUpdateToolbarFrameHeightIfNeed];
    [self notifyDelegateChangeDestination:self.onlineModel.motorcadeInfo.destModel];
    [self reloadViewControllerTitle];
}

- (void)motorcadeMicPermissionChangedNotification:(NSNotification *)notification{
    CXMicPermissionChangeModel *changeModel = (CXMicPermissionChangeModel *)notification.userInfo[CXNotificationUserInfoKey0];
    if(changeModel.changeType == CXMicPermissionChangeAll){
        _memberToolbar.allMicDisabled = !changeModel.micPermission;
        [_memberToolbar reloadMembers];
    }else{
        __block NSUInteger item = 0;
        [self.onlineModel.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([changeModel.userId isEqualToString:obj.userId]){
                obj.micPermission = @(changeModel.micPermission);
                item = idx;
                *stop = YES;
            }
        }];
        
        [_memberToolbar reloadMemberAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    }
}

- (void)quitMotorcade:(NSString *)msg completion:(void (^)(void))completion{
    void (^quitMotorcadePageBlock)(void) = ^{
        [self stopPolling];
        [self sendOfflineRequest];
        !completion ?: completion();
        [CXMotorcadeManager quitMotorcadePage];
    };
    
    if(CXStringIsEmpty(msg)){
        quitMotorcadePageBlock();
    }else{
        [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
            config.title = msg;
            config.buttonTitles = @[@"取消", @"确定"];
        } completion:^(NSUInteger buttonIndex) {
            if(buttonIndex == 1){
                quitMotorcadePageBlock();
            }
        }];
    }
}

- (void)sendOfflineRequest{
    CXMotorcadeOfflineRequest *request = [[CXMotorcadeOfflineRequest alloc] initWithMotorcadeId:self.onlineModel.motorcadeInfo.id];
    [request loadRequestWithSuccess:nil failure:nil];
}

- (void)networkingReachabilityDidChangeNotification:(NSNotification *)notification{
    BOOL reachable = [CXNetworkReachabilityManager isReachable];
    if(_networkState.boolValue == reachable){
        // 例如4G->WiFi，WiFi->4G等
        return;
    }
    
    _networkState = @(reachable);
    if(!reachable){
        return;
    }
    
    [CXHUD showHUD];
    [CXMotorcadeRequestUtils onlineMotorcadeWithId:self.onlineModel.motorcadeInfo.id completion:^(CXMotorcadeOnlineModel *onlineModel, NSError *error) {
        [CXHUD dismiss];
        if(onlineModel.isValid){
            self.onlineModel = onlineModel.result;
            [self->_memberToolbar reloadMembers];
        }else if(onlineModel){
            [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
                config.title = onlineModel.msg;
                config.buttonTitles = @[@"我知道了"];
            } completion:^(NSUInteger buttonIndex) {
                [self notifyDelegateWillLeave];
                [CXMotorcadeManager quitMotorcadePage];
            }];
        }
    }];
}

- (void)motorcadeSettingVCDidQuitOrDissolveMotorcade:(CXMotorcadeSettingVC *)settingVC{
    [self notifyDelegateDissolve];
    [CXMotorcadeManager quitMotorcadePage];
}

- (void)setUpdateToolbarFrameHeightIfNeed{
    CGRect frame = _memberToolbar.frame;
    CGFloat height = 95.0 + (_memberToolbar.isDestinationViewHidden ? 0 : 45.0);
    frame.size.height = height;
    if(_memberToolbar.isClosed){
        frame.origin.y = CGRectGetMaxY(self.viewController.navigationBar.frame) - height;
        _memberToolbar.displayingFrameY = CGRectGetMaxY(self.viewController.navigationBar.frame);
    }
    
    _memberToolbar.frame = frame;
}

- (void)memberToolbarDidGoToNavgationAction:(CXMotorcadeMemberToolbar *)toolbar{
    CLLocationCoordinate2D coordinate = [self.onlineModel.motorcadeInfo.destModel coordinate];
    [self notifyDelegateNavigateToCoordinate:coordinate];
}

- (void)memberToolbarDidSetDestinationAction:(CXMotorcadeMemberToolbar *)toolbar{
    [self notifyDelegateChooseDestination];
}

- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self notifyDelegateSelectMemberAtIndexPath:indexPath];
}

- (void)memberToolbarDidInviteAction:(CXMotorcadeMemberToolbar *)toolbar{
    CXDataRecord(@"app_click_my_motorcade_invite");
    
    CXMotorcadeInvitationVC *invitationVC = [[CXMotorcadeInvitationVC alloc] init];
    [self.viewController.navigationController pushViewController:invitationVC animated:YES];
}

- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar animationFrame:(CGRect)frame forClose:(BOOL)close{
    [self notifyDelegateInfoViewAnimationFrame:frame forClose:close];
    [self reloadViewControllerTitle];
}

- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar didChangeFrameHeight:(CGFloat)frameHeight offsetHeight:(CGFloat)offsetHeight{
    [self notifyDelegateInfoViewChangeFrameHeight:frameHeight offsetHeight:offsetHeight];
}

- (NSInteger)numberOfMembersInMemberToolbar:(CXMotorcadeMemberToolbar *)toolbar{
    return self.onlineModel.data.count;
}

- (CXMotorcadeUserInfoModel *)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar modelForMemberAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item < self.onlineModel.data.count){
        return self.onlineModel.data[indexPath.item];
    }
    
    return nil;
}

- (CGRect)toolbarFrame{
    return _memberToolbar.frame;
}

- (BOOL)toolbarClosed{
    return _memberToolbar.isClosed;
}

- (void)reloadMembers{
    [_memberToolbar reloadMembers];
}

- (void)reloadMemberAtIndexPath:(NSIndexPath *)indexPath{
    [_memberToolbar reloadMemberAtIndexPath:indexPath];
}

- (void)setToolbarClose:(BOOL)close animated:(BOOL)animated{
    [_memberToolbar setClose:close animated:animated];
}

- (void)notifyDelegateChangeOnlineModel:(CXMotorcadeOnlineResultModel *)onlineModel{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeOnlineModel:)]){
        [self.delegate motorcadeServiceManager:self didChangeOnlineModel:onlineModel];
    }
}

- (void)notifyDelegateDissolve{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManagerDidDissolve:)]){
        [self.delegate motorcadeServiceManagerDidDissolve:self];
    }
}

- (void)notifyDelegateWillLeave{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManagerWillLeave:)]){
        [self.delegate motorcadeServiceManagerWillLeave:self];
    }
}

- (void)notifyDelegateChangeGMERoomId:(NSInteger)roomId{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeGMERoomId:)]){
        [self.delegate motorcadeServiceManager:self didChangeGMERoomId:roomId];
    }
}

- (void)notifyDelegateChangeMicrophonePermission:(BOOL)permission{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeMicrophonePermission:)]){
        [self.delegate motorcadeServiceManager:self didChangeMicrophonePermission:permission];
    }
}

- (void)notifyDelegateChangeDestination:(CXMotorcadeDestinationModel *)destinationModel{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeDestination:)]){
        [self.delegate motorcadeServiceManager:self didChangeDestination:destinationModel];
    }
}

- (void)notifyDelegateChangeMemberCoordinates:(CXMotorcadeCoordinateResponse *)response{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeMemberCoordinates:)]){
        [self.delegate motorcadeServiceManager:self didChangeMemberCoordinates:response];
    }
}

- (void)notifyDelegateReloadGMERoomId{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManagerReloadGMERoomId:)]){
        [self.delegate motorcadeServiceManagerReloadGMERoomId:self];
    }
}

- (void)notifyDelegateNavigateToCoordinate:(CLLocationCoordinate2D)coordinate{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:navigateToCoordinate:)]){
        [self.delegate motorcadeServiceManager:self navigateToCoordinate:coordinate];
    }
}

- (void)notifyDelegateChooseDestination{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManagerChooseDestination:)]){
        [self.delegate motorcadeServiceManagerChooseDestination:self];
    }
}

- (void)notifyDelegateSelectMemberAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didSelectMemberAtIndexPath:)]){
        [self.delegate motorcadeServiceManager:self didSelectMemberAtIndexPath:indexPath];
    }
}

- (void)notifyDelegateReloadMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didReloadMembers:)]){
        [self.delegate motorcadeServiceManager:self didReloadMembers:members];
    }
}

- (void)notifyDelegateInfoViewAnimationFrame:(CGRect)frame forClose:(BOOL)close{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:toolbarAnimationFrame:forClose:)]){
        [self.delegate motorcadeServiceManager:self toolbarAnimationFrame:frame forClose:close];
    }
}

- (void)notifyDelegateInfoViewChangeFrameHeight:(CGFloat)frameHeight offsetHeight:(CGFloat)offsetHeight{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeToolbarFrameHeight:offsetHeight:)]){
        [self.delegate motorcadeServiceManager:self didChangeToolbarFrameHeight:frameHeight offsetHeight:offsetHeight];
    }
}

- (void)notifyDelegateChangeMemberState:(CXSocketPushContentType)stateType userId:(NSString *)userId{
    if([self.delegate respondsToSelector:@selector(motorcadeServiceManager:didChangeMemberState:userId:)]){
        [self.delegate motorcadeServiceManager:self didChangeMemberState:stateType userId:userId];
    }
}

@end
