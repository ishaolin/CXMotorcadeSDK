//
//  CXContactListEmptyView.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import <CXUIKit/CXUIKit.h>

@class CXContactListEmptyView;

@protocol CXContactListEmptyViewDelegate <NSObject>

@optional

- (void)contactListEmptyViewDidFetchAction:(CXContactListEmptyView *)emptyView;

@end

@interface CXContactListEmptyView : UIView

@property (nonatomic, weak) id<CXContactListEmptyViewDelegate> delegate;
@property (nonatomic, assign, getter = isAuthorized) BOOL authorized;

@end
