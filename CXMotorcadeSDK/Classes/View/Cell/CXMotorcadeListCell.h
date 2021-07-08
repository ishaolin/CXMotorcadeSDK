//
//  CXMotorcadeListCell.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import <CXUIKit/CXUIKit.h>

@class CXMotorcadeListDataModel;

@interface CXMotorcadeListCell : CXTableViewCell

@property (nonatomic, strong) CXMotorcadeListDataModel *dataModel;

@end
