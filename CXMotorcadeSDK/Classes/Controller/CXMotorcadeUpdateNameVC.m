//
//  CXMotorcadeUpdateNameVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeUpdateNameVC.h"
#import "CXMotorcadeNameEditCell.h"
#import "CXMotorcadeOnlineModel.h"
#import "CXRoundShadowActionButton.h"
#import "CXMotorcadeUpdateNameRequest.h"
#import "CXMotorcadeNotificationName.h"

@interface CXMotorcadeUpdateNameVC () <CXMotorcadeNameEditCellDelegate>{
    CXRoundShadowActionButton *_saveButton;
    NSString *_inputName;
}

@end

@implementation CXMotorcadeUpdateNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CXHexIColor(0xF0F1F4);
    self.title = @"修改小队名称";
    self.tableView.contentInset = UIEdgeInsetsMake(25.0, 0, 0, 0);
    self.tableView.touchesBeganBlock = ^(CXTableView *tableView, NSSet<UITouch *> *touchs, UIEvent *event) {
        [tableView endEditing:YES];
    };
    
    CGFloat saveButton_X = CX_MARGIN(20.0);
    CGFloat saveButton_H = 45.0;
    CGFloat saveButton_Y = CGRectGetHeight(self.view.bounds) - saveButton_H - saveButton_X - [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    CGFloat saveButton_W = CGRectGetWidth(self.view.bounds) - saveButton_X * 2;
    _saveButton = [[CXRoundShadowActionButton alloc] init];
    _saveButton.title = @"保存";
    _saveButton.enabled = NO;
    [_saveButton addTarget:self action:@selector(handleActionForSaveButton:)];
    _saveButton.frame = CGRectMake(saveButton_X, saveButton_Y, saveButton_W, saveButton_H);
    [self.view addSubview:_saveButton];
}

- (void)loadDataWithCompletion:(CXSettingViewControllerDataBlock)completion{
    CXSettingRowModel *rowModel = [[CXSettingRowModel alloc] initWithTitle:self.motorcadeInfo.name];
    rowModel.height = 50.0;
    rowModel.arrowHidden = YES;
    
    CXSettingSectionModel *sectionModel = [[CXSettingSectionModel alloc] initWithRows:@[rowModel]
                                                                         footerHeight:CGFLOAT_MIN
                                                                        footerContent:nil];
    completion(@[sectionModel]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMotorcadeNameEditCell *cell = [CXMotorcadeNameEditCell cellWithTableView:tableView];
    cell.delegate = self;
    CXSettingSectionModel *sectionModel = self.settingItems[indexPath.section];
    cell.rowModel = sectionModel.rows[indexPath.row];
    return cell;
}

- (void)motorcadeNameEditCell:(CXMotorcadeNameEditCell *)editCell didChangeInputText:(NSString *)inputText{
    _inputName = inputText;
    
    if(CXStringIsEmpty(inputText) || [self.motorcadeInfo.name isEqualToString:inputText]){
        _saveButton.enabled = NO;
    }else{
        _saveButton.enabled = YES;
    }
}

- (void)handleActionForSaveButton:(CXRoundShadowActionButton *)saveButton{
    if(CXStringIsEmpty(_inputName)){
        return;
    }
    
    [CXHUD showHUD];
    CXMotorcadeUpdateNameRequest *request = [[CXMotorcadeUpdateNameRequest alloc] initWithMotorcadeId:self.motorcadeInfo.id name:_inputName];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            [NSNotificationCenter notify:CXMotorcadeNameChangedNotification userInfo:@{CXNotificationUserInfoKey0 : self->_inputName}];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD showMsg:error.HUDMsg];
    }];
}

@end
