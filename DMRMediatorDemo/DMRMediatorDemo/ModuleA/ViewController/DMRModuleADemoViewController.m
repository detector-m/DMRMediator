//
//  DMRModuleADemoViewController.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "DMRModuleADemoViewController.h"

@interface DMRModuleADemoViewController ()
@property (nonatomic, strong, readwrite) UILabel *valueLabel;
@end

@implementation DMRModuleADemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
    [self.view addSubview:self.valueLabel];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 150;
    frame.size.height = 50;
    self.valueLabel.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters / Getters
- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.font = [UIFont systemFontOfSize:30];
        _valueLabel.textColor = [UIColor blackColor];
    }
    return _valueLabel;
}
@end
