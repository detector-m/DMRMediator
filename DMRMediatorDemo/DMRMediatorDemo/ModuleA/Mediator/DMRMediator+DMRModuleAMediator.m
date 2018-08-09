//
//  DMRMediator+DMRModuleAMediator.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRMediator+DMRModuleAMediator.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kDMRMediatorTarget = @"DMRModuleATargetA";

static NSString * const kDMRMediatorAction = @"detailViewController";
static NSString * const kDMRMediatorShowAlertAction = @"showAlert";

static NSString * const kDMRMediatorCreateCellAction = @"createTableViewCell";
static NSString * const kDMRMediatorConfigCellAction = @"configTableViewCell";

@implementation DMRMediator (DMRModuleAMediator)

- (UIViewController * _Nullable)viewControllerForDetail {
    
    UIViewController *vc = [self performLocalActionWithTarget:kDMRMediatorTarget action:kDMRMediatorAction parameters:@{@"key" : @"Test"} cacheTarget:NO];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    
    return nil;
}

- (void)showAlertWithMessage:(NSString * _Nullable)message cancelAction:(void(^ _Nullable)(NSDictionary * _Nullable info))cancelAction confirmAction:(void(^ _Nullable)(NSDictionary * _Nullable info))confirmAction {
    NSMutableDictionary<NSString *, id> *sendParameters = [NSMutableDictionary dictionary];
    if (message) {
        sendParameters[@"message"] = message;
    }
    if (cancelAction) {
        sendParameters[@"cancelAction"] = cancelAction;
    }
    if (confirmAction) {
        sendParameters[@"confirmAction"] = confirmAction;
    }
    
    [self performLocalActionWithTarget:kDMRMediatorTarget action:kDMRMediatorShowAlertAction parameters:sendParameters cacheTarget:NO];
}

- (UITableViewCell * _Nullable)tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView {
    return [self performLocalActionWithTarget:kDMRMediatorTarget action:kDMRMediatorCreateCellAction parameters:@{@"identifier": identifier, @"tableView": tableView} cacheTarget:YES];
}

- (void)configTableViewCell:(UITableViewCell *)tableViewCell info:(id)info indexPath:(NSIndexPath *)indexPath {
    [self performLocalActionWithTarget:kDMRMediatorTarget action:kDMRMediatorConfigCellAction parameters:@{@"configCell": tableViewCell, @"info": info, @"indexPath": indexPath} cacheTarget:YES];
}

- (void)cleanActionTarget {
    [self removeCachedActionTargetWithTarget:kDMRMediatorTarget];
}
@end

NS_ASSUME_NONNULL_END
