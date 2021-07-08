//
//  CXMotorcadeSettingVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeSettingVC.h"
#import "CXSummonOnlineRequest.h"
#import "CXRoundShadowActionButton.h"
#import "CXMotorcadeOnlineModel.h"
#import "CXUpdateMotorcadeInfoRequest.h"
#import "CXExitMotorcadeRequest.h"
#import "CXDissolveMotorcadeRequest.h"
#import "CXMotorcadeNotificationName.h"
#import "CXMotorcadePOISearchVC.h"
#import "CXMotorcadeRequestUtils.h"
#import "CXMotorcadeUpdateNameVC.h"
#import "CXMotorcadeMemberListVC.h"
#import "CXMotorcadeMicManageVC.h"

#define CX_MOTORCADE_SETTING_ITEM_KEY_NAME          @"name"
#define CX_MOTORCADE_SETTING_ITEM_KEY_DESTINATION   @"destination"

@interface CXMotorcadeSettingVC () {
    CXRoundShadowActionButton *_actionButton;
    CXMotorcadeOnlineInfoModel *_motorcadeModel;
    BOOL _isCaptain;
}

@end

@implementation CXMotorcadeSettingVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_motorcadeinfo";
}

- (instancetype)initWithMotorcadeModel:(CXMotorcadeOnlineInfoModel *)motorcadeModel isCaptain:(BOOL)isCaptain{
    if(self = [super init]){
        _motorcadeModel = motorcadeModel;
        _isCaptain = isCaptain;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小队资料";
    self.view.backgroundColor = CXHexIColor(0xF9F9F9);
    self.navigationBar.hiddenBottomHorizontalLine = YES;
    
    _actionButton = [[CXRoundShadowActionButton alloc] init];
    _actionButton.title = _isCaptain ? @"解散小队" : @"删除小队并退出";
    CGFloat actionButton_X = CX_MARGIN(20.0);
    CGFloat actionButton_W = CGRectGetWidth(self.view.bounds) - actionButton_X * 2;
    CGFloat actionButton_H = 45.0;
    CGFloat actionButton_Y = CGRectGetHeight(self.view.bounds) - actionButton_H - (15.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom);
    _actionButton.frame = CGRectMake(actionButton_X, actionButton_Y, actionButton_W, actionButton_H);
    [_actionButton addTarget:self action:@selector(handleActionForButton:)];
    [self.view addSubview:_actionButton];
    
    CGFloat tableView_X = 0;
    CGFloat tableView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat tableView_W = CGRectGetWidth(self.view.bounds);
    CGFloat tableView_H = actionButton_Y - tableView_Y;
    self.tableView.frame = (CGRect){tableView_X, tableView_Y, tableView_W, tableView_H};
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeNameChangedNotification:)
                                 name:CXMotorcadeNameChangedNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeDestinationChangedNotification:)
                                 name:CXMotorcadeDestinationChangedNotification];
}

- (void)motorcadeNameChangedNotification:(NSNotification *)notification{
    NSString *name = notification.userInfo[CXNotificationUserInfoKey0];
    [self.settingItems enumerateObjectsUsingBlock:^(CXSettingSectionModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [obj1.rows enumerateObjectsUsingBlock:^(CXSettingRowModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if([obj2.rowKey isEqualToString:CX_MOTORCADE_SETTING_ITEM_KEY_NAME]){
                if([obj2 isKindOfClass:[CXSettingRightTextRowModel class]]){
                    CXSettingRightTextRowModel *textModel = (CXSettingRightTextRowModel *)obj2;
                    textModel.rightText = name;
                }
                *stop2 = YES;
                *stop1 = YES;
            }
        }];
    }];
    
    [self.tableView reloadData];
}

