//
//  CXMotorcadeMapVC.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeMapVC.h"
#import <CXVoiceSDK/CXVoiceSDK.h>
#import <CXIMSDK/CXIMSDK.h>
#import "CXMotorcadeServiceManager.h"
#import "CXMotorcadeMapToolbar.h"
#import "CXMotorcadeMapVoiceToolbar.h"
#import "CXMotorcadeManager+CXExtensions.h"
#import "CXMotorcadePermission.h"
#import "CXUserMicPermissionRequest.h"
#import "CXMotorcadeMemberAnnotation.h"
#import "CXMotorcadeMemberAnnotationView.h"
#import "CXMotorcadeAnnotationUtils.h"
#import "CXGMERoomNoRequest.h"
#import "CXMotorcadeChatVC.h"
#import "CXMotrocadeMapNaviVC.h"
#import "CXMotorcadePOISearchVC.h"
#import "CXMotorcadeRequestUtils.h"

@interface CXMotorcadeMapVC () <CXMotorcadeMapToolbarDelegate, CXMotorcadeMapVoiceToolbarDelegate, CXIMMessageListener, CXVoiceManagerDelegate, CXMotorcadeServiceManagerDelegate, CXNavigationAnimationSupportor>{
    CXMotorcadeServiceManager *_serviceManager;
    CXMotorcadeMapToolbar *_mapToolbar;
    CXMotorcadeMapVoiceToolbar *_voiceToolbar;
    UIEdgeInsets _contentInset;
    CXMotorcadeUserInfoModel *_selfModel;
    CXMotorcadeMicrophoneState _microphoneState;
    CXPointAnnotation *_destinationAnnotation;
    NSIndexPath *_selectedIndexPath;
    
    TIMConversation *_conversation;
    CXTimer *_locationTimer;
}

@property (nonatomic, weak) CXMotorcadeChatVC *chatVC;
@property (nonatomic, weak) CXMotrocadeMapNaviVC *mapNaviVC;

@end

@implementation CXMotorcadeMapVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_motorcade_handtable";
}

