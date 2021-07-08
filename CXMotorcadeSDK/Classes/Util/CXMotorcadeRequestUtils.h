//
//  CXMotorcadeRequestUtils.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeOnlineModel.h"

@class CXMapPOIModel;

typedef void(^CXMotorcadeOnlineInfoCompletionBlock)(CXMotorcadeOnlineModel *onlineModel, NSError *error);

@interface CXMotorcadeRequestUtils : NSObject

+ (void)createMotorcadeWithVoiceMode:(CXMotorcadeVoiceMode)voiceMode completion:(CXMotorcadeOnlineInfoCompletionBlock)completion;

+ (void)onlineMotorcadeWithId:(NSString *)id completion:(CXMotorcadeOnlineInfoCompletionBlock)completion;

+ (void)enterMotorcadeWithCommand:(NSString *)command completion:(CXMotorcadeOnlineInfoCompletionBlock)completion;

+ (void)enterMotorcadeWithId:(NSString *)id completion:(CXMotorcadeOnlineInfoCompletionBlock)completion;

+ (void)setDestinationWithPOIModel:(CXMapPOIModel *)POIModel
                       motorcadeId:(NSString *)motorcadeId
                        completion:(void (^)(NSString *destinationJSONString))completion;

@end
