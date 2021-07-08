//
//  CXMotorcadeMicListModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXBaseMotorcadeModel.h"

@class CXMotorcadeMicListResultModel;
@class CXMotorcadeMicUserInfoModel;

@interface CXMotorcadeMicListModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotorcadeMicListResultModel *result;

@end

@interface CXMotorcadeMicListResultModel : NSObject

@property (nonatomic, assign) BOOL allMicPermission;

@property (nonatomic, copy) NSArray<CXMotorcadeMicUserInfoModel *> *userInfoList;

@end

@interface CXMotorcadeMicUserInfoModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, assign) NSInteger onLineStatus;
@property (nonatomic, assign) BOOL micPermission;

@end
