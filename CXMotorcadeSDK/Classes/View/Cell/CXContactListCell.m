//
//  CXContactListCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXContactListCell.h"

@implementation CXContactListCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CXHexIColor(0x333333);
        _nameLabel.font = CX_PingFangSC_RegularFont(14.0);
        [self.contentView addSubview:_nameLabel];
        
        _moblieLabel = [[UILabel alloc] init];
        _moblieLabel.font = CX_PingFangSC_RegularFont(12.0);
        _moblieLabel.textColor = [CXHexIColor(0x333333) colorWithAlphaComponent:0.6];
        [self.contentView addSubview:_moblieLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat moblieLabel_H = _moblieLabel.font.lineHeight;
    
    CGFloat nameLabel_X = CX_MARGIN(20.0);
    CGFloat nameLabel_W = CGRectGetWidth(self.contentView.bounds) - nameLabel_X * 2;
    CGFloat nameLabel_H = _nameLabel.font.lineHeight;
    CGFloat nameLabel_Y = (CGRectGetHeight(self.contentView.bounds) - nameLabel_H - moblieLabel_H - 5.0) * 0.5;
    _nameLabel.frame = (CGRect){nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H};
    
    CGFloat moblieLabel_X = nameLabel_X;
    CGFloat moblieLabel_Y = CGRectGetMaxY(_nameLabel.frame) + 5.0;
    CGFloat moblieLabel_W = nameLabel_W;
    _moblieLabel.frame = CGRectMake(moblieLabel_X, moblieLabel_Y, moblieLabel_W, moblieLabel_H);
    
    CGFloat lineView_X = nameLabel_X;
    CGFloat lineView_Y = 0;
    CGFloat lineView_W = CGRectGetWidth(self.contentView.bounds) - lineView_X;
    CGFloat lineView_H = 0.5;
    _lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
}

@end

@implementation CXContactListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundView.backgroundColor = CXHexIColor(0xF0F1F4);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CX_PingFangSC_MediumFont(16.0);
        _titleLabel.textColor = CXHexIColor(0x333333);
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat titleLabel_X = CX_MARGIN(20.0);
    CGFloat titleLabel_W = CGRectGetWidth(self.bounds) - titleLabel_X * 2;
    CGFloat titleLabel_Y = 0;
    CGFloat titleLabel_H = CGRectGetHeight(self.bounds);
    _titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
}

@end
