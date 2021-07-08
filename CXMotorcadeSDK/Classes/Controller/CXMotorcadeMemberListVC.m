//
//  CXMotorcadeMemberListVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeMemberListVC.h"
#import "CXMotorcadeMemberManageCell.h"
#import "CXMotorcadeUserListRequest.h"
#import "CXMotorcadeKickOutRequest.h"

@interface CXMotorcadeMemberListVC () <UITableViewDelegate, UITableViewDataSource, CXPageErrorViewDelegate> {
    CXPageErrorView *_errorView;
    CXTableView *_tableView;
    UILabel *_emptyLabel;
    NSMutableArray<CXMotorcadeUserInfoModel *> *_userModels;
    NSMutableArray<CXMotorcadeUserInfoModel *> *_selectedUserModels;
}

@end

@implementation CXMotorcadeMemberListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"移除队员";
    self.navigationBar.navigationItem.backBarButtonItem.hidden = YES;
    self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithTitle:@"移除" target:self action:@selector(handleActionForRemoveBarButtonItem:)];
    self.navigationBar.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationBar.navigationItem.rightBarButtonItem.width = 55.0;
    self.navigationBar.navigationItem.leftBarButtonItem = [[CXBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(handleActionForCancelBarButtonItem:)];
    self.navigationBar.navigationItem.leftBarButtonItem.width = 55.0;
    
    CGFloat tableView_X = 0;
    CGFloat tableView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat tableView_W = CGRectGetWidth(self.view.bounds);
    CGFloat tableView_H = CGRectGetHeight(self.view.bounds) - tableView_Y;
    _tableView = [[CXTableView alloc] initWithFrame:(CGRect){tableView_X, tableView_Y, tableView_W, tableView_H} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0;
    _tableView.contentInset = [UIScreen mainScreen].cx_scrollViewSafeAreaInset;
    [self.view addSubview:_tableView];
    
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.font = CX_PingFangSC_RegularFont(15.0);
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.textColor = CXHexIColor(0x666666);
    _emptyLabel.text = @"无其他队员";
    _emptyLabel.hidden = YES;
    [_tableView addSubview:_emptyLabel];
    CGFloat emptyLabel_X = 0;
    CGFloat emptyLabel_Y = 0;
    CGFloat emptyLabel_W = tableView_W;
    CGFloat emptyLabel_H = tableView_H - tableView_Y;
    _emptyLabel.frame = (CGRect){emptyLabel_X, emptyLabel_Y, emptyLabel_W, emptyLabel_H};
    
    [self loadUserListRequest];
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
        [self.view insertSubview:_errorView belowSubview:_tableView];
    }
    
    if(error){
        [_errorView showWithError:error];
    }else{
        [_errorView showWithErrorCode:CXPageErrorCodeInternetUnavailable];
    }
    
    _tableView.hidden = YES;
}

- (void)hidePageErrorView{
    _errorView.hidden = YES;
    _tableView.hidden = NO;
}

- (void)loadUserListRequest{
    [CXHUD showHUD];
    CXMotorcadeUserListRequest *request = [[CXMotorcadeUserListRequest alloc] initWithMotorcadeId:self.motorcadeId];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        [CXHUD dismiss];
        CXMotorcadeUserListModel *model = (CXMotorcadeUserListModel *)data;
        if(model.isValid){
            self->_userModels = [model.result.data mutableCopy];
            [self->_userModels enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.type == CXMotorcadeMemberCaptain){
                    [self->_userModels removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            [self reloadData];
        }else{
            [self showPageErrorViewWithError:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD dismiss];
        [self showPageErrorViewWithError:error];
    }];
}

- (void)handleActionForCancelBarButtonItem:(CXBarButtonItem *)barButtonItem{
    [self didClickBackBarButtonItem:barButtonItem];
}

- (void)handleActionForRemoveBarButtonItem:(CXBarButtonItem *)barButtonItem{
    NSMutableString *userIds = [NSMutableString string];
    [_selectedUserModels enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [userIds appendFormat:@"%@,", obj.userId];
    }];
    
    [CXHUD showHUD];
    CXMotorcadeKickOutRequest *request = [[CXMotorcadeKickOutRequest alloc] initWithMotorcadeId:self.motorcadeId userIds:[userIds copy]];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            [self->_userModels removeObjectsInArray:self->_selectedUserModels];
            [self->_selectedUserModels removeAllObjects];
            self.navigationBar.navigationItem.rightBarButtonItem.title = @"移除";
            self.navigationBar.navigationItem.rightBarButtonItem.enabled = NO;
            [self reloadData];
        }else{
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD showMsg:error.HUDMsg];
    }];
}

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView{
    [self loadUserListRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMotorcadeMemberManageCell *cell = [CXMotorcadeMemberManageCell cellWithTableView:tableView];
    cell.memberInfoModel = _userModels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXMotorcadeUserInfoModel *memberInfoModel = _userModels[indexPath.row];
    memberInfoModel.selected = !memberInfoModel.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if(memberInfoModel.selected){
        if(!_selectedUserModels){
            _selectedUserModels = [NSMutableArray array];
        }
        [_selectedUserModels addObject:memberInfoModel];
    }else{
        [_selectedUserModels removeObject:memberInfoModel];
    }
    
    if(CXArrayIsEmpty(_selectedUserModels)){
        self.navigationBar.navigationItem.rightBarButtonItem.title = @"移除";
        self.navigationBar.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationBar.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"移除(%@)", @(_selectedUserModels.count)];
        self.navigationBar.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)reloadData{
    if(CXArrayIsEmpty(_userModels)){
        _emptyLabel.hidden = NO;
    }else{
        _emptyLabel.hidden = YES;
    }
    
    [_tableView reloadData];
}

@end
