//
//  CXMotorcadeMapVoiceToolbar.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXMotorcadeMapVoiceToolbar.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMotorcadeDefines.h"

static inline CXButtonCombinedRect CXCombinedRectFromButtonContentRect(CGRect contentRect){
    CGFloat image_W = 30.0;
    CGFloat image_H = image_W;
    CGFloat image_X = (CGRectGetWidth(contentRect) - image_W) * 0.5;
    CGFloat image_Y = 1.5;
    CGRect imageRect = (CGRect){image_X, image_Y, image_W, image_H};
    
    CGFloat title_X = 0;
    CGFloat title_Y = CGRectGetMaxY(imageRect);
    CGFloat title_W = CGRectGetWidth(contentRect);
    CGFloat title_H = 17.0;
    CGRect titleRect = (CGRect){title_X, title_Y, title_W, title_H};
    
    return CXButtonCombinedRectMake(imageRect, titleRect);
}

@interface CXMotorcadeMapVoiceToolbar () {
    CXBlockLayoutButton *_speakerButton;
    UIButton *_microphoneButton;
    CXBlockLayoutButton *_groupChatButton;
    UIImageView *_newMsgView;
}

@end

@implementation CXMotorcadeMapVoiceToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.5, -0.5);
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 3.0;
        
        _speakerButton = [CXBlockLayoutButton buttonWithType:UIButtonTypeCustom];
        [_speakerButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_vtool_speaker_on") forState:UIControlStateNormal];
        [_speakerButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_vtool_speaker_off") forState:UIControlStateSelected];
        [_speakerButton setTitle:@"队友声音" forState:UIControlStateNormal];
        [_speakerButton setTitleColor:CXHexIColor(0x666666) forState:UIControlStateNormal];
        [_speakerButton setTitleColor:CXHexIColor(0x333333) forState:UIControlStateHighlighted];
        _speakerButton.titleLabel.font = CX_PingFangSC_RegularFont(12.0);
        [_speakerButton addTarget:self action:@selector(handleActionForSpeakerButton:) forControlEvents:UIControlEventTouchUpInside];
        _speakerButton.combinedRectBlock = ^CXButtonCombinedRect(CXBlockLayoutButton *button, CGRect contentRect) {
            return CXCombinedRectFromButtonContentRect(contentRect);
        };
        
        _microphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microphoneButton addTarget:self action:@selector(handleActionForMicrophoneButton:) forControlEvents:UIControlEventTouchUpInside];
        _microphoneButton.selected = YES;
        
        _groupChatButton = [CXBlockLayoutButton buttonWithType:UIButtonTypeCustom];
        [_groupChatButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_map_vtool_chat") forState:UIControlStateNormal];
        [_groupChatButton setTitle:@"队友群聊" forState:UIControlStateNormal];
        [_groupChatButton setTitleColor:CXHexIColor(0x666666) forState:UIControlStateNormal];
        [_groupChatButton setTitleColor:CXHexIColor(0x333333) forState:UIControlStateHighlighted];
        _groupChatButton.titleLabel.font = CX_PingFangSC_RegularFont(12.0);
        [_groupChatButton addTarget:self action:@selector(handleActionForGroupChatButton:) forControlEvents:UIControlEventTouchUpInside];
        _groupChatButton.combinedRectBlock = ^CXButtonCombinedRect(CXBlockLayoutButton *button, CGRect contentRect) {
            return CXCombinedRectFromButtonContentRect(contentRect);
        };
        
        _newMsgView = [[UIImageView alloc] init];
        _newMsgView.image = [UIImage cx_imageWithColor:CXHexIColor(0xFF2B26)];
        _newMsgView.hidden = YES;
        [_groupChatButton addSubview:_newMsgView];
        
        [self addSubview:_speakerButton];
        [self addSubview:_microphoneButton];
        [self addSubview:_groupChatButton];
        
        self.microphoneState = CXMotorcadeMicrophoneStateOff;
    }
    
    return self;
}

- (void)setMicrophoneState:(CXMotorcadeMicrophoneState)microphoneState{
    if(_microphoneState == microphoneState){
        return;
    }
    
    _microphoneState = microphoneState;
    NSString *imageName = nil;
    switch (microphoneState) {
        case CXMotorcadeMicrophoneStateOn:
            imageName = @"motorcade_map_vtool_mic_state_on";
            break;
        case CXMotorcadeMicrophoneStateOff:
            imageName = @"motorcade_map_vtool_mic_state_off";
            break;
        case CXMotorcadeMicrophoneStateDisabled:
            imageName = @"motorcade_map_vtool_mic_state_disabled";
            break;
        default:
            break;
    }
    
    if(imageName){
        [_microphoneButton setImage:CX_MOTORCADE_IMAGE(imageName) forState:UIControlStateNormal];
    }
}

