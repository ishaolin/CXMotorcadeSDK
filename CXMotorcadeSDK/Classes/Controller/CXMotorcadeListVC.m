//
//  CXMotorcadeListVC.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeListVC.h"
#import "CXCmdJoinMotorcadeVC.h"
#import "CXCreateMotorcadeVC.h"
#import "CXMotorcadeListCell.h"
#import "CXMotorcadeListRequest.h"
#import "CXMotorcadeManager.h"

@interface CXMotorcadeListVC () <UITableViewDelegate, UITableViewDataSource> {
    CXTableView *_tableView;
    UIView *_operateView;
    UIButton *_createButton;
    UIButton *_cmdJoinButton;
    UIView *_placeholderView;
    UIImageView *_imageView;
    UILabel *_textLabel;
    NSArray<CXMotorcadeListDataModel *> *_motorcadeModels;
}

@end

@implementation CXMotorcadeListVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadMotorcadeListRequest];
}

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return @"app_show_my_mymotorcade";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的小队";
    self.navigationBar.hiddenBottomHorizontalLine = YES;
    
    _operateView = [[UIView alloc] init];
    _operateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_operateView];
    CGFloat operateView_X = 0;
    CGFloat operateView_W = CGRectGetWidth(self.view.bounds);
    CGFloat operateView_H = 122.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    CGFloat operateView_Y = CGRectGetHeight(self.view.bounds) - operateView_H;
    _operateView.frame = (CGRect){operateView_X, operateView_Y, operateView_W, operateView_H};
    
    CGFloat tableView_X = operateView_X;
    CGFloat tableView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat tableView_W = operateView_W;
    CGFloat tableView_H = operateView_Y - tableView_Y;
    _tableView = [[CXTableView alloc] initWithFrame:(CGRect){tableView_X, tableView_Y, tableView_W, tableView_H} style:UITableViewStylePlain];
    _tableView.rowHeight = 68.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _createButton.titleLabel.font = CX_PingFangSC_SemiboldFont(16.0);
    [_createButton setTitle:@"新建小队" forState:UIControlStateNormal];
    [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_createButton cx_setBackgroundColors:@[CXHexIColor(0x00CDFF), CXHexIColor(0x00B7FF)]
                        gradientDirection:CXColorGradientHorizontal
                                 forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(handleActionForCreateButton:) forControlEvents:UIControlEventTouchUpInside];
    [_operateView addSubview:_createButton];
    CGFloat createButton_X = 18.0;
    CGFloat createButton_Y = 12.0;
    CGFloat createButton_W = CGRectGetWidth(_operateView.frame) - createButton_X * 2;
    CGFloat createButton_H = 44.0;
    _createButton.frame = (CGRect){createButton_X, createButton_Y, createButton_W, createButton_H};
    [_createButton cx_roundedCornerRadii:createButton_H * 0.5];
    
    _cmdJoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cmdJoinButton.titleLabel.font = CX_PingFangSC_RegularFont(16.0);
    [_cmdJoinButton setTitle:@"口令加入小队" forState:UIControlStateNormal];
    [_cmdJoinButton setTitleColor:CXHexIColor(0x1DBEFF) forState:UIControlStateNormal];
    [_cmdJoinButton cx_setBackgroundColor:CXHexIColor(0xFFFFFF) forState:UIControlStateNormal];
    [_cmdJoinButton cx_setBackgroundColor:CXHexIColor(0xE8F8FF) forState:UIControlStateHighlighted];
    [_cmdJoinButton addTarget:self action:@selector(handleActionForCmdJoinButton:) forControlEvents:UIControlEventTouchUpInside];
    [_operateView addSubview:_cmdJoinButton];
    CGFloat cmdJoinButton_X = createButton_X;
    CGFloat cmdJoinButton_Y = CGRectGetMaxY(_createButton.frame) + 10.0;
    CGFloat cmdJoinButton_W = createButton_W;
    CGFloat cmdJoinButton_H = createButton_H;
    _cmdJoinButton.frame = (CGRect){cmdJoinButton_X, cmdJoinButton_Y, cmdJoinButton_W, cmdJoinButton_H};
    _cmdJoinButton.layer.borderColor = CXHexIColor(0x1DBEFF).CGColor;
    _cmdJoinButton.layer.borderWidth = 1.0;
    _cmdJoinButton.layer.masksToBounds = YES;
    _cmdJoinButton.layer.cornerRadius = cmdJoinButton_H * 0.5;
    
    _placeholderView = [[UIView alloc] init];
    _placeholderView.hidden = YES;
    [_tableView addSubview:_placeholderView];
    CGFloat placeholderView_W = 305.0;
    CGFloat placeholderView_H = 207.0;
    CGFloat placeholderView_X = (CGRectGetWidth(_tableView.frame) - placeholderView_W) * 0.5;
    CGFloat placeholderView_Y = (CGRectGetHeight(_tableView.frame) - placeholderView_H) * 0.35;
    _placeholderView.frame = (CGRect){placeholderView_X, placeholderView_Y, placeholderView_W, placeholderView_H};
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = CX_MOTORCADE_IMAGE(@"motorcade_list_empty");
    [_placeholderView addSubview:_imageView];
    CGFloat imageView_X = 0;
    CGFloat imageView_Y = 0;
    CGFloat imageView_W = placeholderView_W;
    CGFloat imageView_H = 175.0;
    _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = CX_PingFangSC_SemiboldFont(18.0);
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = CXHexIColor(0x9199A1);
    _textLabel.text = @"三五好友，组建车队";
    [_placeholderView addSubview:_textLabel];
    CGFloat textLabel_X = imageView_X;
    CGFloat textLabel_Y = CGRectGetMaxY(_imageView.frame);
    CGFloat textLabel_W = imageView_W;
    CGFloat textLabel_H = placeholderView_H - imageView_H;
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
}

