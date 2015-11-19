//
//  ANYViewController.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/15.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYViewController.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface ANYViewController ()

@end

@implementation ANYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
