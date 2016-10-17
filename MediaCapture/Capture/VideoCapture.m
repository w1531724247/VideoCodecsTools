//
//  VideoCapture.m
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "VideoCapture.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface VideoCapture ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;

@property (nonatomic) dispatch_queue_t sessionQueue;


@end

@implementation VideoCapture


@end
