//
//  CXMotorcadeMemberToolbar.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeDefines.h"

@class CXMotorcadeMemberToolbar;
@class CXMotorcadeUserInfoModel;

@protocol CXMotorcadeMemberToolbarDelegate <NSObject>

@optional

- (void)memberToolbarDidGoToNavgationAction:(CXMotorcadeMemberToolbar *)toolbar;
- (void)memberToolbarDidSetDestinationAction:(CXMotorcadeMemberToolbar *)toolbar;
- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)memberToolbarDidInviteAction:(CXMotorcadeMemberToolbar *)toolbar;
- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar animationFrame:(CGRect)frame forClose:(BOOL)close;
- (void)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar didChangeFrameHeight:(CGFloat)frameHeight offsetHeight:(CGFloat)offsetHeight;

@end

@protocol CXMotorcadeMemberToolbarDataSource <NSObject>

@required

- (NSInteger)numberOfMembersInMemberToolbar:(CXMotorcadeMemberToolbar *)toolbar;
- (CXMotorcadeUserInfoModel *)memberToolbar:(CXMotorcadeMemberToolbar *)toolbar modelForMemberAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CXMotorcadeMemberToolbar : UIView

@property (nonatomic, weak) id<CXMotorcadeMemberToolbarDelegate> delegate;
@property (nonatomic, weak) id<CXMotorcadeMemberToolbarDataSource> dataSource;

@property (nonatomic, assign, getter = isAllMicDisabled) BOOL allMicDisabled;
@property (nonatomic, assign, getter = isDestinationViewHidden) BOOL destinationViewHidden;
@property (nonatomic, assign) CXMotorcadeVoiceMode voiceMode;
@property (nonatomic, assign) CGFloat displayingFrameY;
@property (nonatomic, assign, readonly) BOOL isClosed;

- (void)setClose:(BOOL)close animated:(BOOL)animated;
- (void)setDestinationName:(NSString *)destinationName;

- (void)reloadMembers;
- (void)reloadMemberAtIndexPath:(NSIndexPath *)indexPath;

@end
