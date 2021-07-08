//
//  CXContactListVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXContactListVC.h"
#import "CXContactListEmptyView.h"
#import "CXContactListCell.h"

@interface CXContactListVC () <UITableViewDelegate, UITableViewDataSource, CXContactListEmptyViewDelegate> {
    CXTableView *_tableView;
    CXContactListEmptyView *_emptyView;
    NSMutableDictionary<NSString *, NSNumber *> *_indexTitleSections;
    NSArray<NSString *> *_indexKeys;
    CXIndexList *_indexList;
}

@end

@implementation CXContactListVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"30000087";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请好友";
    self.navigationBar.shadowEnabled = YES;
    
    _indexKeys = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                   @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
                   @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    
    CGFloat tableView_X = 0;
    CGFloat tableView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat tableView_W = CGRectGetWidth(self.view.bounds);
    CGFloat tableView_H = CGRectGetHeight(self.view.bounds) - tableView_Y;
    _tableView = [[CXTableView alloc] initWithFrame:CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = CXHexIColor(0xF0F1F4);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexColor = [CXHexIColor(0x333333) colorWithAlphaComponent:0.6];
    _tableView.rowHeight = 60.0;
    _tableView.sectionHeaderHeight = 30.0;
    _tableView.contentInset = [UIScreen mainScreen].cx_scrollViewSafeAreaInset;
    [self.view addSubview:_tableView];
    
    [self loadContactData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _indexList.indexObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _indexList.indexObjects[section].objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXIndexObject *indexObject = _indexList.indexObjects[indexPath.section];
    CXContact *contact = indexObject.objects[indexPath.row];
    CXContactListCell *cell = [CXContactListCell cellWithTableView:tableView];
    cell.nameLabel.text = contact.name;
    cell.moblieLabel.text = contact.phoneNumber;
    cell.lineView.hidden = indexPath.row == 0;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(CXArrayIsEmpty(_indexList.indexObjects)){
        return nil;
    }
    
    return _indexKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return _indexTitleSections[title].unsignedIntegerValue;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CXContactListSectionHeaderView *view = [CXContactListSectionHeaderView viewWithTableView:tableView];
    view.titleLabel.text = _indexList.indexObjects[section].indexKey;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXDataRecord(@"30000089");
    
    if([self.delegate respondsToSelector:@selector(contactListVC:didSelectContact:)]){
        CXContact *contact = _indexList.indexObjects[indexPath.section].objects[indexPath.row];
        [self.delegate contactListVC:self didSelectContact:contact];
    }
}

- (void)loadContactData{
    [CXContactUtils requestAuthorization:^(CXContactsAuthStatus status) {
        if(status != CXContactsAuthStatusAuthorized){
            [self reloadData];
        }else{
            [CXContactUtils fetchContactsGroup:^(CXIndexList *indexList) {
                self->_indexList = indexList;
                [self makeIndexTitleSections];
                [self reloadData];
            }];
        }
    }];
}

- (void)makeIndexTitleSections{
    if(CXArrayIsEmpty(_indexList.indexObjects)){
        return;
    }
    
    if(!_indexTitleSections){
        _indexTitleSections = [NSMutableDictionary dictionary];
    }else{
        [_indexTitleSections removeAllObjects];
    }
    
    __block NSUInteger validIndex = 0;
    [_indexKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [self->_indexList.indexKeys indexOfObject:obj];
        if(index != NSNotFound){
            validIndex = index;
        }
        self->_indexTitleSections[obj] = @(validIndex);
    }];
}

- (void)contactListEmptyViewDidFetchAction:(CXContactListEmptyView *)emptyView{
    CXDataRecord(@"30000090");
    
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.message = [NSString stringWithFormat:@"请打开系统设置中“设置->隐私”，允许“%@”访问您的通讯录。", [NSBundle mainBundle].cx_appName];
        config.buttonTitles = @[@"取消", @"确定"];
    } completion:^(NSUInteger buttonIndex) {
        if(buttonIndex == 1){
            [CXAppUtil openOSSettingPage];
        }
    }];
}

- (void)reloadData{
    if(CXArrayIsEmpty(_indexList.indexObjects)){
        if(!_emptyView){
            _emptyView = [[CXContactListEmptyView alloc] init];
            _emptyView.delegate = self;
            _emptyView.frame = (CGRect){0, 0, 0, CGRectGetHeight(_tableView.frame)};
        }
        
        _emptyView.authorized = [CXContactUtils contactsAuthStatus] == CXContactsAuthStatusAuthorized;
        _tableView.tableFooterView = _emptyView;
        _tableView.scrollEnabled = NO;
    }else{
        _tableView.tableFooterView = nil;
        _tableView.scrollEnabled = YES;
    }
    
    [_tableView reloadData];
}

@end