- (void)loadMotorcadeListRequest{
    if(!_motorcadeModels){
        [CXHUD showHUD];
    }
    
    CXMotorcadeListRequest *request = [[CXMotorcadeListRequest alloc] init];
    [request loadRequestWithSuccess:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        CXMotorcadeListModel *model = (CXMotorcadeListModel *)data;
        if(model.isValid){
            self->_motorcadeModels = model.result.data;
        }else{
            self->_motorcadeModels = nil;
        }
        
        [self reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error) {
        self->_motorcadeModels = nil;
        [self reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _motorcadeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXMotorcadeListCell *cell = [CXMotorcadeListCell cellWithTableView:tableView];
    cell.dataModel = _motorcadeModels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXMotorcadeListDataModel *dataModel = _motorcadeModels[indexPath.row];
    CXSchemeEvent *event = [[CXSchemeEvent alloc] initWithModule:CXSchemeBusinessModulePhoenix page:CXSchemePageMotorcadeMain completion:^(CXSchemeBusinessModule module, CXSchemeBusinessPage page, NSString *error) {
        if(error){
            [CXHUD showMsg:error];
        }
    }];
    
    [event addParam:dataModel.id forKey:CM_SCHEME_PK_MOTORCADE_ID];
    [[CXMotorcadeManager sharedManager] handleSchemeEvent:event navigationController:self.navigationController];
}

- (void)reloadData{
    [CXHUD dismiss];
    
    if(CXArrayIsEmpty(_motorcadeModels)){
        _placeholderView.hidden = NO;
        self.navigationBar.hiddenBottomHorizontalLine = YES;
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        _placeholderView.hidden = YES;
        self.navigationBar.hiddenBottomHorizontalLine = NO;
        self.view.backgroundColor = CXHexIColor(0x0F9F9F9);
    }
    
    [_tableView reloadData];
}

- (void)handleActionForCreateButton:(UIButton *)createButton{
    CXDataRecord(@"app_click_my_mymotorcade_newcreate");
    
    CXCreateMotorcadeVC *VC = [[CXCreateMotorcadeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)handleActionForCmdJoinButton:(UIButton *)cmdJoinButton{
    CXDataRecord(@"app_click_my_mymotorcade_command");
    
    CXCmdJoinMotorcadeVC *VC = [[CXCmdJoinMotorcadeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

+ (void)registerSchemeSupporter{
    [[CXSchemeRegistrar sharedRegistrar] registerClass:self
                                          businessPage:CXSchemePageMotorcadeList
                                                module:CXSchemeBusinessModulePhoenix];
    [[CXSchemeRegistrar sharedRegistrar] registerClass:self
                                          businessPage:CXSchemePageCreadMotorcade
                                                module:CXSchemeBusinessModulePhoenix];
}

@end
