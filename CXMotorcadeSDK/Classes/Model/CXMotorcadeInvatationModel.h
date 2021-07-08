//
//  CXMotorcadeInvatationModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXBaseMotorcadeModel.h"

@class CXMotorcadeInvatationResultModel;

@interface CXMotorcadeInvatationModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXMotorcadeInvatationResultModel *result;

@end

@interface CXMotorcadeInvatationResultModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *motorcadeName;
@property (nonatomic, assign) NSInteger groupChat;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *content;

@end
