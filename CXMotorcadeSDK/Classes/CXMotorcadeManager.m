//
//  CXMotorcadeManager.m
//  Pods
//
//  Created by wshaolin on 2019/3/27.
//

#import "CXMotorcadeManager.h"
#import "CXMotorcadeSchemeRegistrar.h"
#import "CXMotorcadeRequestUtils.h"
#import <CXMapKit/CXPOICacheUtils.h>
#import <CXVoiceSDK/CXVoiceSDK.h>

@implementation CXMotorcadeManager

+ (CXMotorcadeManager *)sharedManager{
    static CXMotorcadeManager *motorcadeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motorcadeManager = [[CXMotorcadeManager alloc] init];
    });
    
    return motorcadeManager;
}

- (void)setLoginUserInfo:(CXMotorcadeLoginUserInfo *)userInfo
                   token:(NSString *)token
              forEnvType:(CXNetEnvType)envType{
    _userInfo = userInfo;
    _token = token;
    CXPOICacheUtils.dataOwnerId = userInfo.userId;
    
    if(!CXStringIsEmpty(userInfo.userId)){
        [[CXVoiceManager sharedManager] setAppId:@"1400119411"
                                         authKey:@"hWpvEmTaPaFjQdO3"
                                          userId:userInfo.userId
                                    logDirectory:nil];
    }
    
    switch (envType) {
        case CXNetEnvOL:{
            _baseURL = @"https://api.zhidaohulian.com";
        }
            break;
        case CXNetEnvQA:{
            _baseURL = @"http://carlife-test.zhidaohulian.com";
        }
            break;
        case CXNetEnvRD:{
            _baseURL = @"http://carlife-dev.zhidaohulian.com";
        }
            break;
        default:
            break;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [CXMotorcadeSchemeRegistrar registerSupportiveClass];
    });
}

- (NSString *)activeMotorcadeId{
    return _activeMotorcadeId;
}

- (BOOL)canHandleSchemeEvent:(CXSchemeEvent *)event{
    if([event.page isEqualToString:CXSchemePageJoinMotorcade] ||
       [event.page isEqualToString:CXSchemePageMotorcadeMain] ||
       [event.page isEqualToString:CXSchemePageMotorcadeList] ||
       [event.page isEqualToString:CXSchemePageCreadMotorcade] ||
       [event.page isEqualToString:CXSchemePageTalkbackModeMotorcade]){
        return YES;
    }
    
    return NO;
}

- (void)handleSchemeEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController{
    if([event.page isEqualToString:CXSchemePageJoinMotorcade]){
        [self _handleJoinMotorcadeSchemeEvent:event navigationController:navigationController];
    }else if([event.page isEqualToString:CXSchemePageMotorcadeMain]){
        CXMotorcadeOnlineResultModel *onlineModel = [event.params cx_objectForKey:CM_SCHEME_PK_MOTORCADE_DATA];
        if(onlineModel){
            if(onlineModel.motorcadeInfo.groupChat == CXMotorcadeTalkbackVoice){
                event.page = CXSchemePageTalkbackModeMotorcade;
            }
            [self _handleSchemeEvent:event navigationController:navigationController];
        }else{
            [self _handleOnlineMotorcadeSchemeEvent:event navigationController:navigationController];
        }
    }else{
        [self _handleSchemeEvent:event navigationController:navigationController];
    }
}

- (void)_handleJoinMotorcadeSchemeEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController{
    [CXHUD showHUD];
    [CXMotorcadeRequestUtils enterMotorcadeWithCommand:[event.params cx_stringForKey:CM_SCHEME_PK_MOTORCADE_CMD] completion:^(CXMotorcadeOnlineModel *onlineModel, NSError *error) {
        if(onlineModel.isValid){
            [CXHUD dismiss];
            if(onlineModel.result){
                event.page = CXSchemePageMotorcadeMain;
                [event addParam:onlineModel.result forKey:CM_SCHEME_PK_MOTORCADE_DATA];
                [self handleSchemeEvent:event navigationController:navigationController];
            }else{
                NSString *msg = @"加载数据失败";
                [CXHUD showMsg:msg];
                [event finishEventWithError:msg];
            }
        }else if(onlineModel.code == 109610){ // 已在小队中，调用上线接口
            [self _handleOnlineMotorcadeSchemeEvent:event navigationController:navigationController];
        }else{
            NSString *msg = onlineModel.msg ?: error.HUDMsg;
            [CXHUD showMsg:msg];
            [event finishEventWithError:msg];
        }
    }];
}

