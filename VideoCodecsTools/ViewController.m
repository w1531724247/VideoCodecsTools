//
//  ViewController.m
//  FlvEye
//
//  Created by LFC on 16/10/10.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "ViewController.h"
#import "FLVAnalyzer.h"
#import "FLVTag.h"
#import "NSData+Hex.h"
#import "FLVVideoTag.h"
#import "FLVVideoTag+SPSPPS.h"
#import "ConvertTools.h"

@interface ViewController ()

@property (nonatomic, strong) FLVAnalyzer *flv_analyzer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    ConvertTools *tool = [[ConvertTools alloc] init];
    NSString *myH264FilePath = @"/Users/QMTV/Desktop/444-L4.264";//[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"444-L4.h264"];
    [tool convertFLV:[[NSBundle mainBundle] pathForResource:@"333-L4" ofType:@"flv"] toH264:myH264FilePath];
//    NSString *h264FilePath = [[NSBundle mainBundle] pathForResource:@"333-L4" ofType:@"264"];
//    [self.flv_analyzer compareFile:myH264FilePath andFile:h264FilePath];
}

- (FLVAnalyzer *)flv_analyzer {
    if (!_flv_analyzer) {
        _flv_analyzer = [[FLVAnalyzer alloc] init];
    }
    
    return _flv_analyzer;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

@end
