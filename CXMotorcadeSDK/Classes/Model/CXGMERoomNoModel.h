//
//  CXGMERoomNoModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import "CXBaseMotorcadeModel.h"

@class CXGMERoomNoResultModel;

@interface CXGMERoomNoModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXGMERoomNoResultModel *result;

@end

@interface CXGMERoomNoResultModel : NSObject

@property (nonatomic, assign) NSInteger roomNo;
@property (nonatomic, assign) long remainingTime;

@end