- (void)voiceManager:(CXVoiceManager *)voiceManager didRoomDisconnect:(NSString *)error{
    if([CXNetworkReachabilityManager networkReachabilityStatus] != CXNetworkReachabilityStatusNotReachable){
        [self enterVoiceRoom:_serviceManager.onlineModel.motorcadeInfo.roomNo];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.maxZoomLevel = 17.0;
    [_serviceManager viewDidLoad];
    
    _voiceToolbar = [[CXMotorcadeMapVoiceToolbar alloc] init];
    _voiceToolbar.delegate = self;
    CGFloat voiceToolbar_W = 250.0;
    CGFloat voiceToolbar_X = (CGRectGetWidth(self.view.bounds) - voiceToolbar_W) * 0.5;
    CGFloat voiceToolbar_H = 63.0;
    CGFloat voiceToolbar_Y = CGRectGetHeight(self.view.bounds) - voiceToolbar_H - [UIScreen mainScreen].cx_safeAreaInsets.bottom - 20.0;
    _voiceToolbar.frame = (CGRect){voiceToolbar_X, voiceToolbar_Y, voiceToolbar_W, voiceToolbar_H};
    if(!_serviceManager.onlineModel.ownMicPermission){
        _voiceToolbar.microphoneState = CXMotorcadeMicrophoneStateDisabled;
    }
    [self.view addSubview:_voiceToolbar];
    
    _mapToolbar = [[CXMotorcadeMapToolbar alloc] init];
    _mapToolbar.delegate = self;
    CGFloat mapToolbar_W = 46.0;
    CGFloat mapToolbar_X = 11.0;
    CGFloat mapToolbar_H = 168.0;
    CGFloat mapToolbar_Y = voiceToolbar_Y - mapToolbar_H;
    _mapToolbar.frame = (CGRect){mapToolbar_X, mapToolbar_Y, mapToolbar_W, mapToolbar_H};
    [self.view addSubview:_mapToolbar];
    
    _contentInset = (UIEdgeInsets){CGRectGetHeight(_serviceManager.toolbarFrame) + 80.0, 80.0, 150.0, 80.0};
    self.mainContentInset = _contentInset;
    [self setCenterCoordinate:[CXLocationManager sharedManager].location.coordinate
                    zoomLevel:CXMapViewDefaultZoomLevel
                     animated:YES];
    [self addLocationTimer];
    [CXVoiceManager sharedManager].delegate = self;
}

- (void)addLocationTimer{
    if(_locationTimer || !_serviceManager.onlineModel){
        return;
    }
    
    CXInvocation *invocation = [CXInvocation invocationWithTarget:self action:@selector(locationTimerAction:)];
    CXTimerConfig *config = [CXTimerConfig configWithInterval:10.0 repeats:YES];
    _locationTimer = [CXTimer taskTimerWithInvocation:invocation config:config];
}

- (void)locationTimerAction:(CXTimer *)timer{
    if(_mapToolbar.isFollowSelfLocation){
        [self setCenterCoordinate:[CXLocationManager sharedManager].location.coordinate
                        zoomLevel:CXMapViewDefaultZoomLevel
                         animated:YES];
    }else{
        [self showAllAnnotationsAnimated:YES];
    }
}

- (void)removeLocationTimer{
    if(_locationTimer.isValid){
        [_locationTimer invalidate];
    }
    
    _locationTimer = nil;
}

- (void)reloadGMERoom:(BOOL)showHUD{
    if(showHUD){
        [CXHUD showHUD];
    }
    
    [[[CXGMERoomNoRequest alloc] init] loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data){
        if(showHUD){
            [CXHUD dismiss];
        }
        
        CXGMERoomNoModel *model = (CXGMERoomNoModel *)data;
        if(model.isValid){
            self->_serviceManager.onlineModel.motorcadeInfo.roomNo = model.result.roomNo;
            [self enterVoiceRoom:model.result.roomNo];
        }else{
            [self reloadGMERoomFaild];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error){
        if(showHUD){
            [CXHUD dismiss];
        }
        
        [self reloadGMERoomFaild];
    }];
}

- (void)reloadGMERoomFaild{
    [[CXVoiceManager sharedManager] exitActiveRoom];
    
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config){
        config.title = @"语音通话连接失败";
        config.buttonTitles = @[@"退出", @"重试"];
    } completion:^(NSUInteger buttonIndex){
        if(buttonIndex == 0){
            [self->_serviceManager sendOfflineRequest];
            [CXMotorcadeManager quitMotorcadePage];
        }else{
            [self reloadGMERoom:YES];
        }
    }];
}

- (void)didBecomeActiveNotification:(NSNotification *)notification{
    [super didBecomeActiveNotification:notification];
    
    [_serviceManager pollingAction];
}

- (void)receiveHistory:(NSArray<TIMMessage*> *)msgs{
    [msgs enumerateObjectsUsingBlock:^(TIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        if([obj isReaded] || !obj.supportive){
            return;
        }
        self->_voiceToolbar.hasNewMsg = YES;
        *stop = YES;
    }];
}

