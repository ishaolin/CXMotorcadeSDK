//
//  CXCmdJoinMotorcadeVC.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXCmdJoinMotorcadeVC.h"
#import "CXMotorcadeCmdInputView.h"
#import "CXMotorcadeRequestUtils.h"
#import "CXMotorcadeManager+CXExtensions.h"

@interface CXCmdJoinMotorcadeVC () <CXMotorcadeCmdInputViewDelegate> {
    UILabel *_titleLabel;
    CXMotorcadeCmdInputView *_cmdInputView;
}

@end

@implementation CXCmdJoinMotorcadeVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_mymotorcade_command";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"口令加入小队";
    self.navigationBar.shadowEnabled = YES;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = CXHexIColor(0xF9F9F9);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"输入口令加入小队";
    _titleLabel.textColor = CXHexIColor(0x353C43);
    _titleLabel.font = CX_PingFangSC_RegularFont(17.0);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    _cmdInputView = [[CXMotorcadeCmdInputView alloc] initWithSuperview:self.view cmdCount:6];
    _cmdInputView.delegate = self;
    [self.view addSubview:_cmdInputView];
    
    CGFloat cmdInputView_H = 36.0;
    CGFloat cmdInputView_M = 40.0;
    
    CGFloat titleLabel_X = 0;
    CGFloat titleLabel_W = CGRectGetWidth(self.view.bounds);
    CGFloat titleLabel_H = _titleLabel.font.lineHeight;
    CGFloat titleLabel_Y = (CGRectGetHeight(self.view.bounds) - (_cmdInputView.keyboardSize.height + cmdInputView_H + cmdInputView_M + titleLabel_H)) * 0.5;
    _titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
    
    CGFloat cmdInputView_X = titleLabel_X;
    CGFloat cmdInputView_W = titleLabel_W;
    CGFloat cmdInputView_Y = CGRectGetMaxY(_titleLabel.frame) + cmdInputView_M;
    _cmdInputView.frame = (CGRect){cmdInputView_X, cmdInputView_Y, cmdInputView_W, cmdInputView_H};
}

- (void)motorcadeCmdInputView:(CXMotorcadeCmdInputView *)inputView didFinishWithCmd:(NSString *)cmd{
    [CXHUD showHUD];
    [CXMotorcadeRequestUtils enterMotorcadeWithCommand:cmd completion:^(CXMotorcadeOnlineModel *onlineModel, NSError *error) {
        if(onlineModel.isValid){
            [CXHUD dismiss];
            [CXMotorcadeManager enterMotorcadePage:onlineModel.result
                                         enterType:CXSchemePushAfterDestroyCurrentVC];
        }else{
            [self->_cmdInputView clear];
            [CXHUD showMsg:onlineModel.msg ?: error.HUDMsg];
        }
    }];
}

@end
