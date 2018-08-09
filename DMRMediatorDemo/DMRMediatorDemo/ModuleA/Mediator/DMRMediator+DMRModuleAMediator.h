//
//  DMRMediator+DMRModuleAMediator.h
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMRMediator (DMRModuleAMediator)

- (UIViewController * _Nullable)viewControllerForDetail;

- (void)showAlertWithMessage:(NSString * _Nullable)message cancelAction:(void(^ _Nullable)(NSDictionary * _Nullable info))cancelAction confirmAction:(void(^ _Nullable)(NSDictionary * _Nullable info))confirmAction;

- (UITableViewCell * _Nullable)tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView;

- (void)configTableViewCell:(UITableViewCell *)tableViewCell info:(id)info indexPath:(NSIndexPath *)indexPath;

- (void)cleanActionTarget;
@end

NS_ASSUME_NONNULL_END
