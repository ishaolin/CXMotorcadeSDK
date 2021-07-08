//
//  CXMotorcadeTalkbackVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/10.
//

#import "CXMotorcadeTalkbackVC.h"
#import "CXMotorcadeSchemeDefines.h"
#import "CXMotorcadeServiceManager.h"
#import "CXIMSpeakDragView.h"
#import "CXMotorcadePermission.h"

@interface CXMotorcadeTalkbackVC () <CXMotorcadeServiceManagerDelegate, CXIMSpeakDragViewDelegate> {
    CXMotorcadeServiceManager *_serviceManager;
    CXIMSpeakDragView *_dragView;
    CXIMChangeType _changeType;
}

@end

@implementation CXMotorcadeTalkbackVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_motorcade_speechpattern";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = NO;
    [_serviceManager viewDidLoad];
    
    CGFloat dragView_W = 98.0;
    CGFloat dragView_H = dragView_W;
    CGFloat dragView_X = (CGRectGetMaxX(self.view.frame) - dragView_W) * 0.5;
    CGFloat dragView_Y = CGRectGetMaxY(self.tableView.frame) - dragView_H;
    _dragView.frame = (CGRect){dragView_X, dragView_Y, dragView_W, dragView_H};
    [self.view addSubview:_dragView];
    
    _dragView.edgeInsets = UIEdgeInsetsMake(CGRectGetMaxY(_serviceManager.toolbarFrame), 0, self.chatToolbar.minimumHeight, 0);
    [self.view bringSubviewToFront:self.chatToolbar];
}

- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    [_serviceManager quitMotorcade:nil completion:nil];
}

- (void)IMSpeakDragView:(CXIMSpeakDragView *)dragView didLongPressActionForState:(UIGestureRecognizerState)state{
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            [CXMotorcadePermission checkMicPermission:^(BOOL granted, BOOL first) {
                if(!granted || first){
                    return;
                }
                
                CXIMSpeakAnimationView *animationView = [[CXIMSpeakAnimationView alloc] init];
                [animationView showInViewController:self];
                [self startRecording:nil peakPowerBlock:^(CXAudioRecorder *recorder, CGFloat peakPower) {
                    animationView.speakPower = peakPower;
                } finishedBlock:^(NSString *filePath, NSError *error) {
                    [self->_dragView resetting];
                    [animationView dismissWithAnimated:YES];
                } cancelledBlock:^(CXAudioRecorder *recorder) {
                    [animationView dismissWithAnimated:YES];
                }];
            }];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            [self cancelRecord];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [self stopRecord];
        }
            break;
        default:
            break;
    }
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager toolbarAnimationFrame:(CGRect)frame forClose:(BOOL)close{
    _dragView.edgeInsets = UIEdgeInsetsMake(CGRectGetMaxY(frame), 0, self.chatToolbar.minimumHeight, 0);
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    CGPoint contentOffset = self.tableView.contentOffset;
    if(close){
        contentOffset.y += contentInset.top;
        contentInset.top -= CGRectGetHeight(frame);
    }else{
        contentInset.top += CGRectGetHeight(frame);
        contentOffset.y -= contentInset.top;
    }
    self.tableView.contentInset = contentInset;
    
    if(_changeType == CXIMChangeTypeKeyboardHide){
        [self.tableView reloadData];
        [self.tableView setContentOffset:contentOffset animated:YES];
    }
}

- (void)motorcadeServiceManager:(CXMotorcadeServiceManager *)serviceManager didChangeToolbarFrameHeight:(CGFloat)frameHeight offsetHeight:(CGFloat)offsetHeight{
    UIEdgeInsets contentInset = self.tableView.contentInset;
    CGPoint contentOffset = self.tableView.contentOffset;
    contentInset.top += offsetHeight;
    contentOffset.y -= offsetHeight;
    
    self.tableView.contentInset = contentInset;
    
    if(_changeType == CXIMChangeTypeKeyboardHide){
        [self.tableView reloadData];
        [self.tableView setContentOffset:contentOffset animated:YES];
    }
}

- (void)didChangeChatToolbarFrameOffsetY:(CGFloat)offsetY changeType:(CXIMChangeType)changeType{
    _changeType = changeType;
    
    CGRect dragViewFrame = _dragView.frame;
    dragViewFrame.origin.y = CGRectGetHeight(self.view.frame) - self.chatToolbar.minimumHeight - CGRectGetHeight(dragViewFrame);
    
    [self setTableViewFrameOffsetY:offsetY contentOffsetTop:(_serviceManager.toolbarClosed ? 0 : CGRectGetHeight(_serviceManager.toolbarFrame))];
}

- (BOOL)disableGesturePopInteraction{
    return YES;
}

#pragma mark - Scheme Support Methods

+ (void)registerSchemeSupporter{
    [[CXSchemeRegistrar sharedRegistrar] registerClass:self
                                          businessPage:CXSchemePageTalkbackModeMotorcade
                                                module:CXSchemeBusinessModulePhoenix];
}

- (instancetype)initWithParams:(NSDictionary<NSString *,id> *)params{
    if(self = [super init]){
        CXMotorcadeOnlineResultModel *onlineModel = [params cx_objectForKey:CM_SCHEME_PK_MOTORCADE_DATA];
        _serviceManager = [[CXMotorcadeServiceManager alloc] initWithViewController:self onlineModel:onlineModel];
        _serviceManager.delegate = self;
        _dragView = [[CXIMSpeakDragView alloc] init];
        _dragView.delegate = self;
        [self setChatParamsWithMotorcadeInfo:onlineModel.motorcadeInfo];
    }
    
    return self;
}

- (void)setNeedsUpdateWithParams:(NSDictionary<NSString *,id> *)params{
    CXMotorcadeOnlineResultModel *onlineModel = [params cx_objectForKey:CM_SCHEME_PK_MOTORCADE_DATA];
    if(!onlineModel || (_serviceManager && [_serviceManager.onlineModel.motorcadeInfo.id isEqualToString:onlineModel.motorcadeInfo.id])){
        return;
    }
    
    _serviceManager.onlineModel = onlineModel;
    [self setChatParamsWithMotorcadeInfo:onlineModel.motorcadeInfo];
}

- (void)setChatParamsWithMotorcadeInfo:(CXMotorcadeOnlineInfoModel *)motorcadeInfo{
    CXIMChatParams *params = [[CXIMChatParams alloc] init];
    params.id = motorcadeInfo.id;
    params.name = motorcadeInfo.name;
    params.type = CX_IM_CONVERSATION_GROUP;
    [self setChatParams:params];
}

@end
