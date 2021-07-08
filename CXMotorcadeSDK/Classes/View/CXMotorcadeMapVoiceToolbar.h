//
//  CXMotorcadeMapVoiceToolbar.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CXMotorcadeMicrophoneState) {
    CXMotorcadeMicrophoneStateOff      = 1,  // 麦克风关闭
    CXMotorcadeMicrophoneStateOn       = 2,  // 麦克风开启
    CXMotorcadeMicrophoneStateDisabled = 3   // 没有权限控制麦克风
};

@class CXMotorcadeMapVoiceToolbar;

@protocol CXMotorcadeMapVoiceToolbarDelegate <NSObject>

@optional

- (void)motorcadeMapVoiceToolbar:(CXMotorcadeMapVoiceToolbar *)voiceToolbar didChangeSpeakerState:(BOOL)speakerEnabled;
- (void)motorcadeMapVoiceToolbar:(CXMotorcadeMapVoiceToolbar *)voiceToolbar didChangeMicrophoneState:(CXMotorcadeMicrophoneState)microphoneState;
- (void)motorcadeMapVoiceToolbarDidEnterGroupChatPageAction:(CXMotorcadeMapVoiceToolbar *)voiceToolbar;

@end

@interface CXMotorcadeMapVoiceToolbar : UIView

@property(nonatomic, weak) id<CXMotorcadeMapVoiceToolbarDelegate> delegate;

@property (nonatomic, assign) CXMotorcadeMicrophoneState microphoneState;
@property (nonatomic, assign, getter = isSpeakerEnabled) BOOL speakerEnabled;
@property (nonatomic, assign) BOOL hasNewMsg;

@end