- (void)onNewMessage:(NSArray<TIMMessage *> *)messages{
    if(!_conversation || self.chatVC){
        return;
    }
    
    [messages enumerateObjectsUsingBlock:^(TIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        if([[[obj getConversation] getReceiver] isEqualToString:[self->_conversation getReceiver]] && obj.supportive){
            self->_voiceToolbar.hasNewMsg = YES;
            *stop = YES;
        }
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForPointAnnotation:(CXPointAnnotation *)annotation{
    if(![annotation isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
        return [super mapView:mapView viewForPointAnnotation:annotation];
    }
    
    static NSString *identifier = @"CXMotorcadeMemberAnnotation";
    CXMotorcadeMemberAnnotation *memberAnnotation = (CXMotorcadeMemberAnnotation *)annotation;
    CXMotorcadeMemberAnnotationView *annotationView = (CXMotorcadeMemberAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(!annotationView){
        annotationView = [[CXMotorcadeMemberAnnotationView alloc] initWithAnnotation:memberAnnotation reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = memberAnnotation.customCalloutView != nil;
    annotationView.customCalloutView = memberAnnotation.customCalloutView;
    annotationView.enabled = YES;
    annotationView.draggable = NO;
    annotationView.zIndex = memberAnnotation.zIndex;
    annotationView.coorOffset = memberAnnotation.coorOffset;
    annotationView.calloutOffset = memberAnnotation.calloutOffset;
    annotationView.image = memberAnnotation.image;
    annotationView.memberInfoModel = memberAnnotation.memberInfoModel;
    
    return annotationView;
}

- (CXUserLocationView *)mapView:(MAMapView *)mapView viewForUserLocation:(MAUserLocation *)userLocation{
    CXUserLocationView *userLocationView = [super mapView:mapView viewForUserLocation:userLocation];
    userLocationView.rotateEnabled = NO;
    userLocationView.enableCenterOffset = YES;
    userLocationView.coorOffset = CGPointMake(0, 7.0);
    userLocationView.calloutOffset = CGPointMake(0, -6.0);
    userLocationView.zIndex = 10;
    
    [userLocationView setImageWithURL:_selfModel.headUrl completion:^UIImage * _Nonnull(CXBubbleAnnotationView * _Nonnull annotationView, UIImage * _Nonnull image){
        return [CXMotorcadeMemberAnnotation annotationImageWithSex:self->_selfModel.sex avatar:image];
    }];
    
    return userLocationView;
}

- (void)didUpdateUserLocation:(MAUserLocation *)userLocation{
    CXMotorcadeMemberAnnotationBubbleView *bubbleView = (CXMotorcadeMemberAnnotationBubbleView *)self.userLocationView.bubbleView;
    if(!bubbleView){
        bubbleView = [[CXMotorcadeMemberAnnotationBubbleView alloc] init];
        self.userLocationView.bubbleView = bubbleView;
    }
    
    [bubbleView setMemberInfoModel:_selfModel];
}

- (void)mapViewWillMoveByUser:(BOOL)wasUserAction{
    if(wasUserAction){
        [_locationTimer pause];
    }
}

- (void)mapViewDidMoveByUser:(BOOL)wasUserAction{
    if(wasUserAction){
        [_locationTimer resume];
    }
}

- (void)mapViewWillZoomByUser:(BOOL)wasUserAction{
    if(wasUserAction){
        [_locationTimer pause];
    }
}

- (void)mapViewDidZoomByUser:(BOOL)wasUserAction{
    if(wasUserAction){
        [_locationTimer resume];
    }
}

- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    CXDataRecord(@"30000098");
    
    [_serviceManager quitMotorcade:@"离线后将不再接受队内消息，确认是否离线" completion:^{
        [[CXVoiceManager sharedManager] exitActiveRoom];
    }];
}

- (void)motorcadeMapToolbarDidSelfLocationAction:(CXMotorcadeMapToolbar *)toolbar{
    [self setCenterCoordinate:[CXLocationManager sharedManager].location.coordinate
                    zoomLevel:CXMapViewDefaultZoomLevel
                     animated:YES];
}

- (void)motorcadeMapToolbarDidGlobalLocationAction:(CXMotorcadeMapToolbar *)toolbar{
    CXDataRecord(@"30000079");
    
    [self showAllAnnotationsAnimated:YES];
}

- (void)motorcadeMapToolbar:(CXMotorcadeMapToolbar *)toolbar didActionWithShowTraffic:(BOOL)showTraffic{
    self.showTraffic = showTraffic;
}

#pragma mark - 开关自己的麦克

- (void)motorcadeMapVoiceToolbar:(CXMotorcadeMapVoiceToolbar *)voiceToolbar didChangeSpeakerState:(BOOL)speakerEnabled{
    CXDataRecord(@"30000080");
    
    [CXVoiceManager sharedManager].speakerEnabled = speakerEnabled;
}

- (void)motorcadeMapVoiceToolbar:(CXMotorcadeMapVoiceToolbar *)voiceToolbar didChangeMicrophoneState:(CXMotorcadeMicrophoneState)microphoneState{
    [CXMotorcadePermission checkMicPermission:^(BOOL granted, BOOL first) {
        CXDataRecord(@"30000081");
        if(!granted){
            return;
        }
        
        if(microphoneState == CXMotorcadeMicrophoneStateOff){ // 关麦
            self->_microphoneState = microphoneState;
            voiceToolbar.microphoneState = self->_microphoneState;
            [[CXVoiceManager sharedManager] pauseMicrophone];
            return;
        }
        
        [CXHUD showHUD];
        CXUserMicPermissionRequest *request = [[CXUserMicPermissionRequest alloc] initWithMotorcadeId:self->_serviceManager.onlineModel.motorcadeInfo.id];
        [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data){
            CXUserMicPermissionModel *model = (CXUserMicPermissionModel *)data;
            if(model.isValid){
                if(model.result.permission){
                    [CXHUD dismiss];
                    self->_microphoneState = CXMotorcadeMicrophoneStateOn;
                    voiceToolbar.microphoneState = self->_microphoneState;
                    [[CXVoiceManager sharedManager] resumeMicrophone];
                }else{
                    [CXHUD showMsg:model.result.msg];
                }
            }else{
                [CXHUD showMsg:model.msg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error){
            [CXHUD showMsg:error.HUDMsg];
        }];
    }];
}

- (void)motorcadeMapVoiceToolbarDidEnterGroupChatPageAction:(CXMotorcadeMapVoiceToolbar *)voiceToolbar{
    CXDataRecord(@"30000105");
    CXMotorcadeChatVC *chatVC = [[CXMotorcadeChatVC alloc] init];
    CXIMChatParams *params = [[CXIMChatParams alloc] init];
    params.id = _serviceManager.onlineModel.motorcadeInfo.imMotorcadeId;
    params.name = _serviceManager.onlineModel.motorcadeInfo.name;
    params.type = CX_IM_CONVERSATION_GROUP;
    [chatVC setChatParams:params];
    self.chatVC = chatVC;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - 点击地图空白区域

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [_serviceManager setToolbarClose:!_serviceManager.toolbarClosed animated:YES];
    
    _contentInset.top = 80.0;
    if(_serviceManager.toolbarClosed){
        _contentInset.top += CGRectGetHeight(_serviceManager.toolbarFrame);
    }
    
    self.mainContentInset = _contentInset;
    if(_mapToolbar.isFollowSelfLocation){
        [self setCenterCoordinate:[CXLocationManager sharedManager].location.coordinate
                        zoomLevel:CXMapViewDefaultZoomLevel
                         animated:YES];
    }else{
        [self showAllAnnotationsAnimated:YES];
    }
}

#pragma mark - 点击大头针

- (void)didSelectedAnnotation:(CXPointAnnotation *)annotation{
    CXDataRecord(@"30000078");
    
    if([annotation isKindOfClass:[MAUserLocation class]]){
        [self setSelectMember:_selfModel annotation:nil];
    }else if([annotation isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
        CXMotorcadeMemberAnnotation *memberAnnotation  = (CXMotorcadeMemberAnnotation *)annotation;
        [self setSelectMember:memberAnnotation.memberInfoModel annotation:memberAnnotation];
    }
}

#pragma mark - Scheme Support Methods

+ (void)registerSchemeSupporter{
    [[CXSchemeRegistrar sharedRegistrar] registerClass:self
                                          businessPage:CXSchemePageMotorcadeMain
                                                module:CXSchemeBusinessModulePhoenix];
}

- (instancetype)initWithParams:(NSDictionary<NSString *,id> *)params{
    if(self = [super init]){
        _serviceManager = [[CXMotorcadeServiceManager alloc] initWithViewController:self onlineModel:[params cx_objectForKey:CM_SCHEME_PK_MOTORCADE_DATA]];
        _serviceManager.delegate = self;
        
        _selfModel = [[CXMotorcadeUserInfoModel alloc] init];
        _selfModel.userId = [CXMotorcadeManager sharedManager].userInfo.userId;
        _selfModel.name = [CXMotorcadeManager sharedManager].userInfo.name;
        _selfModel.headUrl = [CXMotorcadeManager sharedManager].userInfo.headImgUrl;
        _selfModel.sex = @([CXMotorcadeManager sharedManager].userInfo.sex);
        
        [self handleOnlineModelChange:_serviceManager.onlineModel];
    }
    
    return self;
}

- (void)setNeedsUpdateWithParams:(NSDictionary<NSString *,id> *)params{
    CXMotorcadeOnlineResultModel *onlineModel = [params cx_objectForKey:CM_SCHEME_PK_MOTORCADE_DATA];
    if(!onlineModel || (_serviceManager && [_serviceManager.onlineModel.motorcadeInfo.id isEqualToString:onlineModel.motorcadeInfo.id])){
        return;
    }
    
    _serviceManager.onlineModel = onlineModel;
}

- (void)handleOnlineModelChange:(CXMotorcadeOnlineResultModel *)onlineModel{
    _conversation = [[CXIMManager sharedManager] conversationWithIdentifier:onlineModel.motorcadeInfo.imMotorcadeId type:TIM_GROUP];
    [self removeAnnotations:self.annotations];
    [self updateMembersAnnotion:onlineModel.data];
    
    _microphoneState = CXMotorcadeMicrophoneStateOff;
    _voiceToolbar.microphoneState = _microphoneState;
    
    [self enterVoiceRoom:onlineModel.motorcadeInfo.roomNo];
    if([onlineModel isCaptain]){
        _selfModel.type = @(CXMotorcadeMemberCaptain);
    }else{
        _selfModel.type = @(CXMotorcadeMemberNormal);
    }
    
    [_conversation historyMessage:50 last:nil success:^(NSArray<TIMMessage *> * _Nullable messages) {
        [self receiveHistory:messages];
    } failure:nil];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeOnlineModel:(CXMotorcadeOnlineResultModel *)onlineModel{
    [self handleOnlineModelChange:onlineModel];
}

- (void)motorcadeServiceManagerDidDissolve:(CXMotorcadeServiceManager *)serviceManager{
    [self exitRoom];
    [NSNotificationCenter removeObserver:self];
}

- (void)motorcadeServiceManagerWillLeave:(CXMotorcadeServiceManager *)serviceManager{
    [self exitRoom];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeGMERoomId:(NSInteger)roomId{
    [self enterVoiceRoom:roomId];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeMicrophonePermission:(BOOL)permission{
    if(permission){
        _voiceToolbar.microphoneState = _microphoneState;
        if(_microphoneState == CXMotorcadeMicrophoneStateOn){
            [[CXVoiceManager sharedManager] resumeMicrophone];
        }else{
            [[CXVoiceManager sharedManager] pauseMicrophone];
        }
    }else{
        _voiceToolbar.microphoneState = CXMotorcadeMicrophoneStateDisabled;
        [[CXVoiceManager sharedManager] pauseMicrophone];
    }
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeDestination:(CXMotorcadeDestinationModel *)destinationModel{
    CLLocationCoordinate2D coordinate = [destinationModel coordinate];
    if(_destinationAnnotation){
        _destinationAnnotation.coordinate = coordinate;
    }else{
        _destinationAnnotation = [[CXPointAnnotation alloc] initWithCoordinate:coordinate image:CX_MOTORCADE_IMAGE(@"motorcade_annotation_end")];
    }
    
    [self addAnnotation:_destinationAnnotation];
    [self showAllAnnotationsAnimated:YES];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeMemberCoordinates:(CXMotorcadeCoordinateResponse *)response{
    [response.members enumerateObjectsUsingBlock:^(CXMotorcadeCoordinateMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isSelf]){
            return;
        }
        
        CXMotorcadeCoordinate *coordinate = obj.coordinates.lastObject;
        if(coordinate){
            [self updateAnnotationCoordinate:[coordinate coordinate] forUserId:obj.userId];
        }
    }];
}

- (void)motorcadeServiceManagerReloadGMERoomId:(CXMotorcadeServiceManager *)serviceManager{
    [self reloadGMERoom:NO];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager navigateToCoordinate:(CLLocationCoordinate2D)coordinate{
    CXDataRecord(@"app_click_my_motorcade_navigation");
    
    if(CXLocationCoordinate2DIsValid(coordinate)){
        CXMotrocadeMapNaviVC *napNavigationVC = [[CXMotrocadeMapNaviVC alloc] initWithEndCoordinate:coordinate];
        napNavigationVC.quitCompletion = ^(CXMapNaviViewController *naviVC, CXMapRoutePreference *preference) {
            [self->_serviceManager pollingAction];
            self->_voiceToolbar.speakerEnabled = [CXVoiceManager sharedManager].isSpeakerEnabled;
        };
        
        napNavigationVC.onlineModel = _serviceManager.onlineModel;
        [self.navigationController pushViewController:napNavigationVC animated:YES];
        self.mapNaviVC = napNavigationVC;
    }else{
        [CXHUD showMsg:@"目的地坐标无效"];
    }
}

- (void)motorcadeServiceManagerChooseDestination:(CXMotorcadeServiceManager *)serviceManager{
    CXDataRecord(@"app_click_my_motorcade_search");
    CXMotorcadePOISearchVC *POISearchVC = [[CXMotorcadePOISearchVC alloc] initWithCompletion:^(CXPOISearchViewController *VC, CXMapPOIModel *POIModel, NSInteger POIType) {
        if(POIModel){
            [CXMotorcadeRequestUtils setDestinationWithPOIModel:POIModel motorcadeId:self->_serviceManager.onlineModel.motorcadeInfo.id completion:^(NSString *destinationJSONString) {
                [VC quitSearchViewController];
            }];
        }
    }];
    
    [self.navigationController pushViewController:POISearchVC animated:YES];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didSelectMemberAtIndexPath:(NSIndexPath *)indexPath{
    CXDataRecord(@"30000077");
    
    if(indexPath.item >= _serviceManager.onlineModel.data.count){
        return;
    }
    
    __block CXMotorcadeUserInfoModel *memberInfoModel = _serviceManager.onlineModel.data[indexPath.item];
    if(memberInfoModel.onLineStatus == CXMotorcadeOnlineStateOffline){
        return;
    }
    
    if(memberInfoModel.selected){
        return;
    }
    
    [_serviceManager.onlineModel.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        if(idx == indexPath.item){
            obj.selected = @(YES);
            memberInfoModel = obj;
        }else{
            obj.selected = @(NO);
        }
    }];
    
    if(memberInfoModel){
        _selectedIndexPath = indexPath;
        if([memberInfoModel isSelf]){
            [self.mapView selectAnnotation:self.userLocation animated:YES];
        }else{
            CXMotorcadeMemberAnnotation *annotation = [CXMotorcadeAnnotationUtils memberAnnotationById:memberInfoModel.userId annotations:self.annotations];
            if(annotation){
                [self selectAnnotation:annotation animated:YES];
            }else{
                memberInfoModel.selected = @(NO);
                _selectedIndexPath = nil;
            }
        }
    }
    
    [_serviceManager reloadMembers];
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didReloadMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members{
    [self.mapNaviVC reloadMembers:(id)members];
    [self updateMembersAnnotion:members];
}

- (void)updateMembersAnnotion:(NSArray<CXMotorcadeUserInfoModel *> *)members{
    @autoreleasepool {
        NSMutableArray<CXMotorcadeMemberAnnotation *> *removeAnnotations = [NSMutableArray array];
        [self.annotations enumerateObjectsUsingBlock:^(CXPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![obj isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
                return;
            }
            
            CXMotorcadeMemberAnnotation *annotation = (CXMotorcadeMemberAnnotation *)obj;
            if([annotation.memberInfoModel isSelf] || [CXMotorcadeAnnotationUtils annotation:annotation inMemberList:members belongMember:nil]){
                return;
            }
            
            [removeAnnotations addObject:annotation];
        }];
        
        [removeAnnotations enumerateObjectsUsingBlock:^(CXMotorcadeMemberAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeAnnotation:obj];
        }];
        
        [members enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop){
            if([obj isSelf] || obj.onLineStatus == CXMotorcadeOnlineStateOffline){
                return ;
            }
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(obj.lat, obj.lng);
            if(CXLocationCoordinate2DIsValid(coordinate)){
                [self addOrUpdateMemberAnnotion:obj];
            }
        }];
    }
}

- (void)addOrUpdateMemberAnnotion:(CXMotorcadeUserInfoModel *)userInfo{
    if(!userInfo || [userInfo isSelf]){
        return;
    }
    
    CXMotorcadeMemberAnnotation *annotation = [CXMotorcadeAnnotationUtils memberAnnotationById:userInfo.userId annotations:self.annotations];
    if(annotation){
        CXMotorcadeMemberAnnotationView *annotationView = (CXMotorcadeMemberAnnotationView *)[self.mapView viewForAnnotation:annotation];
        if([annotationView isKindOfClass:[CXMotorcadeMemberAnnotationView class]]){
            userInfo.distance = annotationView.memberInfoModel.distance;
            userInfo.memberDistance = annotationView.memberInfoModel.memberDistance;
            annotationView.memberInfoModel = userInfo;
        }
        
        CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(userInfo.lat, userInfo.lng);
        if(!CXLocationCoordinate2DIsValid(coordinate)){
            return;
        }
        
        if(_serviceManager.onlineModel.motorcadeInfo.onlineCount > 20){
            [annotation addMoveAnimationWithKeyCoordinates:&coordinate
                                                     count:1
                                              withDuration:2.0
                                                  withName:nil
                                          completeCallback:nil];
        }else{
            annotation.coordinate = coordinate;
        }
    }else{
        annotation = [[CXMotorcadeMemberAnnotation alloc] initWithMemberInfoModel:userInfo];
        if(CXLocationCoordinate2DIsValid(annotation.coordinate)){
            [self addAnnotation:annotation];
        }
    }
}

- (void)updateAnnotationCoordinate:(CLLocationCoordinate2D)coordinate forUserId:(NSString *)userId{
    if(CXStringIsEmpty(userId) || !CXLocationCoordinate2DIsValid(coordinate)){
        return;
    }
    
    [self.annotations enumerateObjectsUsingBlock:^(CXPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
            return;
        }
        
        CXMotorcadeMemberAnnotation *annotation = (CXMotorcadeMemberAnnotation *)obj;
        if([annotation.memberInfoModel.userId isEqualToString:userId]){
            CLLocationCoordinate2D coor = coordinate;
            [annotation addMoveAnimationWithKeyCoordinates:&coor
                                                     count:1
                                              withDuration:2.0
                                                  withName:nil
                                          completeCallback:nil];
        }
    }];
}

- (void)enterVoiceRoom:(NSInteger)roomId{
    [[CXVoiceManager sharedManager] enterRoom:roomId completion:^(CXVoiceManager * _Nonnull voiceManager, BOOL success, NSString * _Nullable error){
        if(self->_serviceManager.onlineModel.ownMicPermission){
            self->_voiceToolbar.microphoneState = CXMotorcadeMicrophoneStateOff;
        }else{
            self->_voiceToolbar.microphoneState = CXMotorcadeMicrophoneStateDisabled;
        }
        
        [voiceManager pauseMicrophone];
        voiceManager.speakerEnabled = self->_voiceToolbar.isSpeakerEnabled;
    }];
}

- (CXNavigationAnimationType)navigationAnimationType{
    return CXNavigationAnimationPresent;
}

- (MAUserLocationRepresentation *)userLocationRepresentation{
    MAUserLocationRepresentation *representation = [[MAUserLocationRepresentation alloc] init];
    representation.showsAccuracyRing = NO;
    return representation;
}

- (void)setSelectMember:(CXMotorcadeUserInfoModel *)member annotation:(CXMotorcadeMemberAnnotation *)annotation{
    if(!member){
        return;
    }
    
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(member.lat, member.lng);
    CLLocationCoordinate2D coordinate2 = [_serviceManager.onlineModel.motorcadeInfo.destModel coordinate];
    CXMotorcadeMemberAnnotationBubbleView *bubbleView = nil;
    if([member isSelf]){
        coordinate1 = self.userLocation.location.coordinate;
        if(CXLocationCoordinate2DIsValid(coordinate2)){
            // 我与目的地的距离
            CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
            member.distance = [self.userLocation.location distanceFromLocation:location];
        }
        
        bubbleView = (CXMotorcadeMemberAnnotationBubbleView *)self.userLocationView.bubbleView;
    }else{
        CLLocation *location1 = nil;
        if(CXLocationCoordinate2DIsValid(coordinate1) &&
           CXLocationCoordinate2DIsValid(self.userLocation.location.coordinate)){
            // 某人与我距离
            location1 = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
            member.memberDistance = [location1 distanceFromLocation:self.userLocation.location];
        }
        
        if(CXLocationCoordinate2DIsValid(coordinate2) && CXLocationCoordinate2DIsValid(coordinate1)){
            // 某人与目的地的距离
            if(!location1){
                location1 = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
            }
            CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
            member.distance = [location1 distanceFromLocation:location2];
        }
        
        if(annotation){
            CXMotorcadeMemberAnnotationView *annotationView = (CXMotorcadeMemberAnnotationView *)[self.mapView viewForAnnotation:annotation];
            bubbleView = (CXMotorcadeMemberAnnotationBubbleView *)annotationView.bubbleView;
        }
    }
    
    [bubbleView setMemberInfoModel:member];
    
    if(CXLocationCoordinate2DIsValid(coordinate1)){
        [self setCenterCoordinate:coordinate1 zoomLevel:CXMapViewDefaultZoomLevel animated:YES];
    }
    
    [_locationTimer pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        member.selected = @(NO);
        member.distance = 0;
        member.memberDistance = 0;
        [bubbleView setMemberInfoModel:member];
        
        if([member isSelf]){
            CXMotorcadeUserInfoModel *userInfo = self->_serviceManager.onlineModel.data.firstObject;
            userInfo.selected = @(NO);
            self->_selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        }
        
        [self->_serviceManager reloadMemberAtIndexPath:self->_selectedIndexPath];
        self->_selectedIndexPath = nil;
        [self->_locationTimer resume];
    });
}

- (UIImage *)backBarButtonImage{
    return CX_MOTORCADE_IMAGE(@"motorcade_page_quit");
}

- (void)exitRoom{
    [[CXVoiceManager sharedManager] exitActiveRoom];
    [_serviceManager stopPolling];
}

- (void)dealloc{
    [CXMotorcadeManager removeMotorcadeId:_serviceManager.onlineModel.motorcadeInfo.id];
    [[CXVoiceManager sharedManager] exitRoom:_serviceManager.onlineModel.motorcadeInfo.roomNo completion:nil];
    [self removeLocationTimer];
    [_serviceManager stopPolling];
    [NSNotificationCenter removeObserver:self];
}

@end
