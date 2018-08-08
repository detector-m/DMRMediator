//
//  DMRMediatorDemoTests.m
//  DMRMediatorDemoTests
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMRMediator.h"

@interface DMRMediatorDemoTests : XCTestCase

@end

@implementation DMRMediatorDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDMRMediator {
    DMRMediator *mediator = [DMRMediator sharedMediator];
    XCTAssert(mediator, @"Is error");
    
    BOOL result = [mediator removeCachedActionTargetWithTarget:@""];
    XCTAssert(result == NO, @"remove error");
    
    result = [mediator removeCachedActionTargetWithTarget:@"Test"];
    XCTAssert(result == YES, @"remove error");
    
//    NSObject *object = [[NSObject alloc] init];
//    SEL sel = NSSelectorFromString(@"description");
//    NSString *retStr = [object description];
//    id retObj = [mediator safePerformActionWithTarget:object action:sel parameters:nil];
//    NSLog(@"retStr = %@, retObj = %@", retStr, retObj);
//    XCTAssert(retObj, @"perform error");
    
    [mediator performLocalActionWithTarget:@"ViewController" action:@"notFound" parameters:nil cacheTarget:NO];
}

@end
