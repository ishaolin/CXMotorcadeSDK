//
//  CXMainMemberListView.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMainMemberListView.h"
#import "CXMainMemberListCell.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMainMemberListCell.h"
#import "CXMotorcadeDefines.h"

static NSString *CX_MAIN_MEMBER_LIST_VIEW_ITEM_RID = @"CXMainMemberListCell";

@interface CXMainMemberListView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    UIButton *_inviteButton;
    UIImageView *_inviteImageView;
    UIView *_lineView;
}

@end

@implementation CXMainMemberListView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(65.0, 65.0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 8.0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [_collectionView registerClass:[CXMainMemberListCell class] forCellWithReuseIdentifier:[CXMainMemberListCell reuseIdentifier]];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_invitation_add") forState:UIControlStateNormal];
        [_inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
        [_inviteButton.titleLabel setFont:CX_PingFangSC_RegularFont(10.0)];
        [_inviteButton setTitleColor:CXHexIColor(0x999999) forState:UIControlStateNormal];
        [_inviteButton addTarget:self action:@selector(actionForInvite:) forControlEvents:UIControlEventTouchUpInside];
        
        _inviteImageView = [[UIImageView alloc] init];
        _inviteImageView.image = CX_MOTORCADE_IMAGE(@"motorcade_invitation_blind");
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0xF0F0F0);
        
        [self addSubview:_collectionView];
        [self addSubview:_inviteImageView];
        [self addSubview:_inviteButton];
        [self addSubview:_lineView];
    }
    
    return self;
}

- (void)reloadDataAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath){
        return;
    }
    
    if(indexPath.item < [self.dataSource numberOfItemsInMemberListView:self]){
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)reloadData{
    CGPoint contentOffset = _collectionView.contentOffset;
    [_collectionView reloadData];
    
    if(contentOffset.x < _collectionView.contentSize.width){
        [_collectionView setContentOffset:contentOffset animated:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInMemberListView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CXMainMemberListCell *cell = (CXMainMemberListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[CXMainMemberListCell reuseIdentifier] forIndexPath:indexPath];
    cell.allMicDisabled = self.isAllMicDisabled;
    cell.voiceMode = self.voiceMode;
    cell.memberModel = [self.dataSource memberListView:self modelForItemAtIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(memberListView:didSelectItemAtIndexPath:)]){
        [self.delegate memberListView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)actionForInvite:(UIButton *)inviteButton {
    if([self.delegate respondsToSelector:@selector(memberListViewDidInviteAction:)]){
        [self.delegate memberListViewDidInviteAction:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat inviteButton_H = 45.0;
    CGFloat inviteButton_W = 45.0;
    CGFloat inviteButton_X = CGRectGetWidth(self.bounds) - inviteButton_W - 12.0;
    CGFloat inviteButton_Y = (CGRectGetHeight(self.bounds) - inviteButton_H) * 0.5;
    _inviteButton.frame = (CGRect){inviteButton_X, inviteButton_Y, inviteButton_W, inviteButton_H};
    
    CGFloat inviteImageView_H = CGRectGetHeight(self.bounds);
    CGFloat inviteImageView_W = 100.0;
    CGFloat inviteImageView_X = CGRectGetWidth(self.bounds) - inviteImageView_W;
    CGFloat inviteImageView_Y = 0;
    _inviteImageView.frame = (CGRect){inviteImageView_X, inviteImageView_Y, inviteImageView_W, inviteImageView_H};
    
    CGFloat collectionView_W = inviteButton_X;
    CGFloat collectionView_X = 0;
    CGFloat collectionView_Y = inviteImageView_Y;
    CGFloat collectionView_H = inviteImageView_H;
    _collectionView.frame = (CGRect){collectionView_X, collectionView_Y, collectionView_W, collectionView_H};
    
    _lineView.frame = (CGRect){0, CGRectGetHeight(self.bounds) - 0.75,  CGRectGetWidth(self.bounds), 0.75};
}

@end
