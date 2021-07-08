//
//  CXMotorcadeMemberAnnotationView.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXMotorcadeMemberAnnotationView.h"
#import "CXMotorcadeMemberAnnotation.h"

static inline NSString *FormatDistanceToString(double distance){
    if(distance >= 1000.0){
        return [NSString stringWithFormat:@"%.1fKM", distance / 1000.0];
    }
    
    return [NSString stringWithFormat:@"%.fM", distance];
}

@interface CXMotorcadeMemberAnnotationView () {
    CXMotorcadeMemberAnnotationBubbleView *_bubbleView;
}

@end

@implementation CXMotorcadeMemberAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        _bubbleView = [[CXMotorcadeMemberAnnotationBubbleView alloc] init];
        self.bubbleView = _bubbleView;
    }
    
    return self;
}

- (void)setMemberInfoModel:(CXMotorcadeUserInfoModel *)memberInfoModel{
    _memberInfoModel = memberInfoModel;
    self.URLCacheKey = [NSString stringWithFormat:@"motorcade/%@", memberInfoModel.sex];
    [_bubbleView setMemberInfoModel:memberInfoModel];
    
    [self setImageWithURL:memberInfoModel.headUrl completion:^UIImage *(CXBubbleAnnotationView *annotationView, UIImage *image) {
        return [CXMotorcadeMemberAnnotation annotationImageWithSex:memberInfoModel.sex avatar:image];
    }];
}

@end

@interface CXMotorcadeMemberAnnotationBubbleView () {
    UIImageView *_leftView;
    UIImageView *_rightView;
    
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_distanceLabel;
}

@end

@implementation CXMotorcadeMemberAnnotationBubbleView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        
        _leftView = [[UIImageView alloc] init];
        _rightView = [[UIImageView alloc] init];
        [self addSubview:_leftView];
        [self addSubview:_rightView];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_list_captain");
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = CX_PingFangSC_RegularFont(13.0);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = CXHexIColor(0x333333);
        [self addSubview:_textLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = CX_PingFangSC_RegularFont(12.0);
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.textColor = CXHexIColor(0x666666);
        [self addSubview:_distanceLabel];
    }
    
    return self;
}

- (void)setMemberInfoModel:(CXMotorcadeUserInfoModel *)infoModel{
    if(infoModel.distance > 0){
        if(infoModel.memberDistance > 0){
            [self setTwoAttributedTextStyleToDisplay:infoModel];
        }else{
            [self setOneAttributedTextStyleToDisplay:infoModel];
        }
    }else if(infoModel.memberDistance > 0){
        [self setOneAttributedTextStyleToDisplay:infoModel];
    }else if(infoModel.type == CXMotorcadeMemberCaptain){
        [self setImageTextStyleToDisplay:infoModel];
    }else{
        [self setTextStyleToDisplay:infoModel];
    }
}

- (void)setTextStyleToDisplay:(CXMotorcadeUserInfoModel *)infoModel{
    _imageView.hidden = YES;
    _distanceLabel.hidden = YES;
    _textLabel.font = CX_PingFangSC_RegularFont(13.0);
    _textLabel.textColor = CXHexIColor(0x333333);
    [_textLabel cx_setAttributedText:infoModel.name highlightedColor:nil];
    
    [self setLeftImageName:@"motorcade_bubble_bg_left_0"
            rightImageName:@"motorcade_bubble_bg_right_0"];
    
    CGFloat textLabel_X = 20.0;
    CGFloat textLabel_H = 17.0;
    CGFloat textLabel_Y = 14.75;
    CGFloat textLabel_W = [_textLabel cx_sizeThatFits:CGSizeMake(MAXFLOAT, textLabel_H)].width;
    textLabel_W = MAX(85.0, MIN(textLabel_W, 180.0));
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    self.frame = (CGRect){0, 0, textLabel_W + textLabel_X * 2, 50.0};
}

- (void)setImageTextStyleToDisplay:(CXMotorcadeUserInfoModel *)infoModel{
    _imageView.hidden = NO;
    _distanceLabel.hidden = YES;
    _textLabel.font = CX_PingFangSC_RegularFont(13.0);
    _textLabel.textColor = CXHexIColor(0x666666);
    [_textLabel cx_setAttributedText:infoModel.name highlightedColor:nil];
    
    [self setLeftImageName:@"motorcade_bubble_bg_left_0"
            rightImageName:@"motorcade_bubble_bg_right_0"];
    
    CGFloat imageView_W = 43.0;
    CGFloat imageView_H = 17.0;
    CGFloat imageView_X = 15.0;
    CGFloat imageView_Y = 14.75;
    _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    
    CGFloat textLabel_X = 20.0;
    CGFloat textLabel_H = 17.0;
    CGFloat textLabel_Y = 14.75;
    CGFloat textLabel_W = [_textLabel cx_sizeThatFits:CGSizeMake(MAXFLOAT, textLabel_H)].width;
    textLabel_X = CGRectGetMaxX(_imageView.frame) + 4.0;
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    self.frame = (CGRect){0, 0, MAX((textLabel_X + textLabel_W + imageView_X + 5.0), 105.0), 50.0};
}

