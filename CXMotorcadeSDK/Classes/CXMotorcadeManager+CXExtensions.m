//
//  CXMotorcadeManager+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2019/3/27.
//

#import "CXMotorcadeManager+CXExtensions.h"
#import "CXMotorcadeOnlineModel.h"
#import <CXSocketSDK/CXSocketSDK.h>

@implementation CXMotorcadeManager (CXExtensions)

- (void)notifyDelegateHandleSchemeEvent:(CXSchemeEvent *)event{
    if([self.delegate respondsToSelector:@selector(motorcadeManager:handleSchemeEvent:)]){
        [self.delegate motorcadeManager:self handleSchemeEvent:event];
    }
}

- (void)notifyDelegateTokenInvalid:(NSString *)msg{
    if([self.delegate respondsToSelector:@selector(motorcadeManager:tokenInvalidWithMsg:)]){
        [self.delegate motorcadeManager:self tokenInvalidWithMsg:msg];
    }
}

- (void)notifyDelegateForceUpdateApp:(NSString *)msg downloadURL:(NSString *)URL{
    if([self.delegate respondsToSelector:@selector(motorcadeManager:forceUpdateAppWithMsg:downloadURL:)]){
        [self.delegate motorcadeManager:self forceUpdateAppWithMsg:msg downloadURL:URL];
    }
}

+ (void)enterMotorcadePage:(CXMotorcadeOnlineResultModel *)onlineModel{
    [self enterMotorcadePage:onlineModel enterType:CXSchemePushFromCurrentVC];
}

+ (void)enterMotorcadePage:(CXMotorcadeOnlineResultModel *)onlineModel enterType:(CXSchemePushType)enterType{
    if(!onlineModel){
        return;
    }
    
    [self sharedManager]->_activeMotorcadeId = onlineModel.motorcadeInfo.id;
    CXSchemeEvent *event = [[CXSchemeEvent alloc] initWithModule:CXSchemeBusinessModulePhoenix
                                                            page:CXSchemePageMotorcadeMain
                                                      completion:nil];
    event.pushType = enterType;
    [event addParam:onlineModel forKey:CM_SCHEME_PK_MOTORCADE_DATA];
    [[self sharedManager] notifyDelegateHandleSchemeEvent:event];
}

+ (void)goBackToMotorcadePage{
    UIViewController *viewController = [self motorcadeViewController:nil];
    if(!viewController){
        return;
    }
    
    [viewController.navigationController popToViewController:viewController animated:YES];
}

+ (void)quitMotorcadePage{
    NSUInteger index = 0;
    UIViewController *viewController = [self motorcadeViewController:&index];
    if(!viewController || index == 0){
        return;
    }
    
    viewController = viewController.navigationController.viewControllers[index - 1];
    [viewController.navigationController popToViewController:viewController animated:YES];
    [self sharedManager]->_activeMotorcadeId = nil;
}

+ (UIViewController *)motorcadeViewController:(NSUInteger *)index{
    UIViewController *VC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *navigationController = nil;
    if([VC isKindOfClass:[UINavigationController class]]){
        navigationController = (UINavigationController *)VC;
    }else if([VC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController *)VC;
        if([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]){
            navigationController = (UINavigationController *)tabBarController.selectedViewController;
        }
    }
    
    if(!navigationController){
        return nil;
    }
    
    __block UIViewController *targetVC = nil;
    __block NSUInteger _index = NSNotFound;
    [navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXSchemeBusinessPage page = [[CXSchemeRegistrar sharedRegistrar] businessPageForModule:CXSchemeBusinessModulePhoenix class:obj.class];
        if([page isEqualToString:CXSchemePageMotorcadeMain] ||
           [page isEqualToString:CXSchemePageTalkbackModeMotorcade]){
            targetVC = obj;
            _index = idx;
            *stop = YES;
        }
    }];
    
    if(index){
        *index = _index;
    }
    
    return targetVC;
}

+ (void)removeMotorcadeId:(NSString *)motorcadeId{
    if(CXStringIsEmpty(motorcadeId)){
        return;
    }
    
    if([motorcadeId isEqualToString:[self sharedManager].activeMotorcadeId]){
        [self sharedManager]->_activeMotorcadeId = nil;
    }
}

+ (void)setUpdateActiveMotorcadeOnlineCount:(NSUInteger)count{
    if(count > 20){
        [CXCoordinateSocketUploader sharedUploader].timeInterval = 30.0;
    }else{
        [CXCoordinateSocketUploader sharedUploader].timeInterval = 2.0;
    }
}

@end
