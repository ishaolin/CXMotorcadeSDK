//
//  CXCreateMotorcadeRequest.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXBaseMotorcadeURLRequest.h"
#import "CXMotorcadeOnlineModel.h"

@interface CXCreateMotorcadeRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithVoiceMode:(NSNumber *)voiceMode;

@end
