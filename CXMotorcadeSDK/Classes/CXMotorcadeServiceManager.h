//
//  CXMotorcadeServiceManager.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeMemberToolbar.h"
#import "CXMotorcadeServiceManagerDelegate.h"

@class CXBaseViewController;

@interface CXMotorcadeServiceManager : NSObject

@property (nonatomic, strong) CXMotorcadeOnlineResultModel *onlineModel;
@property (nonatomic, weak) id<CXMotorcadeServiceManagerDelegate> delegate;
@property (nonatomic, assign, readonly) CGRect toolbarFrame;
@property (nonatomic, assign, readonly) BOOL toolbarClosed;

- (instancetype)initWithViewController:(CXBaseViewController *)viewController
                           onlineModel:(CXMotorcadeOnlineResultModel *)onlineModel;

- (void)viewDidLoad;

- (void)startPolling;
- (void)stopPolling;
- (void)pollingAction;

- (void)quitMotorcade:(NSString *)msg completion:(void (^)(void))completion;
- (void)sendOfflineRequest;

- (void)reloadMembers;
- (void)reloadMemberAtIndexPath:(NSIndexPath *)indexPath;

- (void)setToolbarClose:(BOOL)close animated:(BOOL)animated;

@end
