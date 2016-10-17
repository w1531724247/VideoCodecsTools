//
//  ViewController.m
//  MediaCapture
//
//  Created by QMTV on 16/10/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "ViewController.h"
#import "CaptureSession.h"

@interface ViewController ()
@property (nonatomic, strong) CaptureSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.session = [[CaptureSession alloc] initWithPreView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