- (void)motorcadeDestinationChangedNotification:(NSNotification *)notification{
    NSString *data = notification.userInfo[CXNotificationUserInfoKey0];
    CXMotorcadeDestinationModel *destination = [CXMotorcadeDestinationModel cx_modelWithData:data];
    if(!destination){
        return;
    }
    
    [self.settingItems enumerateObjectsUsingBlock:^(CXSettingSectionModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [obj1.rows enumerateObjectsUsingBlock:^(CXSettingRowModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if([obj2.rowKey isEqualToString:CX_MOTORCADE_SETTING_ITEM_KEY_DESTINATION]){
                if([obj2 isKindOfClass:[CXSettingRightTextRowModel class]]){
                    CXSettingRightTextRowModel *textModel = (CXSettingRightTextRowModel *)obj2;
                    textModel.rightText = destination.destinationName;
                }
                *stop2 = YES;
                *stop1 = YES;
            }
        }];
    }];
    
    [self.tableView reloadData];
}

- (void)loadDataWithCompletion:(CXSettingViewControllerDataBlock)completion{
    CXSettingRightTextRowModel *rowModel0 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"小队口令" actionHandler:nil];
    rowModel0.rightText = _motorcadeModel.command;
    rowModel0.enabled = NO;
    rowModel0.arrowHidden = YES;
    
    CXSettingRightTextRowModel *rowModel1 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"目的地" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"30000094");
        CXMotorcadeSettingVC *settingVC = (CXMotorcadeSettingVC *)context;
        CXMotorcadePOISearchVC *POISearchVC = [[CXMotorcadePOISearchVC alloc] initWithCompletion:^(CXPOISearchViewController *VC, CXMapPOIModel *POIModel, NSInteger POIType) {
            if(POIModel){
                [CXMotorcadeRequestUtils setDestinationWithPOIModel:POIModel motorcadeId:settingVC->_motorcadeModel.id completion:^(NSString *destinationJSONString) {
                    [VC quitSearchViewController];
                }];
            }
        }];
        [settingVC.navigationController pushViewController:POISearchVC animated:YES];
    }];
    rowModel1.rightText = _motorcadeModel.destModel.destinationName ?: @"未设置";
    rowModel1.rowKey = CX_MOTORCADE_SETTING_ITEM_KEY_DESTINATION;
    
    CXSettingRightTextRowModel *rowModel2 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"小队名称" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"30000095");
        CXMotorcadeSettingVC *settingVC = (CXMotorcadeSettingVC *)context;
        CXMotorcadeUpdateNameVC *updateNameVC = [[CXMotorcadeUpdateNameVC alloc] init];
        updateNameVC.motorcadeInfo = settingVC->_motorcadeModel;
        [settingVC.navigationController pushViewController:updateNameVC animated:YES];
    }];
    rowModel2.rightText = _motorcadeModel.name;
    rowModel2.rowKey = CX_MOTORCADE_SETTING_ITEM_KEY_NAME;
    
    CXSettingRightTextRowModel *rowModel3 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"归队邀请" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"30000096");
        [CXHUD showHUD];
        CXMotorcadeSettingVC *settingVC = (CXMotorcadeSettingVC *)context;
        CXSummonOnlineRequest *request = [[CXSummonOnlineRequest alloc] initWithMotorcadeId:settingVC->_motorcadeModel.id];
        [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
            CXBaseModel *model = (CXBaseModel *)data;
            [CXHUD showMsg:model.msg];
        } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
            [CXHUD showMsg:error.HUDMsg];
        }];
    }];
    rowModel3.rightText = @"向所有离线队员发消息";
    
    CXSettingRightTextRowModel *rowModel4 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"移除队员" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"30000097");
        CXMotorcadeSettingVC *settingVC = (CXMotorcadeSettingVC *)context;
        CXMotorcadeMemberListVC *memberListVC = [[CXMotorcadeMemberListVC alloc] init];
        memberListVC.motorcadeId = settingVC->_motorcadeModel.id;
        [settingVC.navigationController pushViewController:memberListVC animated:YES];
    }];
    rowModel4.rightText = @"选择要移除的成员";
    
    CXSettingRightTextRowModel *rowModel5 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"队员麦克风管理" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXMotorcadeSettingVC *settingVC = (CXMotorcadeSettingVC *)context;
        CXMotorcadeMicManageVC *micManageVC = [[CXMotorcadeMicManageVC alloc] init];
        micManageVC.motorcadeId = settingVC->_motorcadeModel.id;
        [settingVC.navigationController pushViewController:micManageVC animated:YES];
    }];
    rowModel5.rightText = @"去设置";
    
    CXSettingRightTextRowModel *rowModel6 = [[CXSettingRightTextRowModel alloc] initWithTitle:@"群聊语音模式"];
    if(_motorcadeModel.groupChat == CXMotorcadeRealTimeVoice){
        rowModel6.rightText = @"实时语音";
    }else{
        rowModel6.rightText = @"手台对讲";
    }
    rowModel6.arrowHidden = YES;
    rowModel6.enabled = NO;
    
    NSArray<CXSettingRowModel *> *group0 = nil;
    NSArray<CXSettingRowModel *> *group1 = nil;
    NSArray<CXSettingRowModel *> *group2 = nil;
    if(_isCaptain){
        if(_motorcadeModel.groupChat == CXMotorcadeRealTimeVoice){
            group0 = @[rowModel0, rowModel1, rowModel2];
            group1 = @[rowModel3, rowModel4];
            group2 = @[rowModel5, rowModel6];
        }else{
            group0 = @[rowModel0, rowModel2];
            group1 = @[rowModel3, rowModel4];
            group2 = @[rowModel6];
        }
    }else{
        rowModel1.enabled = NO;
        rowModel1.arrowHidden = YES;
        rowModel2.enabled = NO;
        rowModel2.arrowHidden = YES;
        if(_motorcadeModel.groupChat == CXMotorcadeRealTimeVoice){
            group0 = @[rowModel0, rowModel1, rowModel2];
            group1 = @[rowModel3];
            group2 = @[rowModel6];
        }else{
            group0 = @[rowModel0, rowModel2];
            group1 = @[rowModel3];
            group2 = @[rowModel6];
        }
    }
    
    CXSettingSectionModel *section0 = [[CXSettingSectionModel alloc] initWithRows:group0
                                                                     footerHeight:8.0
                                                                    footerContent:nil];
    CXSettingSectionModel *section1 = [[CXSettingSectionModel alloc] initWithRows:group1
                                                                     footerHeight:8.0
                                                                    footerContent:nil];
    CXSettingSectionModel *section2 = [[CXSettingSectionModel alloc] initWithRows:group2
                                                                     footerHeight:CGFLOAT_MIN
                                                                    footerContent:nil];
    completion(@[section0, section1, section2]);
}

