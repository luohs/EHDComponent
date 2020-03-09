//
//  EHDTestCViewController.m
//  EHDComponent
//
//  Created by luohs on 2017/10/20.
//  Copyright © 2017年 luohs. All rights reserved.
//

#import "EHDTestCViewController.h"
@interface EHDTestCViewController ()

@end

@implementation EHDTestCViewController
EHD_EXPORT_COMPONENT
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"EHDTestCViewController";
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarItemAction:(id)sender
{
    if (self.presentingViewController ||
        self.navigationController.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    //[self.uiBus popComponent];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (UIViewController *)uInterface
//{
//    return self;
//}
@end