- (void)setOneAttributedTextStyleToDisplay:(CXMotorcadeUserInfoModel *)infoModel{
    _imageView.hidden = YES;
    _distanceLabel.hidden = YES;
    _textLabel.font = _distanceLabel.font;
    [self setLeftImageName:@"motorcade_bubble_bg_left_1"
            rightImageName:@"motorcade_bubble_bg_right_1"];
    
    NSString *attributedText = nil;
    if(infoModel.distance > 0){
        attributedText = [NSString stringWithFormat:@"距离目的地 {%@}", FormatDistanceToString(infoModel.distance)];
    }else{
        attributedText = [NSString stringWithFormat:@"距离我 {%@}", FormatDistanceToString(infoModel.memberDistance)];
    }
    
    [_textLabel cx_setAttributedText:attributedText
                    highlightedColor:CXHexIColor(0x333333)
                     highlightedFont:CX_PingFangSC_MediumFont(14.0)];
    
    CGSize textLabelSize = [_textLabel cx_sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat textLabel_H = textLabelSize.height;
    CGFloat textLabel_W = MAX(textLabelSize.width, 155.0);
    CGFloat textLabel_X = 14.0;
    CGFloat textLabel_Y = 21.0;
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    self.frame = (CGRect){0, 0, textLabel_W + textLabel_X * 2, 62.0};
}

- (void)setTwoAttributedTextStyleToDisplay:(CXMotorcadeUserInfoModel *)infoModel{
    _imageView.hidden = YES;
    _distanceLabel.hidden = NO;
    _textLabel.font = CX_PingFangSC_RegularFont(14.0);
    
    [self setLeftImageName:@"motorcade_bubble_bg_left_2"
            rightImageName:@"motorcade_bubble_bg_right_2"];
    
    [_textLabel cx_setAttributedText:[NSString stringWithFormat:@"距离目的地 {%@}", FormatDistanceToString(infoModel.distance)]
                    highlightedColor:CXHexIColor(0x333333)
                     highlightedFont:CX_PingFangSC_SemiboldFont(16.0)];
    
    [_distanceLabel cx_setAttributedText:[NSString stringWithFormat:@"距离我 {%@}", FormatDistanceToString(infoModel.memberDistance)]
                        highlightedColor:CXHexIColor(0x666666)
                         highlightedFont:CX_PingFangSC_MediumFont(14.0)];
    
    CGSize textLabelSize = [_textLabel cx_sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat textLabel_H = textLabelSize.height;
    CGFloat textLabel_W = MAX(textLabelSize.width, 155.0);
    CGFloat textLabel_X = 14.0;
    CGFloat textLabel_Y = 16.0;
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    CGSize distanceTextLabelSize = [_distanceLabel cx_sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat distanceText_H = distanceTextLabelSize.height;
    CGFloat distanceText_W = MAX(distanceTextLabelSize.width, 155.0);
    CGFloat distanceText_X = textLabel_X;
    CGFloat distanceText_Y = 34.0;
    _distanceLabel.frame = (CGRect){distanceText_X, distanceText_Y, distanceText_W, distanceText_H};
    
    self.frame = (CGRect){0, 0, MAX(textLabel_W + textLabel_X * 2, distanceText_W + distanceText_X * 2), 80.0};
}

- (void)setLeftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName{
    UIImage *leftImage = [CX_MOTORCADE_IMAGE(leftImageName) cx_resizableImage];
    _leftView.image = leftImage;
    UIImage *rightImage = [CX_MOTORCADE_IMAGE(rightImageName) cx_resizableImage];
    _rightView.image = rightImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftView_X = 0;
    CGFloat leftView_Y = 0;
    CGFloat leftView_W = CGRectGetWidth(self.bounds) * 0.5;
    CGFloat leftView_H = CGRectGetHeight(self.bounds);
    _leftView.frame = (CGRect){leftView_X, leftView_Y, leftView_W, leftView_H};
    
    CGFloat rightView_X = CGRectGetMaxX(_leftView.frame);
    CGFloat rightView_Y = leftView_Y;
    CGFloat rightView_W = leftView_W;
    CGFloat rightView_H = leftView_H;
    _rightView.frame = (CGRect){rightView_X, rightView_Y, rightView_W, rightView_H};
}

@end
