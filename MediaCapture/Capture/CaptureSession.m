//
//  CaptureSession.m
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/14.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "CaptureSession.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

typedef NS_ENUM( NSInteger, AVSetupResult) {
    AVSetupResultSuccess,
    AVSetupResultCameraNotAuthorized,
    AVSetupResultSessionConfigurationFailed
};

@interface CaptureSession ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic) dispatch_queue_t videoHandleQueue;
@property (nonatomic, assign) AVSetupResult videoSetupResult;

@property (nonatomic, assign) AVSetupResult audioSetupResult;
@property (nonatomic, assign) BOOL setupResult;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CaptureSession

- (instancetype)init {
    if (self = [super init]) {
        [self requireAccessCamera];
        [self requireAccessMicrophone];
        
        dispatch_async(self.sessionQueue, ^{
            if (self.videoSetupResult == AVSetupResultSuccess && self.audioSetupResult == AVSetupResultSuccess) {
                [self setupDevice];
                self.setupResult = YES;
            } else {
                self.setupResult = NO;
            }
        });
    }
    return self;
}

- (instancetype)initWithPreView:(UIView *)preview {
    self = [[CaptureSession alloc] init];
    
    dispatch_async( self.sessionQueue, ^{
        
        if (self.setupResult) {
            self.preview = preview;
        } else {
            dispatch_async( dispatch_get_main_queue(), ^{
                NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                // Provide quick access to Settings.
                UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                [alertController addAction:settingsAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            } );
        }
    } );
    
    return self;
}

#pragma mark ----pubilc
- (void)startRunning {
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession startRunning];
    });
}

- (void)stopRunning {
    [self.captureSession stopRunning];
}

#pragma mark ---- AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"<INFO> 采集到一帧图像");
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"<INFO> 丢失了一帧图像");
}

#pragma mark ---- private
- (void)setupDevice {
    // 配置采集输入源（摄像头）
    NSError *error = nil;
    // 获得一个采集设备，例如前置/后置摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 用设备初始化一个采集的输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"Error getting video input device: %@", error.description);
    }
    [self.captureSession beginConfiguration];
    
    if ([self.captureSession canAddInput:videoDeviceInput]) {
        [self.captureSession addInput:videoDeviceInput]; // 添加到Session
        self.videoDevice = videoDevice;
        self.videoDeviceInput = videoDeviceInput;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Why are we dispatching this to the main queue?
            // Because AVCaptureVideoPreviewLayer is the backing layer for AAPLPreviewView and UIView
            // can only be manipulated on the main thread.
            // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
            // on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
            
            // Use the status bar orientation as the initial video orientation. Subsequent orientation changes are handled by
            // -[viewWillTransitionToSize:withTransitionCoordinator:].
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
            if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
            }
            
        } );

    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    
    if (!audioDeviceInput) {
        NSLog( @"Could not create audio device input: %@", error );
    }
    
    if ( [self.captureSession canAddInput:audioDeviceInput] ) {
        [self.captureSession addInput:audioDeviceInput];
    } else {
        NSLog( @"Could not add audio device input to the session" );
    }
    
    [self.captureSession commitConfiguration];
    
    // 配置采集输出，即我们取得视频图像的接口
    self.videoHandleQueue = dispatch_queue_create("video.capture.queue", DISPATCH_QUEUE_SERIAL);
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoHandleQueue];
    // 配置输出视频图像格式
    NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.videoOutput.videoSettings = captureSettings;
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;
    
    if ([self.captureSession canAddOutput:self.videoOutput]) {
        [self.captureSession addOutput:self.videoOutput];  // 添加到Session
    }
}

- (void)requireAccessCamera {
    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
    {
        case AVAuthorizationStatusAuthorized:
        {
            // The user has previously granted access to the camera.
            self.videoSetupResult = AVSetupResultSuccess;
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            dispatch_suspend( self.sessionQueue );
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
                if ( ! granted ) {
                    self.videoSetupResult = AVSetupResultSuccess;
                } else {
                    self.videoSetupResult = AVSetupResultSessionConfigurationFailed;
                }
                dispatch_resume( self.sessionQueue );
            }];
            break;
        }
        case AVAuthorizationStatusDenied: {
            self.videoSetupResult = AVSetupResultSessionConfigurationFailed;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您到设置中开启摄像头访问权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
        {
            // The user has previously denied access.
            self.videoSetupResult = AVSetupResultSuccess;
            break;
        }
    }
}

- (void)requireAccessMicrophone {
    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] )
    {
        case AVAuthorizationStatusAuthorized:
        {
            // The user has previously granted access to the camera.
            self.audioSetupResult = AVSetupResultSuccess;
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // The user has not yet been presented with the option to grant video access.
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            dispatch_suspend( self.sessionQueue );
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^( BOOL granted ) {
                if ( ! granted ) {
                    self.audioSetupResult = AVSetupResultSuccess;
                } else {
                    self.audioSetupResult = AVSetupResultSessionConfigurationFailed;
                }
                dispatch_resume(self.sessionQueue);
            }];
            break;
        }
        case AVAuthorizationStatusDenied: {
            self.audioSetupResult = AVSetupResultSessionConfigurationFailed;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您到设置中开启麦克风访问权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
        {
            // The user has previously denied access.
            self.audioSetupResult = AVSetupResultSuccess;
            break;
        }
    }
}

#pragma mark --- setter
- (void)setPreview:(UIView *)preview {
    _preview = preview;
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.previewLayer.session = self.captureSession;
    [preview.layer addSublayer:self.previewLayer];
    self.previewLayer.frame = preview.layer.bounds;
}

#pragma mark ---- getter

- (dispatch_queue_t)sessionQueue {
    if (!_sessionQueue) {
        _sessionQueue = dispatch_queue_create("capture.session.queue", DISPATCH_QUEUE_SERIAL );
    }
    return _sessionQueue;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}


@end
