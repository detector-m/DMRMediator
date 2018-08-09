//
//  DMRModuleATargetA.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRModuleATargetA.h"
#import "DMRModuleADemoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DMRModuleATargetA

- (UIViewController *)detailViewController:(NSDictionary<NSString *, id> *)parameters {
    
    // 因为action是从属于ModuleA的，所以action直接可以使用ModuleA里的所有声明
    DMRModuleADemoViewController *viewController = [[DMRModuleADemoViewController alloc] init];
    viewController.valueLabel.text = parameters[@"key"];
    
    return viewController;
}

- (id)showAlert:(NSDictionary *)parameters {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DMRRouterCallbackBlock callback = parameters[@"cancelAction"];
        if (callback) {
            callback(@{@"alertAction" : action});
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DMRRouterCallbackBlock callback = parameters[@"confirmAction"];
        if (callback) {
            callback(@{@"alertAction" : action});
        }
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module A" message:parameters[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    return nil;
}

- (UITableViewCell * _Nullable)createTableViewCell:(NSDictionary<NSString *, id> *)parameters {
    UITableView *tableView = parameters[@"tableView"];
    NSString *identifier = parameters[@"identifier"];
    // 这里的TableViewCell的类型可以是自定义的，我这边偷懒就不自定义了。
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return tableViewCell;
}
- (void)configTableViewCell:(NSDictionary<NSString *, id> *)parameters {
    NSString *string = parameters[@"info"];
    NSIndexPath *indexPath = parameters[@"indexPath"];
    UITableViewCell *tableViewCell = parameters[@"configCell"];
    
    // 这里的TableViewCell的类型可以是自定义的，我这边偷懒就不自定义了。
    tableViewCell.textLabel.text = [NSString stringWithFormat:@"%@,%ld", string, (long)indexPath.row];
    
    //    if ([cell isKindOfClass:[XXXXXCell class]]) {
    //        正常情况下在这里做特定cell的赋值，上面就简单写了
    //    }
}

@end

NS_ASSUME_NONNULL_END