- (void)_handleOnlineMotorcadeSchemeEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController{
    [CXHUD showHUD];
    [CXMotorcadeRequestUtils onlineMotorcadeWithId:[event.params cx_stringForKey:CM_SCHEME_PK_MOTORCADE_ID] completion:^(CXMotorcadeOnlineModel *onlineModel, NSError *error) {
        if(onlineModel.isValid){
            if(onlineModel.result){
                [CXHUD dismiss];
                event.page = CXSchemePageMotorcadeMain;
                [event addParam:onlineModel.result forKey:CM_SCHEME_PK_MOTORCADE_DATA];
                [self handleSchemeEvent:event navigationController:navigationController];
            }else{
                NSString *msg = @"加载数据失败";
                [CXHUD showMsg:msg];
                [event finishEventWithError:msg];
            }
        }else{
            NSString *msg = onlineModel.msg ?: error.HUDMsg;
            [CXHUD showMsg:msg];
            [event finishEventWithError:msg];
        }
    }];
}

- (void)_handleSchemeEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController{
    [CXSchemeHandler handleSchemeEvent:event navigationController:navigationController pushVCBlock:^(CXSchemeEvent *event, UINavigationController *navigationVC, UIViewController *targetVC) {
        if([event.page isEqualToString:CXSchemePageMotorcadeMain] ||
           [event.page isEqualToString:CXSchemePageTalkbackModeMotorcade]){
            NSUInteger index = [self _indexWithEvent:event navigationController:navigationController];
            if(index > 0 && index != NSNotFound){
                NSMutableArray<UIViewController *> *viewControllers = [[navigationController.viewControllers subarrayWithRange:NSMakeRange(0, index)] mutableCopy];
                [viewControllers addObject:targetVC];
                [navigationController cx_setViewControllers:[viewControllers copy] animated:YES];
                return;
            }
        }
        
        [navigationController cx_pushViewController:targetVC pushType:event.pushType animated:YES];
    }];
}

- (NSUInteger)_indexWithEvent:(CXSchemeEvent *)event navigationController:(UINavigationController *)navigationController{
    if(event.pushType == CXSchemePushFromRootVC){
        return NSNotFound;
    }
    
    __block NSUInteger index1 = NSNotFound;
    if([event.page isEqualToString:CXSchemePageMotorcadeMain]){
        // 当前目标小队是实时语音模式，检查是否存在对讲模式的小队。如果存在，则需要退出对讲小队，再进入实时语音小队
        [navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXSchemeBusinessPage page = [[CXSchemeRegistrar sharedRegistrar] businessPageForModule:CXSchemeBusinessModulePhoenix class:obj.class];
            if([page isEqualToString:CXSchemePageTalkbackModeMotorcade]){
                index1 = idx;
                *stop = YES;
            }
        }];
    }else{
        // 当前目标小队是对讲模式，检查是否存在实时语音模式的小队。如果存在，则需要退出实时语音小队，再进入对讲模式小队
        [navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXSchemeBusinessPage page = [[CXSchemeRegistrar sharedRegistrar] businessPageForModule:CXSchemeBusinessModulePhoenix class:obj.class];
            if([page isEqualToString:CXSchemePageMotorcadeMain]){
                index1 = idx;
                *stop = YES;
            }
        }];
    }
    
    __block NSUInteger index2 = NSNotFound;
    [navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:NSClassFromString(@"CXRouteViewController")] ||
           [obj isKindOfClass:NSClassFromString(@"CXMapNaviViewController")]){
            index2 = idx;
            *stop = YES;
        }
    }];
    
    return MIN(index1, index2);
}

@end

@implementation CXMotorcadeLoginUserInfo

@end
