//
//  CXCreateMotorcadeVC.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXCreateMotorcadeVC.h"
#import "CXMotorcadeVoiceModeControl.h"
#import "CXMotorcadeRequestUtils.h"
#import "CXMotorcadeManager+CXExtensions.h"

@interface CXCreateMotorcadeVC () {
    UILabel *_textLabel;
    CXMotorcadeVoiceModeControl *_talkbackControl;
    CXMotorcadeVoiceModeControl *_realTimeControl;
    UIButton *_createButton;
}

@end

@implementation CXCreateMotorcadeVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_mymotorcade_newcreate";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新建小队";
    self.navigationBar.hiddenBottomHorizontalLine = YES;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = CX_PingFangSC_RegularFont(14.0);
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = CXHexIColor(0x353C43);
    _textLabel.text = @"选择群聊模式";
    [self.view addSubview:_textLabel];
    CGFloat textLabel_X = 20.0;
    CGFloat textLabel_Y = CGRectGetMaxY(self.navigationBar.frame) + 27.0;
    CGFloat textLabel_W = CGRectGetWidth(self.view.bounds) - textLabel_X * 2;
    CGFloat textLabel_H = 20.0;
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    _talkbackControl = [[CXMotorcadeVoiceModeControl alloc] initWithVoiceMode:CXMotorcadeTalkbackVoice];
    _talkbackControl.selected = YES;
    [_talkbackControl addTarget:self action:@selector(handleActionForVoiceModeControl:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_talkbackControl];
    CGFloat talkbackControl_X = 20.0;
    CGFloat talkbackControl_Y = CGRectGetMaxY(_textLabel.frame) + 16.0;
    CGFloat talkbackControl_H = 80.0;
    CGFloat talkbackControl_W = (CGRectGetWidth(self.view.bounds) - talkbackControl_X * 2 - 10.0) * 0.5;
    _talkbackControl.frame = (CGRect){talkbackControl_X, talkbackControl_Y, talkbackControl_W, talkbackControl_H};
    
    _realTimeControl = [[CXMotorcadeVoiceModeControl alloc] initWithVoiceMode:CXMotorcadeRealTimeVoice];
    _realTimeControl.selected = NO;
    [_realTimeControl addTarget:self action:@selector(handleActionForVoiceModeControl:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_realTimeControl];
    CGFloat realTimeControl_X = CGRectGetMaxX(_talkbackControl.frame) + 10.0;
    CGFloat realTimeControl_Y = talkbackControl_Y;
    CGFloat realTimeControl_W = talkbackControl_W;
    CGFloat realTimeControl_H = talkbackControl_H;
    _realTimeControl.frame = (CGRect){realTimeControl_X, realTimeControl_Y, realTimeControl_W, realTimeControl_H};
    
    _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _createButton.titleLabel.font = CX_PingFangSC_SemiboldFont(16.0);
    [_createButton setTitle:@"新建小队" forState:UIControlStateNormal];
    [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_createButton cx_setBackgroundColors:@[CXHexIColor(0x00CDFF), CXHexIColor(0x00B7FF)]
                        gradientDirection:CXColorGradientHorizontal
                                 forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(handleActionForCreateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createButton];
    CGFloat createButton_X = 18.0;
    CGFloat createButton_Y = CGRectGetMaxY(_talkbackControl.frame) + 30.0;
    CGFloat createButton_W = CGRectGetWidth(self.view.bounds) - createButton_X * 2;
    CGFloat createButton_H = 44.0;
    _createButton.frame = (CGRect){createButton_X, createButton_Y, createButton_W, createButton_H};
    [_createButton cx_roundedCornerRadii:createButton_H * 0.5];
}

- (void)handleActionForVoiceModeControl:(CXMotorcadeVoiceModeControl *)voiceModeControl{
    if(voiceModeControl.isSelected){
        return;
    }
    
    if(voiceModeControl.voiceMode == CXMotorcadeTalkbackVoice){
        CXDataRecord(@"app_click_my_newcreate_handtable");
    }else{
        CXDataRecord(@"app_click_my_newcreate_speechpattern");
    }
    
    _talkbackControl.selected = _talkbackControl == voiceModeControl;
    _realTimeControl.selected = !_talkbackControl.isSelected;
}

- (void)handleActionForCreateButton:(UIButton *)createButton{
    CXDataRecord(@"app_click_my_newcreate_quickcreate");
    
    CXMotorcadeVoiceMode voiceMode = CXMotorcadeTalkbackVoice;
    if(_realTimeControl.isSelected){
        voiceMode = _realTimeControl.voiceMode;
    }
    
    [CXHUD showHUD];
    [CXMotorcadeRequestUtils createMotorcadeWithVoiceMode:voiceMode completion:^(CXMotorcadeOnlineModel *onlineModel, NSError *error) {
        if(onlineModel.isValid){
            [CXHUD dismiss];
            [CXMotorcadeManager enterMotorcadePage:onlineModel.result enterType:CXSchemePushAfterDestroyCurrentVC];
        }else{
            [CXHUD showMsg:onlineModel.msg ?: error.HUDMsg];
        }
    }];
}

@end
