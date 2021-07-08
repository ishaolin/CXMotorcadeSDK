//
//  CXMotrocadePollingModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeUserListModel.h"

@class CXMotrocadePollingResultModel;

@interface CXMotrocadePollingModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotrocadePollingResultModel *result;

@end

@interface CXMotrocadePollingResultModel : NSObject

@property (nonatomic, copy) NSArray<CXMotorcadeUserInfoModel *> *data;
@property (nonatomic, copy) NSString *motorcadeId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger roomNo;
@property (nonatomic, assign) double remainingTime;
@property (nonatomic, assign) double createTime;
@property (nonatomic, assign) NSInteger groupChat;
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL ownMicPermission;
@property (nonatomic, assign) BOOL allMicPermission;
@property (nonatomic, copy) NSString *micMsg;

@end
