//
//  CXMotorcadeCmdInputView.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import <UIKit/UIKit.h>

@class CXMotorcadeCmdInputView;

@protocol CXMotorcadeCmdInputViewDelegate<NSObject>

- (void)motorcadeCmdInputView:(CXMotorcadeCmdInputView *)inputView didFinishWithCmd:(NSString *)cmd;

@end

@interface CXMotorcadeCmdInputView : UIView

@property (nonatomic, assign, readonly) NSUInteger cmdCount;
@property (nonatomic, weak) id<CXMotorcadeCmdInputViewDelegate> delegate;
@property (nonatomic, assign, readonly) CGSize keyboardSize;

- (instancetype)initWithSuperview:(UIView *)superview cmdCount:(NSUInteger)cmdCount;

- (void)clear;

@end
