//
//  CXMotorcadeListCell.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeListCell.h"
#import "CXMotorcadeListModel.h"

@interface CXMotorcadeListCell () {
    UIImageView *_dotView;
    UIImageView *_avatarView;
    UIImageView *_captainView;
    UILabel *_captainLabel;
    UILabel *_nameLabel;
    UILabel *_cmdLabel;
    UILabel *_countLabel;
    UILabel *_typeLabel;
    UIView *_lineView;
}

@end

@implementation CXMotorcadeListCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        _dotView = [[UIImageView alloc] init];
        [self.contentView addSubview:_dotView];
        
        _avatarView = [[UIImageView alloc] init];
        [self.contentView addSubview:_avatarView];
        
        _captainView = [[UIImageView alloc] init];
        _captainView.image = [UIImage cx_imageWithColor:CXHexIColor(0x06B7FF) size:CGSizeMake(38.0, 16.0)];
        [self.contentView addSubview:_captainView];
        
        _captainLabel = [[UILabel alloc] init];
        _captainLabel.font = CX_PingFangSC_RegularFont(12.0);
        _captainLabel.textAlignment = NSTextAlignmentCenter;
        _captainLabel.textColor = [UIColor whiteColor];
        _captainLabel.backgroundColor = CXHexIColor(0x06B7FF);
        _captainLabel.text = @"队长";
        [_captainView addSubview:_captainLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = CX_PingFangSC_RegularFont(17.0);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = CXHexIColor(0x353C43);
        [self.contentView addSubview:_nameLabel];
        
        _cmdLabel = [[UILabel alloc] init];
        _cmdLabel.font = CX_PingFangSC_RegularFont(14.0);
        _cmdLabel.textAlignment = NSTextAlignmentLeft;
        _cmdLabel.textColor = CXHexIColor(0x9099A1);
        [self.contentView addSubview:_cmdLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = CX_PingFangSC_RegularFont(14.0);
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = CXHexIColor(0x777777);
        [self.contentView addSubview:_countLabel];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = CX_PingFangSC_RegularFont(12.0);
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.textColor = CXHexIColor(0x9099A1);
        [self.contentView addSubview:_typeLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0xF0F0F0);
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)setDataModel:(CXMotorcadeListDataModel *)dataModel{
    _dataModel = dataModel;
    
    NSString *countText = [NSString stringWithFormat:@"{%@}/%@",
                           @(MAX(dataModel.onlineCount, 0)),
                           @(MAX(dataModel.totalCount, 1))];
    if(dataModel.onlineCount > 0){
        _dotView.image = [UIImage cx_imageWithColor:CXHexIColor(0x1FD736) size:CGSizeMake(8.0, 8.0)];
        [_countLabel cx_setAttributedText:countText highlightedColor:CXHexIColor(0x1FD736)];
    }else{
        _dotView.image = [UIImage cx_imageWithColor:CXHexIColor(0xE5E5E5) size:CGSizeMake(8.0, 8.0)];
        [_countLabel cx_setAttributedText:countText highlightedColor:nil];
    }
    
    [_avatarView cx_setImageWithURLArray:dataModel.headUrlList composeSize:45.0 spacing:1.0];
    _captainView.hidden = dataModel.captain != CXMotorcadeMemberCaptain;
    _nameLabel.text = dataModel.name;
    _cmdLabel.text = [NSString stringWithFormat:@"口令 %@", dataModel.command];
    _typeLabel.text = dataModel.groupChat == CXMotorcadeRealTimeVoice ? @"实时语音" : @"手台对讲";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat dotView_W = 8.0;
    CGFloat dotView_H = dotView_W;
    CGFloat dotView_X = 18.0;
    CGFloat dotView_Y = (CGRectGetHeight(self.contentView.bounds) - dotView_H) * 0.5;
    _dotView.frame = (CGRect){dotView_X, dotView_Y, dotView_W, dotView_H};
    [_dotView cx_roundedCornerRadii:dotView_H * 0.5];
    
    CGFloat avatarView_W = 45.0;
    CGFloat avatarView_H = avatarView_W;
    CGFloat avatarView_X = CGRectGetMaxX(_dotView.frame) + 10.0;
    CGFloat avatarView_Y = (CGRectGetHeight(self.contentView.bounds) - avatarView_H) * 0.5;
    _avatarView.frame = (CGRect){avatarView_X, avatarView_Y, avatarView_W, avatarView_H};
    [_avatarView cx_roundedCornerRadii:avatarView_H * 0.5];
    
    CGFloat captainView_W = 38.0;
    CGFloat captainView_H = 16.0;
    CGFloat captainView_X = CGRectGetMidX(_avatarView.frame) - captainView_W * 0.5;
    CGFloat captainView_Y = CGRectGetMaxY(_avatarView.frame) - captainView_H;
    _captainView.frame = (CGRect){captainView_X, captainView_Y, captainView_W, captainView_H};
    _captainLabel.frame = _captainView.bounds;
    [_captainView cx_roundedCornerRadii:captainView_H * 0.5];
    
    CGFloat countLabel_W = 60.0;
    CGFloat countLabel_H = 20.0;
    CGFloat countLabel_X = CGRectGetWidth(self.contentView.bounds) - countLabel_W - dotView_X;
    CGFloat countLabel_Y = 18.0;
    _countLabel.frame = (CGRect){countLabel_X, countLabel_Y, countLabel_W, countLabel_H};
    
    CGFloat typeLabel_W = 50.0;
    CGFloat typeLabel_H = 17.0;
    CGFloat typeLabel_X = CGRectGetMaxX(_countLabel.frame) - typeLabel_W;
    CGFloat typeLabel_Y = CGRectGetMaxY(_countLabel.frame) + 4.0;
    _typeLabel.frame = (CGRect){typeLabel_X, typeLabel_Y, typeLabel_W, typeLabel_H};
    
    CGFloat nameLabel_X = CGRectGetMaxX(_avatarView.frame) + 13.0;
    CGFloat nameLabel_Y = 12.0;
    CGFloat nameLabel_W = countLabel_X - nameLabel_X;
    CGFloat nameLabel_H = 24.0;
    _nameLabel.frame = (CGRect){nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H};
    
    CGFloat cmdLabel_X = nameLabel_X;
    CGFloat cmdLabel_Y = CGRectGetMaxY(_nameLabel.frame);
    CGFloat cmdLabel_W = nameLabel_W;
    CGFloat cmdLabel_H = 20.0;
    _cmdLabel.frame = (CGRect){cmdLabel_X, cmdLabel_Y, cmdLabel_W, cmdLabel_H};
    
    CGFloat lineView_X = CGRectGetMaxX(_avatarView.frame) - 5.0;
    CGFloat lineView_W = CGRectGetWidth(self.contentView.bounds) - lineView_X;
    CGFloat lineView_H = 0.5;
    CGFloat lineView_Y = CGRectGetHeight(self.contentView.bounds) - lineView_H;
    _lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
}

@end
