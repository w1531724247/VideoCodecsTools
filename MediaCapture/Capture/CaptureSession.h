//
//  CaptureSession.h
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CaptureSession : NSObject

@property (nonatomic, strong) UIView *preview;

- (instancetype)initWithPreView:(UIView *)preview;
- (void)startRunning;
- (void)stopRunning;

@end
