//
//  CXMotorcadeManager+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2019/3/27.
//

#import "CXMotorcadeManager.h"

@class CXMotorcadeOnlineResultModel;

@interface CXMotorcadeManager (CXExtensions)

- (void)notifyDelegateHandleSchemeEvent:(CXSchemeEvent *)event;
- (void)notifyDelegateTokenInvalid:(NSString *)msg;
- (void)notifyDelegateForceUpdateApp:(NSString *)msg downloadURL:(NSString *)URL;

+ (void)enterMotorcadePage:(CXMotorcadeOnlineResultModel *)onlineModel;

+ (void)enterMotorcadePage:(CXMotorcadeOnlineResultModel *)onlineModel
                 enterType:(CXSchemePushType)enterType;

+ (void)goBackToMotorcadePage;

+ (void)quitMotorcadePage;

+ (void)removeMotorcadeId:(NSString *)motorcadeId;

+ (void)setUpdateActiveMotorcadeOnlineCount:(NSUInteger)count;

@end
