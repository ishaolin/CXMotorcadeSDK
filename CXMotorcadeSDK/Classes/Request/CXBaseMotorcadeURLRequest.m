//
//  CXBaseMotorcadeURLRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/27.
//

#import "CXBaseMotorcadeURLRequest.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMotorcadeManager+CXExtensions.h"
#import "CXBaseMotorcadeModel.h"
#import "CXMotorcadeCommonParams.h"

@implementation CXBaseMotorcadeURLRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId{
    if(self = [super init]){
        [self addParam:motorcadeId forKey:@"motorcadeId"];
    }
    
    return self;
}

- (NSString *)baseURL{
    return [CXMotorcadeManager sharedManager].baseURL;
}

- (void)loadRequestWithSuccess:(CXBaseURLRequestSuccessBlock)successBlock
                       failure:(CXBaseURLRequestFailureBlock)failureBlock{
    [super loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXBaseMotorcadeModel *model = (CXBaseMotorcadeModel *)data;
        if(model.code == 120033){ // token失效
            [CXHUD dismiss];
            [[CXMotorcadeManager sharedManager] notifyDelegateTokenInvalid:model.msg];
        }else if(model.code == 129900){ // 需要强制更新
            [CXHUD dismiss];
            [[CXMotorcadeManager sharedManager] notifyDelegateForceUpdateApp:model.msg downloadURL:nil];
        }else{
            !successBlock ?: successBlock(dataTask, model);
        }
    } failure:failureBlock];
}

- (id)modelWithData:(id)data{
    return [CXBaseMotorcadeModel cx_modelWithData:data];
}

- (NSDictionary<NSString *,id> *)commonParams{
    return [[CXMotorcadeCommonParams commonParams] copy];
}

@end
