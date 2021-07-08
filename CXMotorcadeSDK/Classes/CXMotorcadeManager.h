//
//  CXMotorcadeManager.h
//  Pods
//
//  Created by wshaolin on 2019/3/27.
//

#import <Foundation/Foundation.h>
#import <CXNetSDK/CXNetDefines.h>
#import "CXMotorcadeSchemeDefines.h"
#import "CXUserSexType.h"

@class CXMotorcadeManager, CXMotorcadeLoginUserInfo;

@protocol CXMotorcadeManagerDelegate <NSObject>

@optional

- (void)motorcadeManager:(CXMotorcadeManager *)motorcadeManager handleSchemeEvent:(CXSchemeEvent *)event;
- (void)motorcadeManager:(CXMotorcadeManager *)motorcadeManager tokenInvalidWithMsg:(NSString *)msg;
- (void)motorcadeManager:(CXMotorcadeManager *)motorcadeManager forceUpdateAppWithMsg:(NSString *)msg downloadURL:(NSString *)URL;

@end

@interface CXMotorcadeManager : NSObject {
    NSString *_activeMotorcadeId;
}

@property (nonatomic, weak) id<CXMotorcadeManagerDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, strong, readonly) CXMotorcadeLoginUserInfo *userInfo;
@property (nonatomic, copy, readonly) NSString *baseURL;
@property (nonatomic, copy, readonly) NSString *activeMotorcadeId;

+ (CXMotorcadeManager *)sharedManager;

- (void)setLoginUserInfo:(CXMotorcadeLoginUserInfo *)userInfo
                   token:(NSString *)token
              forEnvType:(CXNetEnvType)envType;

- (BOOL)canHandleSchemeEvent:(CXSchemeEvent *)event;
- (void)handleSchemeEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController;

@end

@interface CXMotorcadeLoginUserInfo : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, assign) CXUserSexType sex;

@end
