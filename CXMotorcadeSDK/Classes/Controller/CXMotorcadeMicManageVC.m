//
//  CXMotorcadeMicManageVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeMicManageVC.h"
#import "CXMotorcadeMicListRequest.h"
#import "CXMotorcadeMicManageAllCell.h"
#import "CXMotorcadeMicManageMemberCell.h"
#import "CXMotorcadeNotificationName.h"
#import "CXMicPermissionChangeModel.h"
#import "CXMotorcadeMicSectionHeaderView.h"

@interface CXMotorcadeMicManageVC () <CXPageErrorViewDelegate> {
    CXPageErrorView *_errorView;
    UILabel *_emptyLabel;
    BOOL _allMemberMicDisabled;
}

@end

@implementation CXMotorcadeMicManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"队员麦克风管理";
    self.view.backgroundColor = CXHexIColor(0xF9F9F9);
}

- (void)showPageErrorViewWithError:(NSError *)error{
    if(!_errorView){
        _errorView = [[CXPageErrorView alloc] init];
        _errorView.delegate = self;
        CGFloat errorView_X = 0;
        CGFloat errorView_Y = CGRectGetMaxY(self.navigationBar.frame);
        CGFloat errorView_W = CGRectGetWidth(self.view.bounds);
        CGFloat errorView_H = CGRectGetHeight(self.view.bounds) - errorView_Y;
        _errorView.frame = (CGRect){errorView_X, errorView_Y, errorView_W, errorView_H};
        [self.view insertSubview:_errorView belowSubview:self.tableView];
    }
    
    if(error){
        [_errorView showWithError:error];
    }else{
        [_errorView showWithErrorCode:CXPageErrorCodeInternetUnavailable];
    }
    
    self.tableView.hidden = YES;
}

- (void)hidePageErrorView{
    _errorView.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)loadDataWithCompletion:(CXSettingViewControllerDataBlock)completion{
    [CXHUD showHUD];
    CXMotorcadeMicListRequest *request = [[CXMotorcadeMicListRequest alloc] initWithMotorcadeId:self.motorcadeId];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        [CXHUD dismiss];
        CXMotorcadeMicListModel *model = (CXMotorcadeMicListModel *)data;
        if(model.isValid){
            [self convertMicListModel:model.result completion:completion];
            [self hidePageErrorView];
        }else{
            [self showPageErrorViewWithError:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD dismiss];
        [self showPageErrorViewWithError:error];
    }];
}

- (void)convertMicListModel:(CXMotorcadeMicListResultModel *)micListModel
                 completion:(CXSettingViewControllerDataBlock)completion{
    _allMemberMicDisabled = !micListModel.allMicPermission;
    
    CXSettingRightSwitchRowModel *rowModel1 = [[CXSettingRightSwitchRowModel alloc] init];
    rowModel1.title = @"禁止所有人说话";
    rowModel1.on = _allMemberMicDisabled;
    rowModel1.height = 54.0;
    rowModel1.arrowHidden = YES;
    rowModel1.switchActionHandler = ^(CXSettingRightSwitchRowModel *switchRowModel, BOOL isOn, id context) {
        CXMotorcadeMicManageVC *micManageVC = (CXMotorcadeMicManageVC *)context;
        micManageVC->_allMemberMicDisabled = isOn;
        [micManageVC tableViewReloadData];
        
        CXMicPermissionChangeModel *micChangeModel = [[CXMicPermissionChangeModel alloc] init];
        micChangeModel.changeType = CXMicPermissionChangeAll;
        micChangeModel.micPermission = isOn;
        [NSNotificationCenter notify:CXMotorcadeMicPermissionChangedNotification
                            userInfo:@{CXNotificationUserInfoKey0 : micChangeModel}];
    };
    CXSettingSectionModel *sectionModel1 = [[CXSettingSectionModel alloc] initWithRows:@[rowModel1] footerHeight:CGFLOAT_MIN footerContent:nil];
    
    NSMutableArray<CXSettingRowModel *> *rowModels = [NSMutableArray array];
    [micListModel.userInfoList enumerateObjectsUsingBlock:^(CXMotorcadeMicUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXSettingRightSwitchRowModel *rowModel = [[CXSettingRightSwitchRowModel alloc] init];
        rowModel.imageURL = obj.headUrl;
        rowModel.title = obj.name;
        rowModel.userInfo = obj;
        rowModel.on = obj.micPermission;
        rowModel.height = 69.0;
        rowModel.arrowHidden = YES;
        rowModel.switchActionHandler = ^(CXSettingRightSwitchRowModel *switchRowModel, BOOL isOn, id context) {
            CXMotorcadeMicUserInfoModel *infoModel = (CXMotorcadeMicUserInfoModel *)switchRowModel.userInfo;
            CXMicPermissionChangeModel *micChangeModel = [[CXMicPermissionChangeModel alloc] init];
            micChangeModel.changeType = CXMicPermissionChangeMember;
            micChangeModel.micPermission = isOn;
            micChangeModel.userId = infoModel.userId;
            [NSNotificationCenter notify:CXMotorcadeMicPermissionChangedNotification
                                userInfo:@{CXNotificationUserInfoKey0 : micChangeModel}];
        };
        [rowModels addObject:rowModel];
    }];
    
    if(CXArrayIsEmpty(rowModels)){
        completion(@[sectionModel1]);
    }else{
        CXSettingSectionModel *sectionModel2 = [[CXSettingSectionModel alloc] initWithRows:[rowModels copy] footerHeight:CGFLOAT_MIN footerContent:nil];
        completion(@[sectionModel1, sectionModel2]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXSettingSectionModel *sectionModel = self.settingItems[indexPath.section];
    CXSettingRowModel *rowModel = sectionModel.rows[indexPath.row];
    if(indexPath.section == 0){
        CXMotorcadeMicManageAllCell *cell = [CXMotorcadeMicManageAllCell cellWithTableView:tableView];
        cell.motorcadeId = self.motorcadeId;
        cell.rowModel = rowModel;
        return cell;
    }
    
    CXMotorcadeMicManageMemberCell *cell = [CXMotorcadeMicManageMemberCell cellWithTableView:tableView];
    cell.motorcadeId = self.motorcadeId;
    cell.allMemberMicDisabled = _allMemberMicDisabled;
    cell.rowModel = rowModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return [CXMotorcadeMicSectionHeaderView viewWithTableView:tableView];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 46.0 : CGFLOAT_MIN;
}

- (void)tableViewReloadData{
    if(self.settingItems.count == 1){
        if(!_emptyLabel){
            CGFloat emptyLabel_W = CGRectGetWidth(self.tableView.bounds);
            CGFloat emptyLabel_H = 20.0;
            CGFloat emptyLabel_X = 0;
            CGFloat emptyLabel_Y = 180.0;
            
            _emptyLabel = [[UILabel alloc] init];
            _emptyLabel.text = @"暂无队员";
            _emptyLabel.textColor = CXHexIColor(0x9099A1);
            _emptyLabel.font = CX_PingFangSC_RegularFont(14.0);
            _emptyLabel.frame = (CGRect){emptyLabel_X, emptyLabel_Y, emptyLabel_W, emptyLabel_H};
            _emptyLabel.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:_emptyLabel];
        }
        
        _emptyLabel.hidden = NO;
    }else{
        _emptyLabel.hidden = YES;
    }
    
    [super tableViewReloadData];
}

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView{
    [self reloadData];
}

@end
