//
//  CXMotorcadeOnlineModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeOnlineModel.h"

@implementation CXMotorcadeOnlineModel

@end

@interface CXMotorcadeOnlineResultModel () {
    NSNumber *_isCaptain;
}

@end

@implementation CXMotorcadeOnlineResultModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [CXMotorcadeUserInfoModel class]};
}

- (BOOL)shouldShowAddressView{
    if(self.motorcadeInfo.groupChat == CXMotorcadeTalkbackVoice){
        return NO;
    }
    
    if(self.motorcadeInfo.type == CXMotorcadeOfficial){
        return NO;
    }
    
    return YES;
}

- (BOOL)isCaptain{
    if(_isCaptain != nil){
        return _isCaptain.boolValue;
    }
    
    __block CXMotorcadeUserInfoModel *model = nil;
    [self.data enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isSelf]){
            model = obj;
            *stop = YES;
        }
    }];
    
    _isCaptain = @(model.type == CXMotorcadeMemberCaptain);
    return _isCaptain.boolValue;
}

@end

@implementation CXMotorcadeOnlineInfoModel

- (void)setDestination:(NSString *)destination{
    _destination = destination;
    _destModel = [CXMotorcadeDestinationModel cx_modelWithData:_destination];
}

@end
