//
//  CXMotorcadeMemberToolbar.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeMemberToolbar.h"
#import "CXMotorcadeDestinationView.h"
#import "CXMainMemberListView.h"

@interface CXMotorcadeMemberToolbar () <CXMainMemberListViewDataSource, CXMainMemberListViewDelegate, CXMotorcadeDestinationViewDelegate> {
    CXMotorcadeDestinationView *_destinationView;
    CXMainMemberListView *_memberListView;
}

@end

@implementation CXMotorcadeMemberToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _destinationView = [[CXMotorcadeDestinationView alloc] init];
        _destinationView.delegate = self;
        
        _memberListView = [[CXMainMemberListView alloc] init];
        _memberListView.delegate = self;
        _memberListView.dataSource = self;
        
        [self addSubview:_destinationView];
        [self addSubview:_memberListView];
    }
    
    return self;
}

- (void)setAllMicDisabled:(BOOL)allMicDisabled{
    _memberListView.allMicDisabled = allMicDisabled;
}

- (BOOL)isAllMicDisabled{
    return _memberListView.isAllMicDisabled;
}

- (void)setDestinationViewHidden:(BOOL)destinationViewHidden{
    _destinationView.hidden = destinationViewHidden;
}

- (BOOL)isDestinationViewHidden{
    return _destinationView.isHidden;
}

- (void)setVoiceMode:(CXMotorcadeVoiceMode)voiceMode{
    _memberListView.voiceMode = voiceMode;
}

- (CXMotorcadeVoiceMode)voiceMode{
    return _memberListView.voiceMode;
}

- (void)destinationViewDidGoToNavgationAction:(CXMotorcadeDestinationView *)destinationView{
    if([self.delegate respondsToSelector:@selector(memberToolbarDidGoToNavgationAction:)]){
        [self.delegate memberToolbarDidGoToNavgationAction:self];
    }
}

- (void)destinationViewDidSetDestinationAction:(CXMotorcadeDestinationView *)destinationView {
    if([self.delegate respondsToSelector:@selector(memberToolbarDidSetDestinationAction:)]){
        [self.delegate memberToolbarDidSetDestinationAction:self];
    }
}

- (void)memberListViewDidInviteAction:(CXMainMemberListView *)listView{
    if([self.delegate respondsToSelector:@selector(memberToolbarDidInviteAction:)]){
        [self.delegate memberToolbarDidInviteAction:self];
    }
}

- (void)memberListView:(CXMainMemberListView *)listView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(memberToolbar:didSelectItemAtIndexPath:)]){
        [self.delegate memberToolbar:self didSelectItemAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfItemsInMemberListView:(CXMainMemberListView *)listView{
    return [self.dataSource numberOfMembersInMemberToolbar:self];
}

- (CXMotorcadeUserInfoModel *)memberListView:(CXMainMemberListView *)listView modelForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource memberToolbar:self modelForMemberAtIndexPath:indexPath];
}

- (void)setClose:(BOOL)close animated:(BOOL)animated{
    if(!self.superview || _isClosed == close){
        return;
    }
    
    _isClosed = close;
    CGRect frame = self.frame;
    if(close){
        _displayingFrameY = CGRectGetMinY(frame);
        frame.origin.y -= frame.size.height;
    }else{
        frame.origin.y = _displayingFrameY;
        _displayingFrameY = 0;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        [super setFrame:frame];
        
        if([self.delegate respondsToSelector:@selector(memberToolbar:animationFrame:forClose:)]){
            [self.delegate memberToolbar:self animationFrame:frame forClose:self->_isClosed];
        }
    }];
}

- (void)setFrame:(CGRect)frame{
    CGFloat offsetHeight = CGRectGetHeight(frame) - CGRectGetHeight(self.frame);
    [super setFrame:frame];
    
    if(offsetHeight == 0){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(memberToolbar:didChangeFrameHeight:offsetHeight:)]){
        [self.delegate memberToolbar:self didChangeFrameHeight:CGRectGetHeight(frame) offsetHeight:offsetHeight];
    }
}

- (void)setDestinationName:(NSString *)destinationName{
    _destinationView.destination = destinationName;
}

- (void)reloadMembers{
    [_memberListView reloadData];
}

- (void)reloadMemberAtIndexPath:(NSIndexPath *)indexPath{
    [_memberListView reloadDataAtIndexPath:indexPath];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat destinationView_X = 0;
    CGFloat destinationView_Y = 0;
    CGFloat destinationView_W = CGRectGetWidth(self.bounds);
    CGFloat destinationView_H = 45.0;
    _destinationView.frame = (CGRect){destinationView_X, destinationView_Y, destinationView_W, destinationView_H};
    
    CGFloat memberListView_X = 0;
    CGFloat memberListView_W = CGRectGetWidth(self.bounds);
    CGFloat memberListView_H = 95.0;
    CGFloat memberListView_Y = CGRectGetHeight(self.bounds) - memberListView_H;
    _memberListView.frame = (CGRect){memberListView_X, memberListView_Y, memberListView_W, memberListView_H};
}

@end
