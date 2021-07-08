//
//  CXMotorcadeChatVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXMotorcadeChatVC.h"
#import <CXVoiceSDK/CXVoiceSDK.h>

@implementation CXMotorcadeChatVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"30000111";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar.shadowEnabled = YES;
}

- (void)browser:(CXAssetBrowser *)browser didStartPlayVideo:(NSURL *)videoURL{
    if([CXVoiceManager sharedManager].hasActiveRoom){
        [[CXVoiceManager sharedManager] pauseMicrophone];
    }
}

- (void)browser:(CXAssetBrowser *)browser didStopPlayVideo:(NSURL *)videoURL{
    if([CXVoiceManager sharedManager].hasActiveRoom){
        [[CXVoiceManager sharedManager] resumeMicrophone];
    }
}

- (void)didEnterCameraPage{
    if([CXVoiceManager sharedManager].hasActiveRoom){
        [[CXVoiceManager sharedManager] pauseAudio];
    }
}

- (void)didExitCameraPage{
    if([CXVoiceManager sharedManager].hasActiveRoom){
        [[CXVoiceManager sharedManager] resumeAudio];
    }
}

@end
