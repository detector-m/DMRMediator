//
//  DMRModuleATargetA.h
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DMRRouterCallbackBlock)(NSDictionary * _Nullable info);

@interface DMRModuleATargetA : NSObject

- (UIViewController *)detailViewController:(NSDictionary<NSString *, id> *)parameters;

- (id)showAlert:(NSDictionary *)parameters;

- (UITableViewCell * _Nullable)createTableViewCell:(NSDictionary<NSString *, id> *)parameters;
- (void)configTableViewCell:(NSDictionary<NSString *, id> *)parameters;
@end

NS_ASSUME_NONNULL_END
