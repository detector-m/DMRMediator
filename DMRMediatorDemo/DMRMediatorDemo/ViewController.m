//
//  ViewController.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public
- (void)notFound:(NSDictionary *)parameters {
    NSLog(@"not found");
}
- (void)notFound {
    NSLog(@"not found");
}
@end
