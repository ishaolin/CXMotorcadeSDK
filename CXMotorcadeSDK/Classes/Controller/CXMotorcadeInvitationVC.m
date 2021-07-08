//
//  CXMotorcadeInvitationVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeInvitationVC.h"
#import "CXMotorcadeDefines.h"
#import "CXMotorcadeInvitationCell.h"
#import "CXMotorcadeInvatationRequest.h"
#import "CXContactListVC.h"
#import <CXShareSDK/CXShareSDK.h>
#import "CXMotorcadeManager+CXExtensions.h"

@interface CXMotorcadeInvitationVC () <CXContactListVCDelegate> {
    
}

@end

@implementation CXMotorcadeInvitationVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"邀请好友";
}

- (void)loadDataWithCompletion:(CXSettingViewControllerDataBlock)completion{
    CXSettingRowModel *rowModel1 = [[CXSettingRowModel alloc] initWithTitle:@"邀请通讯录好友" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"app_click_my_motorcade_invite_addressbook");
        CXMotorcadeInvitationVC *VC = (CXMotorcadeInvitationVC *)context;
        CXContactListVC *listVC = [[CXContactListVC alloc] init];
        listVC.delegate = VC;
        [VC.navigationController pushViewController:listVC animated:YES];
    }];
    rowModel1.image = CX_MOTORCADE_IMAGE(@"motorcade_invitation_contacts");
    rowModel1.arrowHidden = YES;
    
    CXSettingRowModel *rowModel2 = [[CXSettingRowModel alloc] initWithTitle:@"邀请微信好友" actionHandler:^(CXActionToolBarItemNode *itemNode, id context) {
        CXDataRecord(@"app_click_my_motorcade_invite_wechat");
        [CXMotorcadeInvitationVC invateWithType:CXMotorcadeInviteWeChat contact:nil];
    }];
    rowModel2.image = CX_MOTORCADE_IMAGE(@"motorcade_invitation_wechat");
    rowModel2.arrowHidden = YES;
    
    CXSettingSectionModel *sectionModel = [[CXSettingSectionModel alloc] initWithRows:@[rowModel1, rowModel2]
                                                                         footerHeight:CGFLOAT_MIN
                                                                        footerContent:nil];
    completion(@[sectionModel]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMotorcadeInvitationCell *cell = [CXMotorcadeInvitationCell cellWithTableView:tableView];
    CXSettingSectionModel *sectionModel = self.settingItems[indexPath.section];
    cell.rowModel = sectionModel.rows[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0;
}

- (void)contactListVC:(CXContactListVC *)listVC didSelectContact:(CXContact *)contact{
    [CXMotorcadeInvitationVC invateWithType:CXMotorcadeInviteSMS contact:contact];
}

+ (void)invateWithType:(CXMotorcadeInviteType)inviteType contact:(CXContact *)contact{
    [CXHUD showHUD];
    CXMotorcadeInvatationRequest *request = [[CXMotorcadeInvatationRequest alloc] initWithInviteType:inviteType];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXMotorcadeInvatationModel *model = (CXMotorcadeInvatationModel *)data;
        if(model.isValid){
            [CXHUD dismiss];
            if(inviteType == CXMotorcadeInviteSMS){
                CXShareContentModel *shareContent = [[CXShareContentModel alloc] init];
                shareContent.content = model.result.title;
                if(contact.phoneNumber){
                    shareContent.recipients = @[contact.phoneNumber];
                }
                [[CXShareSDKManager sharedManager] shareContent:shareContent
                                                      toChannel:CXShareChannelSMS
                                                       callback:nil];
            }else{
                CXShareContentModel *contentModel = [[CXShareContentModel alloc] init];
                contentModel.title = model.result.title;
                contentModel.content = model.result.content;
                contentModel.shareURL = model.result.link;
                contentModel.imageURL = model.result.imgUrl;
                
                [[CXShareSDKManager sharedManager] shareContent:contentModel toChannel:CXShareChannelWeChatSession callback:^(CXShareChannel shareChannel, CXShareState state) {
                    if(state == CXShareStateFailed){
                        [CXHUD showMsg:@"邀请失败"];
                    }
                }];
            }
        }else if(model.code == 200008){
            [CXHUD dismiss];
            [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
                config.title = model.msg;
                config.buttonTitles = @[@"确定"];
            } completion:^(NSUInteger buttonIndex) {
                [CXMotorcadeManager quitMotorcadePage];
            }];
        }else{
            [CXHUD showMsg:model.msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        [CXHUD showMsg:error.HUDMsg];
    }];
}

@end
