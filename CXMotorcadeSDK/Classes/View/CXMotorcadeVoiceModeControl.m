//
//  CXMotorcadeVoiceModeControl.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeVoiceModeControl.h"
#import "CXMotorcadeDefines.h"

#define V_TITLE_NORMAL_COLOR_KEY        CXHexIColor(0x9099A1)
#define V_TITLE_SELECTED_COLOR_KEY      CXHexIColor(0x1DBEFF)
#define V_SUB_TITLE_NORMAL_COLOR_KEY    CXHexIColor(0x9099A1)
#define V_SUB_TITLE_SELECTED_COLOR_KEY  CXHexIColor(0x1DBEFF)
#define V_BORDER_NORMAL_COLOR           CXHexIColor(0x9099A1).CGColor
#define V_BORDER_SELECTED_COLOR         CXHexIColor(0x59D8FF).CGColor
#define V_BACKGROUND_NORMAL_COLOR       CXHexIColor(0xFFFFFF)
#define V_BACKGROUND_SELECTED_COLOR     [CXHexIColor(0x1DBEFF) colorWithAlphaComponent:0.1]

@interface CXMotorcadeVoiceModeControl () {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}

@end

@implementation CXMotorcadeVoiceModeControl

- (instancetype)initWithVoiceMode:(CXMotorcadeVoiceMode)voiceMode{
    if(self = [super initWithFrame:CGRectZero]){
        _voiceMode = voiceMode;
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CX_PingFangSC_MediumFont(14.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = CX_PingFangSC_RegularFont(12.0);
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_subTitleLabel];
        
        self.layer.borderColor = V_BORDER_NORMAL_COLOR;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        
        if(voiceMode == CXMotorcadeTalkbackVoice){
            _titleLabel.text = @"手台对讲";
            _subTitleLabel.text = @"点击与队友聊天";
        }else{
            _titleLabel.text = @"实时语音";
            _subTitleLabel.text = @"队友实时语音聊天";
        }
        
        self.selected = NO;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imageView_W = 37.0;
    CGFloat imageView_H = imageView_W;
    CGFloat imageView_X = CX_MARGIN(10.0);
    CGFloat imageView_Y = CGRectGetMidY(self.bounds) - imageView_H * 0.5;
    _imageView.frame = CGRectMake(imageView_X, imageView_Y, imageView_W, imageView_H);
    
    CGFloat titleLabel_X = CGRectGetMaxX(_imageView.frame) + CX_MARGIN(6.0);
    CGFloat titleLabel_Y = imageView_Y;
    CGFloat titleLabel_W = CGRectGetWidth(self.bounds) - titleLabel_X;
    CGFloat titleLabel_H = 20.0;
    _titleLabel.frame = CGRectMake(titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H);
    
    CGFloat subTitleLabel_X = titleLabel_X;
    CGFloat subTitleLabel_Y = CGRectGetMaxY(_titleLabel.frame) + CX_MARGIN(1.0);
    CGFloat subTitleLabel_W = titleLabel_W;
    CGFloat subTitleLabel_H = 16.5;
    _subTitleLabel.frame = CGRectMake(subTitleLabel_X, subTitleLabel_Y, subTitleLabel_W, subTitleLabel_H);
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if(selected){
        _titleLabel.textColor = V_TITLE_SELECTED_COLOR_KEY;
        _subTitleLabel.textColor = V_SUB_TITLE_SELECTED_COLOR_KEY;
        self.layer.borderColor =  V_BORDER_SELECTED_COLOR;
        self.backgroundColor = V_BACKGROUND_SELECTED_COLOR;
        
        if(_voiceMode == CXMotorcadeRealTimeVoice){
            _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_crt_voice_selected_1");
        }else{
            _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_ctb_voice_selected_1");
        }
    }else{
        _titleLabel.textColor = V_TITLE_NORMAL_COLOR_KEY;
        _subTitleLabel.textColor = V_SUB_TITLE_NORMAL_COLOR_KEY;
        self.layer.borderColor = V_BORDER_NORMAL_COLOR;
        self.backgroundColor = V_BACKGROUND_NORMAL_COLOR;
        
        if(_voiceMode == CXMotorcadeRealTimeVoice){
            _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_crt_voice_selected_0");
        }else{
            _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_ctb_voice_selected_0");
        }
    }
}

@end
