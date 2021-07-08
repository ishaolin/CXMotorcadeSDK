//
//  CXMotorcadeListModel.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXBaseMotorcadeModel.h"
#import "CXMotorcadeDefines.h"

@class CXMotorcadeListResultModel;
@class CXMotorcadeListDataModel;

@interface CXMotorcadeListModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotorcadeListResultModel *result;

@end

@interface CXMotorcadeListResultModel : NSObject

@property (nonatomic, copy) NSArray<CXMotorcadeListDataModel *> *data;

@end

@interface CXMotorcadeListDataModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSArray<NSString *> *headUrlList;
@property (nonatomic, assign) NSInteger onLineStatus; // CXMotorcadeOnlineState
@property (nonatomic, assign) NSInteger groupChat;  // CXMotorcadeVoiceMode
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger type; // CXMotorcadeType
@property (nonatomic, assign) NSInteger captain;  // CXMotorcadeMemberType

@end
