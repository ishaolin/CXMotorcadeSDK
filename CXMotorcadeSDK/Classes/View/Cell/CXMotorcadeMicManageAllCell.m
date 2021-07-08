//
//  CXMotorcadeMicManageAllCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeMicManageAllCell.h"
#import "CXEditMicPermissionRequest.h"

@implementation CXMotorcadeMicManageAllCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CXMotorcadeMicManageAllCell";
    return [self cellWithTableView:tableView reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.titleLabel.font = CX_PingFangSC_RegularFont(16.0);
        self.titleLabel.textColor = CXHexIColor(0x333333);
    }
    
    return self;
}

- (void)handleActionForSwitchView:(UISwitch *)switchView{
    [CXHUD showHUD];
    CXEditMicPermissionRequest *request = [[CXEditMicPermissionRequest alloc] initWithMotorcadeId:self.motorcadeId permission:!switchView.isOn forUserId:nil];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            CXSettingRightSwitchRowModel *switchModel = (CXSettingRightSwitchRowModel *)self.rowModel;
            switchModel.on = switchView.isOn;
            if(switchModel.switchActionHandler){
                switchModel.switchActionHandler(switchModel, switchView.isOn, [self cx_viewController]);
            }
        }else{
            [switchView setOn:!switchView.isOn animated:YES];
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [switchView setOn:!switchView.isOn animated:YES];
        [CXHUD showMsg:error.HUDMsg];
    }];
}

@end
