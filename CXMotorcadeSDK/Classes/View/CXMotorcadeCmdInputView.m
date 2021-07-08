//
//  CXMotorcadeCmdInputView.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeCmdInputView.h"
#import <CXUIKit/CXUIKit.h>

@interface CXMotorcadeCmdInputView () <CXNumberKeyboardPanelDelegate> {
    NSMutableArray<UILabel *> *_labels;
    NSMutableString *_code;
    CXNumberKeyboardPanel *_keyboard;
}

@end

@implementation CXMotorcadeCmdInputView

- (instancetype)initWithSuperview:(UIView *)superview cmdCount:(NSUInteger)cmdCount{
    if(self = [super init]){
        _cmdCount = cmdCount;
        _labels = [NSMutableArray new];
        _code = [NSMutableString string];
        
        for(NSInteger idx = 0; idx < cmdCount; idx ++){
            UILabel *label = [[UILabel alloc] init];
            label.font = CX_PingFangSC_SemiboldFont(22.0);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = CXHexIColor(0xE1E1E3);
            label.text = @"●";
            [self addSubview:label];
            [_labels addObject:label];
        }
        
        _keyboard = [[CXNumberKeyboardPanel alloc] init];
        _keyboard.delegate = self;
        _keyboardSize = _keyboard.bounds.size;
        [superview addSubview:_keyboard];
    }
    
    return self;
}

- (void)numberKeyboardPanel:(CXNumberKeyboardPanel *)keyboard didInputCharacter:(NSString *)character{
    if(_code.length >= _cmdCount){
        return;
    }
    
    if(_code.length + character.length <= _cmdCount){
        [_code appendString:character];
    }else{
        NSUInteger index = _cmdCount - _code.length;
        [_code appendString:[character substringToIndex:index]];
    }
    
    [_labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx < self->_code.length){
            obj.text = [self->_code substringWithRange:NSMakeRange(idx, 1)];
            obj.textColor = CXHexIColor(0x1DBEFF);
        }else{
            obj.text = @"●";
            obj.textColor = CXHexIColor(0xE1E1E3);
        }
    }];
    
    if(_code.length == _cmdCount){
        if([self.delegate respondsToSelector:@selector(motorcadeCmdInputView:didFinishWithCmd:)]){
            [self.delegate motorcadeCmdInputView:self didFinishWithCmd:[_code copy]];
        }
    }
}

- (void)numberKeyboardPanelDidDelete:(CXNumberKeyboardPanel *)keyboard{
    if(_code.length == 0){
        return;
    }
    
    NSUInteger index = _code.length - 1;
    [_code deleteCharactersInRange:NSMakeRange(index, 1)];
    UILabel *label = _labels[index];
    label.text = @"●";
    label.textColor = CXHexIColor(0xE1E1E3);
}

- (void)clear{
    [_code deleteCharactersInRange:NSMakeRange(0, _code.length)];
    
    [_labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = @"●";
        obj.textColor = CXHexIColor(0xE1E1E3);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat label_W = 36.0;
    CGFloat label_M = (CGRectGetWidth(self.bounds) - label_W * _labels.count) * 0.5;
    CGFloat label_H = label_W;
    CGFloat label_Y = 0;
    [_labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat label_X = label_M + label_W * idx;
        obj.frame = (CGRect){label_X, label_Y, label_W, label_H};
    }];
    
    CGFloat keyboard_W = CGRectGetWidth(_keyboard.bounds);
    CGFloat keyboard_H = CGRectGetHeight(_keyboard.bounds);
    CGFloat keyboard_X = (CGRectGetWidth(self.superview.bounds) - keyboard_W) * 0.5;
    CGFloat keyboard_Y = CGRectGetHeight(self.superview.bounds) - keyboard_H;
    _keyboard.frame = (CGRect){keyboard_X, keyboard_Y, keyboard_W, keyboard_H};
}

@end
