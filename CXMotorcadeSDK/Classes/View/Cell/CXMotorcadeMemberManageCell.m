//
//  CXMotorcadeMemberManageCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXMotorcadeMemberManageCell.h"
#import "CXMotorcadeDefines.h"
#import "CXMotorcadeUserListModel.h"

@interface CXMotorcadeMemberManageCell () {
    UIButton *_selectButton;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UIView *_stateView;
    UILabel *_stateLabel;
    UIView *_lineView;
}

@end

@implementation CXMotorcadeMemberManageCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_member_list_selected_0") forState:UIControlStateNormal];
        [_selectButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_member_list_selected_1") forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_selectButton];
        
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CXHexIColor(0x333333);
        _nameLabel.font = CX_PingFangSC_RegularFont(14.0);
        [self.contentView addSubview:_nameLabel];
        
        _stateView = [[UIView alloc] init];
        _stateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.contentView addSubview:_stateView];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = CX_PingFangSC_RegularFont(10.0);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.text = @"离线";
        [_stateView addSubview:_stateLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)setMemberInfoModel:(CXMotorcadeUserInfoModel *)memberInfoModel{
    _memberInfoModel = memberInfoModel;
    
    [_imageView cx_setImageWithURL:memberInfoModel.headUrl
                  placeholderImage:CX_MOTORCADE_IMAGE(@"motorcade_user_avatar")];
    _nameLabel.text = memberInfoModel.name;
    _selectButton.selected = memberInfoModel.selected;
    _stateView.hidden = memberInfoModel.onLineStatus == CXMotorcadeOnlineStateOnline;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat selectButton_W = 22.0;
    CGFloat selectButton_H = 23.0;
    CGFloat selectButton_X = CX_MARGIN(18.0);
    CGFloat selectButton_Y = (CGRectGetHeight(self.bounds) - selectButton_H) * 0.5;
    _selectButton.frame = CGRectMake(selectButton_X, selectButton_Y, selectButton_W, selectButton_H);
    
    CGFloat imageView_W = 45.0;
    CGFloat imageView_H = imageView_W;
    CGFloat imageView_X = CGRectGetMaxX(_selectButton.frame) + selectButton_X;
    CGFloat imageView_Y = (CGRectGetHeight(self.bounds) - imageView_H) * 0.5;
    _imageView.frame = CGRectMake(imageView_X, imageView_Y, imageView_W, imageView_H);
    [_imageView cx_roundedCornerRadii:imageView_H * 0.5];
    
    _stateView.frame = _imageView.frame;
    _stateLabel.frame = _stateView.bounds;
    [_stateView cx_roundedCornerRadii:imageView_H * 0.5];
    
    CGFloat nameLabel_X = CGRectGetMaxX(_imageView.frame) + 10.0;
    CGFloat nameLabel_W = CGRectGetWidth(self.bounds) - nameLabel_X - selectButton_X;
    CGFloat nameLabel_H = 20.0;
    CGFloat nameLabel_Y = (CGRectGetHeight(self.bounds) - nameLabel_H) * 0.5;
    _nameLabel.frame = CGRectMake(nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H);
    
    CGFloat lineView_X = imageView_X;
    CGFloat lineView_H = 0.5;
    CGFloat lineView_Y = CGRectGetHeight(self.bounds) - lineView_H;
    CGFloat lineView_W = CGRectGetWidth(self.bounds) - lineView_X;
    _lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
}

+ (UIColor *)highlightedColour{
    return nil;
}

@end
