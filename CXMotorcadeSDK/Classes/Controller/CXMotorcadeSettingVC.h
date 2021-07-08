//
//  CXMotorcadeSettingVC.h
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import <CXSettingKit/CXSettingKit.h>

@class CXMotorcadeSettingVC;
@class CXMotorcadeOnlineInfoModel;

@protocol CXMotorcadeSettingVCDelegate <NSObject>

@optional

- (void)motorcadeSettingVCDidQuitOrDissolveMotorcade:(CXMotorcadeSettingVC *)settingVC;

@end

@interface CXMotorcadeSettingVC : CXSettingViewController

@property (nonatomic, weak) id<CXMotorcadeSettingVCDelegate> delegate;

- (instancetype)initWithMotorcadeModel:(CXMotorcadeOnlineInfoModel *)motorcadeModel
                             isCaptain:(BOOL)isCaptain;

@end