- (void)handleActionForButton:(CXRoundShadowActionButton *)actionButton{
    if(_isCaptain){
        [self dissolveMotorcadeRequest:_motorcadeModel.id];
    }else{
        [self exitMotorcadeRequest:_motorcadeModel.id];
    }
}

- (void)dissolveMotorcadeRequest:(NSString *)motorcadeId{
    CXDataRecord(@"app_click_my_motorcadeinfo_dissolution");
    
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.title = @"将移除所有成员并删除小队";
        config.buttonTitles = @[@"取消", @"确定"];
    } completion:^(NSUInteger buttonIndex) {
        if(buttonIndex == 1){
            CXDissolveMotorcadeRequest *request = [[CXDissolveMotorcadeRequest alloc] initWithMotorcadeId:motorcadeId];
            [self sendLeaveMotorcadeRequest:request];
        }
    }];
}

- (void)exitMotorcadeRequest:(NSString *)motorcadeId{
    CXDataRecord(@"app_click_my_motorcadeinfo_delete");
    
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.title = @"删除小队后，该小队将不在你的小队列表中，确认是否删除？";
        config.buttonTitles = @[@"取消", @"确定"];
    } completion:^(NSUInteger buttonIndex) {
        if(buttonIndex == 1){
            CXExitMotorcadeRequest *request = [[CXExitMotorcadeRequest alloc] initWithMotorcadeId:motorcadeId];
            [self sendLeaveMotorcadeRequest:request];
        }
    }];
}

- (void)sendLeaveMotorcadeRequest:(CXBaseMotorcadeURLRequest *)request{
    [CXHUD showHUD];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            if([self.delegate respondsToSelector:@selector(motorcadeSettingVCDidQuitOrDissolveMotorcade:)]){
                [self.delegate motorcadeSettingVCDidQuitOrDissolveMotorcade:self];
            }
        }else{
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD showMsg:error.HUDMsg];
    }];
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

@end
