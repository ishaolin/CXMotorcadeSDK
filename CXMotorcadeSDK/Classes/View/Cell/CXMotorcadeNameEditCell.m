//
//  CXMotorcadeNameEditCell.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeNameEditCell.h"

@interface CXMotorcadeNameEditCell () <UITextFieldDelegate> {
    UITextField *_textField;
}

@end

@implementation CXMotorcadeNameEditCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.iconView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.lineView.hidden = YES;
        
        _textField = [[UITextField alloc] init];
        _textField.font = CX_PingFangSC_RegularFont(14.0);
        _textField.textColor = CXHexIColor(0x333333);
        _textField.tintColor = [CXHexIColor(0x333333) colorWithAlphaComponent:0.6];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入小队名称" attributes:@{NSForegroundColorAttributeName : _textField.tintColor}];
        [_textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
    }
    
    return self;
}

- (void)setRowModel:(CXSettingRowModel *)rowModel{
    [super setRowModel:rowModel];
    
    _textField.text = rowModel.title;
}

- (void)textFieldDidChanged:(UITextField *)textField{
    if([textField positionFromPosition:textField.markedTextRange.start offset:0]){
        return;
    }
    
    NSRange range;
    NSUInteger charCount = 0;
    for(NSUInteger index = 0; index < textField.text.length; index += range.length){
        range = [textField.text rangeOfComposedCharacterSequenceAtIndex:index];
        charCount ++;
        if(charCount > 8){
            [CXHUD showMsg:@"最多只能输入8个字符"];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(motorcadeNameEditCell:didChangeInputText:)]){
        [self.delegate motorcadeNameEditCell:self didChangeInputText:textField.text];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat textField_X = CX_MARGIN(15.0);
    CGFloat textField_Y = 0;
    CGFloat textField_H = CGRectGetHeight(self.bounds);
    CGFloat textField_W = CGRectGetWidth(self.bounds) - textField_X * 2;
    _textField.frame = (CGRect){textField_X, textField_Y, textField_W, textField_H};
}

@end
