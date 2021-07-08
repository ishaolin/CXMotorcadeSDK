//
//  CXMotrocadeMapNaviVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import "CXMotrocadeMapNaviVC.h"
#import "CXMotorcadeMemberAnnotation.h"
#import "CXMotorcadeMemberAnnotationView.h"
#import "CXMotorcadeAnnotationUtils.h"
#import "CXMotorcadeCoordinateResponse.h"
#import "CXMotorcadeNotificationName.h"
#import "CXMotorcadeOnlineModel.h"
#import "CXMotorcadeDefines.h"
#import <CXVoiceSDK/CXVoiceSDK.h>

@interface CXMotrocadeMapNaviVC () {
    UIButton *_gmeSpeakerButton;
    NSArray<CXMotorcadeUserInfoModel *> *_memebers;
}

@end

@implementation CXMotrocadeMapNaviVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"30000042";
}

- (instancetype)initWithEndCoordinate:(CLLocationCoordinate2D)endCoordinate{
    CXMapNaviParam *naviParam = [[CXMapNaviParam alloc] init];
    naviParam.naviType = CXMapNaviDrive;
    naviParam.endCoordinate = endCoordinate;
    return [self initWithNaviParam:naviParam];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _gmeSpeakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gmeSpeakerButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_navi_gme_speaker_off") forState:UIControlStateNormal];
    [_gmeSpeakerButton setImage:CX_MOTORCADE_IMAGE(@"motorcade_navi_gme_speaker_on") forState:UIControlStateSelected];
    _gmeSpeakerButton.selected = [CXVoiceManager sharedManager].isSpeakerEnabled;
    [_gmeSpeakerButton addTarget:self action:@selector(handleActionForGmeSpeakerButton:) forControlEvents:UIControlEventTouchUpInside];
    _gmeSpeakerButton.hidden = YES;
    [self.view addSubview:_gmeSpeakerButton];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(motorcadeSocketPushCoordinateNotification:)
                                 name:CXMotorcadeSocketPushCoordinateNotification];
}

- (void)handleActionForGmeSpeakerButton:(UIButton *)gmeSpeakerButton{
    gmeSpeakerButton.selected = !gmeSpeakerButton.selected;
    CXVoiceManager.sharedManager.speakerEnabled = gmeSpeakerButton.isSelected;
}

- (void)naviViewDidLayoutSubviews:(UIView *)naviView naviType:(CXMapNaviType)naviType{
    [super naviViewDidLayoutSubviews:naviView naviType:naviType];
    
    _gmeSpeakerButton.hidden = NO;
    CGRect gmeSpeakerButtonFrame = self.speakerRect;
    gmeSpeakerButtonFrame.origin.y = CGRectGetMaxY(gmeSpeakerButtonFrame);
    _gmeSpeakerButton.frame = gmeSpeakerButtonFrame;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if(![annotation isKindOfClass:[CXMotorcadeMemberAnnotation class]]){
        return nil;
    }
    
    static NSString *identifier = @"CXMotorcadeMemberAnnotation";
    CXMotorcadeMemberAnnotation *memberAnnotation = (CXMotorcadeMemberAnnotation *)annotation;
    CXMotorcadeMemberAnnotationView *annotationView = (CXMotorcadeMemberAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(!annotationView){
        annotationView = [[CXMotorcadeMemberAnnotationView alloc] initWithAnnotation:memberAnnotation reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = memberAnnotation.customCalloutView != nil;
    annotationView.customCalloutView = memberAnnotation.customCalloutView;
    annotationView.enabled = YES;
    annotationView.draggable = NO;
    annotationView.zIndex = memberAnnotation.zIndex;
    annotationView.coorOffset = memberAnnotation.coorOffset;
    annotationView.calloutOffset = memberAnnotation.calloutOffset;
    annotationView.image = memberAnnotation.image;
    annotationView.memberInfoModel = memberAnnotation.memberInfoModel;
    
    return annotationView;
}

- (void)addOrRemoveAnnotationWithMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members{
    [members enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isSelf]){
            return ;
        }
        
        CXMotorcadeMemberAnnotation *annotation = [CXMotorcadeAnnotationUtils memberAnnotationById:obj.userId annotations:self.mapView.annotations];
        if(obj.onLineStatus == CXMotorcadeOnlineStateOffline){
            if(annotation){
                [self.mapView removeAnnotation:annotation];
            }
        }else if(annotation){
            CXMotorcadeMemberAnnotationView *annotationView = (CXMotorcadeMemberAnnotationView *)[self.mapView viewForAnnotation:annotation];
            if([annotationView isKindOfClass:[CXMotorcadeMemberAnnotationView class]]){
                annotationView.memberInfoModel = obj;
            }
            
            CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(obj.lat, obj.lng);
            if(CXLocationCoordinate2DIsValid(coordinate)){
                [annotation setCoordinate:coordinate];
            }
        }else{
            CXMotorcadeMemberAnnotation *annotation = [[CXMotorcadeMemberAnnotation alloc] initWithMemberInfoModel:obj];
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (void)motorcadeSocketPushCoordinateNotification:(NSNotification *)notification{
    CXMotorcadeCoordinateResponse *response = notification.userInfo[CXNotificationUserInfoKey0];
    if(![response.carTeamId isEqualToString:self.onlineModel.motorcadeInfo.id]){
        return;
    }
    
    [response.members enumerateObjectsUsingBlock:^(CXMotorcadeCoordinateMember * _Nonnull coordinateMember, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->_memebers enumerateObjectsUsingBlock:^(CXMotorcadeUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([coordinateMember.userId isEqualToString:obj.userId]){
                CXMotorcadeCoordinate *coordinate = coordinateMember.coordinates.firstObject;
                obj.lat = coordinate.lat;
                obj.lng = coordinate.lng;
            }
        }];
    }];
    
    [self addOrRemoveAnnotationWithMembers:_memebers];
}

- (void)reloadMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members{
    _memebers = members;
    [self addOrRemoveAnnotationWithMembers:members];
}

- (BOOL)disableGesturePopInteraction{
    return YES;
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

@end
