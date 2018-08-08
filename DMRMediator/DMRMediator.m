//
//  DMRMediator.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRMediator.h"

NS_ASSUME_NONNULL_BEGIN

//const static NSString *kTargetPrefix = @"DMRTarget_";
//const static NSString *kActionPrefix = @"DMRAction_";
const static NSString *kTargetPrefix = @"";
const static NSString *kActionPrefix = @"";

@interface DMRMediator ()
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSObject *> *cachedTargets;
@end

@implementation DMRMediator
+ (instancetype)sharedMediator {
    static DMRMediator *_mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mediator = [DMRMediator new];
    });
    
    return _mediator;
}

#pragma mark - Public
// 本地调用入口
- (id _Nullable)performLocalActionWithTarget:(NSString * _Nonnull)target action:(NSString * _Nonnull)action parameters:(NSDictionary * _Nullable)parameters cacheTarget:(BOOL)cacheTarget {
    
    if (!target) {
        return nil;
    }
    
    NSString *targetClassName = [NSString stringWithFormat:@"%@%@", kTargetPrefix, target];
    NSString *actionName = [NSString stringWithFormat:@"%@%@:", kActionPrefix, action];
    Class targetClass;
    
    NSObject *innerTarget = self.cachedTargets[targetClassName];
    if (!innerTarget) {
        targetClass = NSClassFromString(targetClassName);
        innerTarget = [[targetClass alloc] init];
    }
    
    SEL innerAction = NSSelectorFromString(actionName);
    
    if (!innerTarget) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求。
        [self noTargetActionResponseWithTarget:targetClassName action:actionName parameters:parameters];
        
        return nil;
    }
    
    if (cacheTarget) {
        self.cachedTargets[targetClassName] = innerTarget;
    }
    
    if ([innerTarget respondsToSelector:innerAction]) {
        return [self safePerformActionWithTarget:innerTarget action:innerAction parameters:parameters];
    }
    else {
        // 有可能target是Swift对象
        actionName = [NSString stringWithFormat:@"%@%@WithParameters:", kActionPrefix, action];
        innerAction = NSSelectorFromString(actionName);
        if ([innerTarget respondsToSelector:innerAction]) {
            return [self safePerformActionWithTarget:innerTarget action:innerAction parameters:parameters];
        }
        else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            innerAction = NSSelectorFromString(@"notFound:");
            if ([innerTarget respondsToSelector:innerAction]) {
                return [self safePerformActionWithTarget:innerTarget action:innerAction parameters:parameters];
            }
            else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self noTargetActionResponseWithTarget:targetClassName action:actionName parameters:parameters];
                [self.cachedTargets removeObjectForKey:targetClassName];
                return nil;
            }
        }
    }
}

- (BOOL)removeCachedActionTargetWithTarget:(NSString *)targetName {
    if (targetName.length == 0) {
        return NO;
    }
    
    NSString *targetClassName = [NSString stringWithFormat:@"%@%@", kTargetPrefix, targetName];
    [self.cachedTargets removeObjectForKey:targetClassName];
    
    return YES;
}

// 远程调用入口
- (id _Nullable)performRemoteActionWithTarget:(NSURL * _Nonnull)url completionHandler:(void (^ _Nullable)(NSDictionary * _Nullable info))completionHandler {
    if (!url) {
        return nil;
    }
    
    NSMutableDictionary<NSString *, NSString *> *parameters = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *parameter in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [parameter componentsSeparatedByString:@"="];
        if (elts.count < 2) continue;
        [parameters setObject:elts.lastObject forKey:elts.firstObject];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performLocalActionWithTarget:url.host action:actionName parameters:parameters cacheTarget:NO];
    if (completionHandler) {
        if (result) {
            completionHandler(@{@"result": result});
        }
        else {
            completionHandler(nil);
        }
    }
    
    return result;
}

#pragma mark - Private

- (void)noTargetActionResponseWithTarget:(NSString * _Nonnull)target action:(NSString * _Nonnull)action parameters:(NSDictionary * _Nullable)parameters {
    SEL responseAction = NSSelectorFromString(@"Action_NoTargetAction:");
    NSObject *responseTarget = [NSClassFromString(@"Target_NoTargetAction") new];
    
    NSMutableDictionary *responseParameters = [[NSMutableDictionary alloc] init];
    responseParameters[@"NoTargetAction_Parameters"] = parameters;
    responseParameters[@"NoTargetAction_Target"] = target;
    responseParameters[@"NoTargetAction_Action"] = action;
    
    [self safePerformActionWithTarget:responseTarget action:responseAction parameters:responseParameters];
}

- (id _Nullable)safePerformActionWithTarget:(NSObject * _Nonnull)target action:(SEL _Nonnull)action parameters:(NSDictionary * _Nullable)parameters {
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if (!methodSignature) {
        return nil;
    }
    
    const char *retType = [methodSignature methodReturnType];
    
    // void
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&parameters atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        
        return nil;
    }
    // integer
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&parameters atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        
        return @(result);
    }
    
    // unsigned integer
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&parameters atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        
        return @(result);
    }
    
    // bool
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&parameters atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = NO;
        [invocation getReturnValue:&result];
        
        return @(result);
    }
    
    // CGFloat
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setArgument:&parameters atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0.0;
        [invocation getReturnValue:&result];
        
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:parameters];
#pragma clang diagnostic pop
}

#pragma mark - Setter / Getter
- (NSMutableDictionary<NSString *, NSObject *> * _Nonnull)cachedTargets {
    if (!_cachedTargets) {
        _cachedTargets = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedTargets;
}

@end

NS_ASSUME_NONNULL_END
