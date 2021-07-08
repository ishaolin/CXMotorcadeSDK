//
//  CXMotorcadeMicManageMemberCell.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import <CXSettingKit/CXSettingKit.h>

@interface CXMotorcadeMicManageMemberCell : CXSettingRightSwitchCell

@property (nonatomic, assign, getter = isAllMemberMicDisabled) BOOL allMemberMicDisabled;
@property (nonatomic, copy) NSString *motorcadeId;

@end
