//
//  CXMainMemberListCell.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeDefines.h"

@class CXMotorcadeUserInfoModel;

@interface CXMainMemberListCell : UICollectionViewCell

@property (nonatomic, strong) CXMotorcadeUserInfoModel *memberModel;
@property (nonatomic, assign, getter = isAllMicDisabled) BOOL allMicDisabled;
@property (nonatomic, assign) CXMotorcadeVoiceMode voiceMode;

+ (NSString *)reuseIdentifier;

@end
