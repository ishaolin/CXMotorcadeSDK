//
//  CXMainMemberListCell.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMainMemberListCell.h"
#import <CXUIKit/CXUIKit.h>
#import "CXMotorcadeUserListModel.h"

@interface CXMainMemberListCell () {
    UIImageView *_tagImageView;
    UIImageView *_iconImageView;
    UIView *_iconBackView;
    UILabel *_tagLabel;
    UILabel *_nameLabel;
    UILabel *_offLineLabel;
    UIImageView *_micImageView;
}

@end

@implementation CXMainMemberListCell

+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"CXMainMemberListCell";
    return reuseIdentifier;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = CX_PingFangSC_RegularFont(16.0);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = CXHexIColor(0x333333);
        
        _iconImageView = [[UIImageView alloc] init];
        
        _iconBackView = [[UIView alloc] init];
        _iconBackView.backgroundColor = CXHexIColor(0x1D212C);
        
        _tagImageView = [[UIImageView alloc] init];
        [_tagImageView setImage:CX_MOTORCADE_IMAGE(@"motorcade_list_captain")];
        
        _micImageView = [[UIImageView alloc] init];
        [_micImageView setImage:CX_MOTORCADE_IMAGE(@"motorcade_member_list_mic_off")];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = CX_PingFangSC_RegularFont(10.0);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = CXHexIColor(0x333333);
        
        _offLineLabel = [[UILabel alloc] init];
        _offLineLabel.font = CX_PingFangSC_RegularFont(9.0);
        _offLineLabel.textAlignment = NSTextAlignmentCenter;
        _offLineLabel.textColor = [UIColor whiteColor];
        _offLineLabel.text = @"离线";
        
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_iconBackView];
        [self.contentView addSubview:_tagImageView];
        [self.contentView addSubview:_micImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_offLineLabel];
    }
    
    return self;
}

- (void)setMemberModel:(CXMotorcadeUserInfoModel *)memberModel{
    _memberModel = memberModel;
    [_iconImageView cx_setImageWithURL:memberModel.headUrl
                      placeholderImage:CX_MOTORCADE_IMAGE(@"motorcade_user_avatar")];
    
    if(memberModel.selected){
        CGFloat iconImageView_X = 7;
        CGFloat iconImageView_H = 50;
        CGFloat iconImageView_Y = 0;
        CGFloat iconImageView_W = iconImageView_H;
        _iconImageView.frame = (CGRect){iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H};
        _iconImageView.layer.cornerRadius = iconImageView_H * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 2.0;
        _iconImageView.layer.borderColor = CXHexIColor(0x1DBEFF).CGColor;
        
        _iconBackView.frame = _iconImageView.frame;
        _iconBackView.layer.cornerRadius = iconImageView_H * 0.5;
        _iconBackView.layer.masksToBounds = YES;
    }else{
        CGFloat iconImageView_X = 10.0;
        CGFloat iconImageView_H = 45.0;
        CGFloat iconImageView_Y = 0;
        CGFloat iconImageView_W = iconImageView_H;
        _iconImageView.frame = (CGRect){iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H};
        _iconImageView.layer.cornerRadius = iconImageView_H * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 0;
        _iconImageView.layer.borderColor = CXHexIColor(0x59D8FF).CGColor;
        
        _iconBackView.frame = _iconImageView.frame;
        _iconBackView.layer.cornerRadius = iconImageView_H * 0.5;
        _iconBackView.layer.masksToBounds = YES;
    }
    _tagImageView.hidden = memberModel.type != 0;
    
    if(self.voiceMode == CXMotorcadeTalkbackVoice){
        // 对讲模式不显示
        _micImageView.hidden = YES;
    }else{
        if(self.isAllMicDisabled){
            // 全员禁麦
            _micImageView.hidden = NO;
        }else{
            _micImageView.hidden = memberModel.micPermission;
        }
        
        if([memberModel isSelf] && memberModel.type == 0){
            // 队长是自己，隐藏
            _micImageView.hidden = YES;
        }
    }
    
    _nameLabel.text = memberModel.name;
    if(memberModel.onLineStatus == CXMotorcadeOnlineStateOffline){
        _iconBackView.hidden = NO;
        _iconBackView.alpha = 0.5;
        _nameLabel.alpha = 0.6;
        _offLineLabel.hidden = NO;
    }else{
        _iconBackView.hidden = YES;
        _iconImageView.alpha = 1.0;
        _nameLabel.alpha = 1.0;
        _offLineLabel.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat iconImageView_X = 10.0;
    CGFloat iconImageView_H = 45.0;
    CGFloat iconImageView_Y = 0;
    CGFloat iconImageView_W = iconImageView_H;
    _iconImageView.frame = (CGRect){iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H};
    _iconBackView.frame = _iconImageView.frame;
    
    CGFloat tagImageView_W = 43.0;
    CGFloat tagImageView_X = (self.frame.size.width - tagImageView_W) * 0.5;
    CGFloat tagImageView_H = 17.0;
    CGFloat tagImageView_Y = 32.0;
    _tagImageView.frame = (CGRect){tagImageView_X, tagImageView_Y, tagImageView_W, tagImageView_H};
    
    CGFloat micImageView_W = 20.0;
    CGFloat micImageView_X = CGRectGetMaxX(_iconImageView.frame) - micImageView_W + 3.0;
    CGFloat micImageView_H = 19.0;
    CGFloat micImageView_Y = CGRectGetMaxY(_iconImageView.frame) - micImageView_H;
    _micImageView.frame = (CGRect){micImageView_X, micImageView_Y, micImageView_W, micImageView_H};
    
    CGFloat nameLabel_W = 45.0;
    CGFloat nameLabel_X = (self.frame.size.width - nameLabel_W) * 0.5;
    CGFloat nameLabel_H = 14.0;
    CGFloat nameLabel_Y = 49.0;
    _nameLabel.frame = (CGRect){nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H};
    
    CGFloat offLineLabel_X = 0;
    CGFloat offLineLabel_H = 13.0;
    CGFloat offLineLabel_Y = (iconImageView_H - offLineLabel_H) * 0.5;
    CGFloat offLineLabel_W = self.frame.size.width;
    _offLineLabel.frame = (CGRect){offLineLabel_X, offLineLabel_Y, offLineLabel_W, offLineLabel_H};
}

@end
