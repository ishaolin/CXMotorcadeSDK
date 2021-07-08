//
//  CXMotorcadeMicManageMemberCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeMicManageMemberCell.h"
#import "CXMotorcadeDefines.h"
#import "CXMotorcadeMicListModel.h"
#import "CXEditMicPermissionRequest.h"

@interface CXMotorcadeMicManageMemberCell () {
    CXActionItemButton *_micButton;
    UIView *_stateView;
    UILabel *_stateLabel;
}

@end

@implementation CXMotorcadeMicManageMemberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CXMotorcadeMicManageMemberCell";
    return [self cellWithTableView:tableView reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.titleLabel.font = CX_PingFangSC_RegularFont(17.0);
        self.titleLabel.textColor = CXHexIColor(0x353C43);
        self.switchView.hidden = YES;
        
        _micButton = [CXActionItemButton buttonWithType:UIButtonTypeCustom];
        _micButton.enableHighlighted = NO;
        [_micButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_mic_setting_off") forState:UIControlStateNormal];
        [_micButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_mic_setting_on") forState:UIControlStateSelected];
        [_micButton addTarget:self action:@selector(handleActionForMicButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_micButton];
        
        _stateView = [[UIView alloc] init];
        _stateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.contentView addSubview:_stateView];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = @"离线";
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = CX_PingFangSC_RegularFont(10.0);
        [_stateView addSubview:_stateLabel];
    }
    
    return self;
}

- (void)handleActionForMicButton:(CXActionItemButton *)micButton{
    if(self.isAllMemberMicDisabled){
        [CXHUD showMsg:@"您已开启全员禁麦"];
        return;
    }
    
    micButton.selected = !micButton.isSelected;
    [CXHUD showHUD];
    
    CXSettingRightSwitchRowModel *switchRowModel = (CXSettingRightSwitchRowModel *)self.rowModel;
    CXMotorcadeMicUserInfoModel *infoModel = (CXMotorcadeMicUserInfoModel *)switchRowModel.userInfo;
    CXEditMicPermissionRequest *request = [[CXEditMicPermissionRequest alloc] initWithMotorcadeId:self.motorcadeId permission:micButton.selected forUserId:infoModel.userId];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            switchRowModel.on = micButton.isSelected;
            if(switchRowModel.switchActionHandler){
                switchRowModel.switchActionHandler(switchRowModel, switchRowModel.isOn, [self cx_viewController]);
            }
        }else{
            micButton.selected = !micButton.isSelected;
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        micButton.selected = !micButton.isSelected;
        [CXHUD showMsg:error.HUDMsg];
    }];
}

- (void)setRowModel:(CXSettingRowModel *)rowModel{
    [super setRowModel:rowModel];
    
    CXSettingRightSwitchRowModel *switchRowModel = (CXSettingRightSwitchRowModel *)rowModel;
    if(self.isAllMemberMicDisabled){
        _micButton.selected = NO;
    }else{
        _micButton.selected = switchRowModel.isOn;
    }
    CXMotorcadeMicUserInfoModel *infoModel = (CXMotorcadeMicUserInfoModel *)switchRowModel.userInfo;
    _stateView.hidden = infoModel.onLineStatus == CXMotorcadeOnlineStateOnline;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iconView_W = 45.0;
    CGFloat iconView_H = iconView_W;
    CGFloat iconView_X = CGRectGetMinX(self.iconView.frame);
    CGFloat iconView_Y = (CGRectGetHeight(self.bounds) - iconView_H) * 0.5;
    self.iconView.frame = (CGRect){iconView_X, iconView_Y, iconView_W, iconView_H};
    [self.iconView cx_roundedCornerRadii:iconView_H * 0.5];
    
    CGFloat micButton_W = 34.0;
    CGFloat micButton_H = micButton_W;
    CGFloat micButton_X = CGRectGetWidth(self.bounds) - micButton_W - iconView_X;
    CGFloat micButton_Y = (CGRectGetHeight(self.bounds) - micButton_H) * 0.5;
    _micButton.frame = (CGRect){micButton_X, micButton_Y, micButton_W, micButton_H};
    
    CGFloat titleLabel_X = CGRectGetMaxX(self.iconView.frame) + 10.0;
    CGFloat titleLabel_W = micButton_X - titleLabel_X;
    CGFloat titleLabel_H = 24.0;
    CGFloat titleLabel_Y = (CGRectGetHeight(self.bounds) - titleLabel_H) * 0.5;
    self.titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
    
    CGFloat lineView_X = titleLabel_X;
    CGFloat lineView_H = 0.5;
    CGFloat lineView_W = CGRectGetWidth(self.bounds) - lineView_X;
    CGFloat lineView_Y = CGRectGetHeight(self.bounds) - lineView_H;
    self.lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
    
    _stateView.frame = self.iconView.frame;
    _stateLabel.frame = _stateView.bounds;
    [_stateView cx_roundedCornerRadii:iconView_H * 0.5];
}

@end
