//
//  EHDTestAViewController.m
//  EHDComponent
//
//  Created by luohs on 2017/10/19.
//  Copyright © 2017年 luohs. All rights reserved.
//

#import "EHDTestAViewController.h"

@interface EHDTestAViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation EHDTestAViewController
+ (void)load
{
    [ComponentConfig registerURL:@"ehd://luohs/EHDTestAViewController" handler:^id(NSDictionary *parameters) {
        NSLog(@"%@", parameters);
        return nil;
    }];
}
EHD_EXPORT_COMPONENT
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"EHDTestAViewController";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendBarItemAction:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2, item, nil];
    
    [self.view addSubview:self.label];
}

- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        _label = label;
    }
    return _label;
}

- (void)log
{
    NSLog(@"我是log");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.label.text = [NSString stringWithFormat:@"%@", self.extraData[@"user_id"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.completionBlock(@{@"user_id": @1902});
        
        EHD_SendNotification(@"appdelegate", @{@"user_id": @1902});
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItemAction:(id)sender
{
    [self.uiBus openURL:@"ehd://luohs/EHDTestBViewController?value=中国" transitionBlock:^(__kindof UIViewController * _Nonnull thisInterface, __kindof UIViewController * _Nonnull nextInterface, TransitionCompletionBlock  _Nonnull completionBlock) {
        [thisInterface.navigationController pushViewController:nextInterface animated:YES];
    } extraData:(@{@"user_id": @2100}) completion:^(id  _Nonnull result) {
        [self.eventBus sendEventName:@"TestB" intentData:@{@"user_id": @2101}, @"ehd://LaiYoung_/EHDTestBViewController", nil];
    }];
}



- (void)sendBarItemAction:(id)sender
{
    self.completionBlock(@8);
}

- (void)receiveComponentEventName:(NSString *)eventName intentData:(id)intentData
{
    NSLog(@"\n");
    NSLog(@"className:%@\n", NSStringFromClass(self.class));
    NSLog(@"__func__:%s\n", __func__);
    NSLog(@"eventName:%@\n", eventName);
    NSLog(@"intentData:%@\n", intentData);
    self.label.text = @"";
    self.label.text = [NSString stringWithFormat:@"%@", intentData[@"user_id"]];
}
//- (UIViewController *)uInterface
//{
//    return self;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
