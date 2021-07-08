//
//  CXMotorcadeOnlineModel.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXBaseMotorcadeModel.h"
#import "CXMotorcadeDestinationModel.h"
#import "CXMotorcadeUserListModel.h"

@class CXMotorcadeOnlineResultModel;

@interface CXMotorcadeOnlineModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotorcadeOnlineResultModel *result;

@end

@class CXMotorcadeOnlineInfoModel;
@class CXMotorcadeUserModel;

@interface CXMotorcadeOnlineResultModel : NSObject

@property (nonatomic, copy) NSArray<CXMotorcadeUserInfoModel *> *data;
@property (nonatomic, strong) CXMotorcadeOnlineInfoModel *motorcadeInfo;
@property (nonatomic, assign) BOOL ownMicPermission; // 自己的麦克风权限 0-没有麦克风权限，1-有麦克风权限

- (BOOL)shouldShowAddressView;
- (BOOL)isCaptain; // 自己是否队长

@end

@interface CXMotorcadeOnlineInfoModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imMotorcadeId;
@property (nonatomic, assign) NSInteger groupChat; // CXMotorcadeVoiceMode
@property (nonatomic, assign) NSInteger type; // CXMotorcadeType
@property (nonatomic, assign) NSInteger roomNo;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL allMotorcadePermission;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, strong, readonly) CXMotorcadeDestinationModel *destModel;

@end