- (void)setSpeakerEnabled:(BOOL)speakerEnabled{
    _speakerButton.selected = !speakerEnabled;
}

- (BOOL)isSpeakerEnabled{
    return !_speakerButton.isSelected;
}

- (void)setHasNewMsg:(BOOL)hasNewMsg{
    _newMsgView.hidden = !hasNewMsg;
}

- (BOOL)hasNewMsg{
    return !_newMsgView.isHidden;
}

- (void)handleActionForGroupChatButton:(UIButton *)groupChatButton{
    self.hasNewMsg = NO;
    groupChatButton.userInteractionEnabled = NO;
    
    if([self.delegate respondsToSelector:@selector(motorcadeMapVoiceToolbarDidEnterGroupChatPageAction:)]){
        [self.delegate motorcadeMapVoiceToolbarDidEnterGroupChatPageAction:self];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        groupChatButton.userInteractionEnabled = YES;
    });
}

- (void)handleActionForSpeakerButton:(UIButton *)speakerButton {
    speakerButton.userInteractionEnabled = NO;
    speakerButton.selected = !speakerButton.isSelected;
    
    if([self.delegate respondsToSelector:@selector(motorcadeMapVoiceToolbar:didChangeSpeakerState:)]){
        [self.delegate motorcadeMapVoiceToolbar:self didChangeSpeakerState:!speakerButton.isSelected];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        speakerButton.userInteractionEnabled = YES;
    });
}

- (void)handleActionForMicrophoneButton:(UIButton *)microphoneButton{
    microphoneButton.userInteractionEnabled = NO;
    
    CXMotorcadeMicrophoneState state = 0;
    if(self.microphoneState == CXMotorcadeMicrophoneStateOn){
        state = CXMotorcadeMicrophoneStateOff;
    }else{
        state = CXMotorcadeMicrophoneStateOn;
    }
    
    if([self.delegate respondsToSelector:@selector(motorcadeMapVoiceToolbar:didChangeMicrophoneState:)]){
        [self.delegate motorcadeMapVoiceToolbar:self didChangeMicrophoneState:state];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        microphoneButton.userInteractionEnabled = YES;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) * 0.5;
    
    CGFloat microphoneButton_H = 73.0;
    CGFloat microphoneButton_W = microphoneButton_H;
    CGFloat microphoneButton_X = (CGRectGetWidth(self.bounds) - microphoneButton_W) * 0.5;
    CGFloat microphoneButton_Y = -5.0;
    _microphoneButton.frame = (CGRect){microphoneButton_X, microphoneButton_Y, microphoneButton_W, microphoneButton_H};
    
    CGFloat speakerButton_H = 50.0;
    CGFloat speakerButton_W = speakerButton_H;
    CGFloat speakerButton_X = microphoneButton_X - speakerButton_W - 20.0;
    CGFloat speakerButton_Y = microphoneButton_Y + (microphoneButton_H - speakerButton_H) * 0.5;
    _speakerButton.frame = (CGRect){speakerButton_X, speakerButton_Y, speakerButton_W, speakerButton_H};
    
    CGFloat groupChatButton_H = speakerButton_H;
    CGFloat groupChatButton_W = groupChatButton_H;
    CGFloat groupChatButton_X = CGRectGetMaxX(_microphoneButton.frame) + 20.0;
    CGFloat groupChatButton_Y = speakerButton_Y;
    _groupChatButton.frame = (CGRect){groupChatButton_X, groupChatButton_Y, groupChatButton_W, groupChatButton_H};
    
    CGFloat newMsgView_W = 10.0;
    CGFloat newMsgView_H = newMsgView_W;
    CGFloat newMsgView_X = groupChatButton_W - newMsgView_W - 8.0;
    CGFloat newMsgView_Y = CGRectGetMidY(_groupChatButton.frame) - newMsgView_H - 20.0;
    _newMsgView.frame = (CGRect){newMsgView_X, newMsgView_Y, newMsgView_W, newMsgView_H};
    [_newMsgView cx_roundedCornerRadii:newMsgView_H * 0.5];
}

@end
