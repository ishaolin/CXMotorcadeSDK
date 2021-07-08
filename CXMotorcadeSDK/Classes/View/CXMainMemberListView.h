//
//  CXMainMemberListView.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeDefines.h"

@class CXMotorcadeUserInfoModel;
@class CXMainMemberListView;

@protocol CXMainMemberListViewDelegate <NSObject>

@optional

- (void)memberListView:(CXMainMemberListView *)listView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)memberListViewDidInviteAction:(CXMainMemberListView *)listView;

@end

@protocol CXMainMemberListViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemsInMemberListView:(CXMainMemberListView *)listView;

- (CXMotorcadeUserInfoModel *)memberListView:(CXMainMemberListView *)listView modelForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CXMainMemberListView : UIView

@property (nonatomic, weak) id<CXMainMemberListViewDelegate> delegate;
@property (nonatomic, weak) id<CXMainMemberListViewDataSource> dataSource;

@property (nonatomic, assign, getter = isAllMicDisabled) BOOL allMicDisabled;
@property (nonatomic, assign) CXMotorcadeVoiceMode voiceMode;

- (void)reloadData;
- (void)reloadDataAtIndexPath:(NSIndexPath *)indexPath;

@end
