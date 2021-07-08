//
//  CXMotorcadeRequestUtils.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeRequestUtils.h"
#import "CXCreateMotorcadeRequest.h"
#import "CXMotrocadeOnlineRequest.h"
#import "CXCmdEnterMotorcadeRequest.h"
#import "CXEnterMotorcadeRequest.h"
#import "CXUpdateMotorcadeInfoRequest.h"
#import <CXMapKit/CXMapPOIModel.h>
#import "CXMotorcadeNotificationName.h"

@implementation CXMotorcadeRequestUtils

+ (void)createMotorcadeWithVoiceMode:(CXMotorcadeVoiceMode)voiceMode completion:(CXMotorcadeOnlineInfoCompletionBlock)completion{
    CXCreateMotorcadeRequest *request = [[CXCreateMotorcadeRequest alloc] initWithVoiceMode:@(voiceMode)];
    [self loadMotorcadeInfoRequest:request completion:completion];
}

+ (void)onlineMotorcadeWithId:(NSString *)id completion:(CXMotorcadeOnlineInfoCompletionBlock)completion{
    CXMotrocadeOnlineRequest *request = [[CXMotrocadeOnlineRequest alloc] initWithMotorcadeId:id];
    [self loadMotorcadeInfoRequest:request completion:completion];
}

+ (void)enterMotorcadeWithCommand:(NSString *)command completion:(CXMotorcadeOnlineInfoCompletionBlock)completion{
    CXCmdEnterMotorcadeRequest *request = [[CXCmdEnterMotorcadeRequest alloc] initWithCommand:command];
    [self loadMotorcadeInfoRequest:request completion:completion];
}

+ (void)enterMotorcadeWithId:(NSString *)id completion:(CXMotorcadeOnlineInfoCompletionBlock)completion{
    CXEnterMotorcadeRequest *request = [[CXEnterMotorcadeRequest alloc] initWithMotorcadeId:id];
    [self loadMotorcadeInfoRequest:request completion:completion];
}

+ (void)loadMotorcadeInfoRequest:(CXBaseMotorcadeURLRequest *)request
                      completion:(CXMotorcadeOnlineInfoCompletionBlock)completion{
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXMotorcadeOnlineModel *onlineModel = (CXMotorcadeOnlineModel *)data;
        !completion ?: completion(onlineModel, nil);
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        !completion ?: completion(nil, error);
    }];
}

+ (void)setDestinationWithPOIModel:(CXMapPOIModel *)POIModel motorcadeId:(NSString *)motorcadeId completion:(void (^)(NSString *))completion{
    NSDictionary<NSString *, id> *dictionary = @{@"destinationName" : CXJSONValidValue(POIModel.name),
                                                 @"mclatitude" : @(POIModel.coordinate.latitude),
                                                 @"mclongitude" : @(POIModel.coordinate.longitude)};
    NSString *destinationJSON = [NSJSONSerialization cx_stringWithJSONObject:dictionary];
    NSMutableDictionary<NSString *, id> *motorcadeInfo = [NSMutableDictionary dictionary];
    [motorcadeInfo cx_setString:destinationJSON forKey:@"destination"];
    [motorcadeInfo cx_setString:motorcadeId forKey:@"id"];
    [CXHUD showHUD];
    CXUpdateMotorcadeInfoRequest *request = [[CXUpdateMotorcadeInfoRequest alloc] initWithMotorcadeInfo:[motorcadeInfo copy]];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseModel *model = (CXBaseModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            [NSNotificationCenter notify:CXMotorcadeDestinationChangedNotification userInfo:@{CXNotificationUserInfoKey0 : destinationJSON}];
            !completion ?: completion(destinationJSON);
        }else{
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD showMsg:error.HUDMsg];
    }];
}

@end
