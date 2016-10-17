//
//  FLVHeader.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FLVStreamType) {//flv流格式类型
    FLV_STREAM_TYPE_VIDEO = 0x01,//视频流
    FLV_STREAM_TYPE_AUDIO = 0x04,//音频流
    FLV_STREAM_TYPE_DATA = 0x05//数据流
};

@interface FLVHeader : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *formatString;
@property (nonatomic, copy) NSString *flvVersion;
@property (nonatomic, copy) NSString *flvHeaderLength;
@property (nonatomic, copy) NSString *preTagLength;
@property (nonatomic, assign) FLVStreamType flvStreamType;

- (instancetype)initWithData:(NSData *)data;

@end
