//
//  CXMotorcadeUserListModel.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXBaseMotorcadeModel.h"
#import "CXBaseUserJSONModel.h"
#import "CXMotorcadeDefines.h"
#import "CXUserSexType.h"

@class CXMotorcadeUserListResultModel;
@class CXMotorcadeUserInfoModel;

@interface CXMotorcadeUserListModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotorcadeUserListResultModel *result;

@end

@interface CXMotorcadeUserListResultModel : NSObject

@property (nonatomic, copy) NSArray<CXMotorcadeUserInfoModel *> *data;

@end

@interface CXMotorcadeUserInfoModel : CXBaseUserJSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headUrl;

@property (nonatomic, assign) NSInteger onLineStatus;  // CXMotorcadeOnlineState
@property (nonatomic, assign) NSInteger type;          // CXMotorcadeMemberType
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) NSInteger sex;           // CXUserSexType
@property (nonatomic, assign) BOOL micPermission;      // 麦克风权限

@property (nonatomic, assign) double distance;        // 目的地距离
@property (nonatomic, assign) double memberDistance;  // 自己与选中队友之前的距离
@property (nonatomic, assign) BOOL selected;

@end
