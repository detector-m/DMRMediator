//
//  DMRMediator.h
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMRMediator : NSObject
+ (instancetype)sharedMediator;

// 本地调用入口
- (id _Nullable)performLocalActionWithTarget:(NSString * _Nonnull)target action:(NSString * _Nonnull)action parameters:(NSDictionary * _Nullable)parameters cacheTarget:(BOOL)cacheTarget;
- (BOOL)removeCachedActionTargetWithTarget:(NSString * _Nonnull)target;

//- (id _Nullable)safePerformActionWithTarget:(NSObject * _Nonnull)target action:(SEL _Nonnull)action parameters:(NSDictionary * _Nullable)parameters;

// 远程调用入口
- (id _Nullable)performRemoteActionWithTarget:(NSURL * _Nonnull)url completionHandler:(void (^ _Nullable)(NSDictionary * _Nullable info))completionHandler;
@end

NS_ASSUME_NONNULL_END
