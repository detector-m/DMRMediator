//
//  ViewController.m
//  DMRMediatorDemo
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import "ViewController.h"
#import "DMRMediator+DMRModuleAMediator.h"

NSString * const kCellIdentifier = @"kCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)dealloc {
    [[DMRMediator sharedMediator] cleanActionTarget];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
    
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//    cell.textLabel.text = self.dataSource[indexPath.row];
//    return cell;
    
    return [[DMRMediator sharedMediator] tableViewCellWithIdentifier:kCellIdentifier tableView:tableView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[DMRMediator sharedMediator] configTableViewCell:cell info:self.dataSource[indexPath.row] indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIViewController *vc = [[DMRMediator sharedMediator] viewControllerForDetail];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    if (indexPath.row == 1) {
        [[DMRMediator sharedMediator] showAlertWithMessage:@"Test Alert" cancelAction:^(NSDictionary * _Nullable info) {
            NSLog(@"%@", info);
        } confirmAction:^(NSDictionary * _Nullable info) {
            NSLog(@"%@", info);
        }];
        
        return;
    }
    
//    if (indexPath.row == 0) {
//        UIViewController *viewController = [[CTMediator sharedInstance] CTMediator_viewControllerForDetail];
//
//        // 获得view controller之后，在这种场景下，到底push还是present，其实是要由使用者决定的，mediator只要给出view controller的实例就好了
//        [self presentViewController:viewController animated:YES completion:nil];
//    }
//
//    if (indexPath.row == 1) {
//        UIViewController *viewController = [[CTMediator sharedInstance] CTMediator_viewControllerForDetail];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
//
//    if (indexPath.row == 2) {
//        // 这种场景下，很明显是需要被present的，所以不必返回实例，mediator直接present了
//        [[CTMediator sharedInstance] CTMediator_presentImage:[UIImage imageNamed:@"image"]];
//    }
//
//    if (indexPath.row == 3) {
//        // 这种场景下，参数有问题，因此需要在流程中做好处理
//        [[CTMediator sharedInstance] CTMediator_presentImage:nil];
//    }
//
//    if (indexPath.row == 4) {
//        [[CTMediator sharedInstance] CTMediator_showAlertWithMessage:@"casa" cancelAction:nil confirmAction:^(NSDictionary *info) {
//            // 做你想做的事
//        }];
//    }
//
//    if (indexPath.row == 5) {
//        TableViewController *tableViewController = [[TableViewController alloc] init];
//        [self presentViewController:tableViewController animated:YES completion:nil];
//    }
//
//    if (indexPath.row == 6) {
//        [[CTMediator sharedInstance] performTarget:@"InvalidTarget" action:@"InvalidAction" params:nil shouldCacheTarget:NO];
//    }
}

#pragma mark - Public
- (void)notFound:(NSDictionary *)parameters {
    NSLog(@"not found");
}
- (void)notFound {
    NSLog(@"not found");
}

#pragma mark - Setters / Getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
//        _dataSource = @[@"present detail view controller",
//                        @"push detail view controller",
//                        @"present image",
//                        @"present image when error",
//                        @"show alert",
//                        @"table view cell",
//                        @"No Target-Action response"
//                        ];
        _dataSource = @[@"push detail view controller",
                        @"show alert",
                        ];
    }
    return _dataSource;
}
@end
