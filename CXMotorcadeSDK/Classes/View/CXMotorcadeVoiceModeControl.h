//
//  CXMotorcadeVoiceModeControl.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeDefines.h"

@interface CXMotorcadeVoiceModeControl : UIControl

@property (nonatomic, assign, readonly) CXMotorcadeVoiceMode voiceMode;

- (instancetype)initWithVoiceMode:(CXMotorcadeVoiceMode)voiceMode;

@end
