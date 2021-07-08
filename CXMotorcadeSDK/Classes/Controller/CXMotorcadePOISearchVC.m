//
//  CXMotorcadePOISearchVC.m
//  Pods
//
//  Created by wshaolin on 2019/4/14.
//

#import "CXMotorcadePOISearchVC.h"
#import "CXMotorcadePOITableHeaderView.h"

@interface CXMotorcadePOISearchVC () <CXMotorcadePOITableHeaderViewDelegate, CXPOIDragViewControllerDelegate> {
    
}

@end

@implementation CXMotorcadePOISearchVC

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_motorcade_search";
}

- (instancetype)initWithCompletion:(CXPOISearchVCCompletionBlock)completion{
    if(self = [super initWithSearchBarStyle:CXPOISearchBarRightStyleNone
                                    POIType:CXMotorcadePOIType
                                 completion:completion]){
        self.searchBar.placeholder = @"搜地点";
    }
    
    return self;
}

- (void)setHeaderForTableView:(UITableView *)tableView{
    CXMotorcadePOITableHeaderView *headerView = [[CXMotorcadePOITableHeaderView alloc] init];
    headerView.delegate = self;
    headerView.frame = (CGRect){0, 0, 0, 60.0};
    tableView.tableHeaderView = headerView;
}

- (void)POITableHeaderViewDidDragSelectionAction:(CXMotorcadePOITableHeaderView *)headerView{
    CXPOIDragViewController *POIDragViewController = [[CXPOIDragViewController alloc] init];
    POIDragViewController.delegate = self;
    [self.navigationController pushViewController:POIDragViewController animated:YES];
}

- (void)POITableHeaderViewDidCurrentLocationAction:(CXMotorcadePOITableHeaderView *)headerView{
    [self invokeCompletionBlock:[[CXLocationManager sharedManager].reverseGeoCodeResult toMapPOIModel]
                        POIType:self.POIType];
}

- (void)POIDragViewController:(CXPOIDragViewController *)viewController didSelectedPOIModel:(CXMapPOIModel *)POIModel{
    [self invokeCompletionBlock:POIModel POIType:self.POIType];
}

@end
