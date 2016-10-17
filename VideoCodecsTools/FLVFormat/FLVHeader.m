//
//  FLVHeader.m
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVHeader.h"
@interface FLVHeader ()

@property (nonatomic, strong) NSData *flvFormatData;
@property (nonatomic, strong) NSData *flvVersionData;
@property (nonatomic, strong) NSData *flvStreamInfoData;
@property (nonatomic, strong) NSData *flvHeaderLengthData;
@property (nonatomic, strong) NSData *preTagLengthData;
@end

@implementation FLVHeader

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        if (data) {
            _data = data;
        }
    }
    
    return self;
}

- (NSData *)flvFormatData {
    return [self.data subdataWithRange:NSMakeRange(0, 3)];
}

- (NSData *)flvVersionData {
    return [self.data subdataWithRange:NSMakeRange(self.flvFormatData.length, 1)];
}

- (NSData *)flvStreamInfoData {
    return [self.data subdataWithRange:NSMakeRange(self.flvFormatData.length + self.flvVersionData.length, 1)];
}

- (NSData *)flvHeaderLengthData {
    return [self.data subdataWithRange:NSMakeRange(self.flvFormatData.length + self.flvVersionData.length + self.flvStreamInfoData.length, 4)];
}

- (NSData *)preTagLengthData {
    return [self.data subdataWithRange:NSMakeRange(self.flvFormatData.length + self.flvVersionData.length + self.flvStreamInfoData.length + self.flvHeaderLengthData.length, 4)];
}

- (NSString *)formatString {
    NSString *formatString = [NSString string];
    if (!_data) {
        return formatString;
    }
    
    int headerLength = 3;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.flvFormatData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        formatString = [formatString stringByAppendingString:charString];
    }
    
    return formatString;
}

- (NSString *)flvVersion {
    NSString *flvVersion = [NSString string];
    if (!_data) {
        return flvVersion;
    }
    
    uint8_t c;
    [self.flvVersionData getBytes:&c range:NSMakeRange(0, 1)];
    NSString* charString = [NSString stringWithFormat:@"%02x " , c];
    flvVersion = [flvVersion stringByAppendingString:charString];
    
    return flvVersion;
}

- (FLVStreamType)flvStreamType {
    uint8_t c;
    [self.flvStreamInfoData getBytes:&c range:NSMakeRange(0, 1)];
    switch (c) {
        case 5:
            return FLV_STREAM_TYPE_DATA;
            break;
        case 4:
            return FLV_STREAM_TYPE_VIDEO;
            break;
        case 1:
            return FLV_STREAM_TYPE_AUDIO;
            break;
            
        default:
            return FLV_STREAM_TYPE_DATA;
            break;
    }
}

- (NSString *)flvHeaderLength {
    NSString *flvHeaderLength = [NSString string];
    if (!_data) {
        return flvHeaderLength;
    }
    
    int headerLength = 4;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.flvHeaderLengthData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        flvHeaderLength = [flvHeaderLength stringByAppendingString:charString];
    }
    
    return flvHeaderLength;
}

- (NSString *)preTagLength {
    NSString *preTagLength = [NSString string];
    if (!_data) {
        return preTagLength;
    }
    
    int length = 4;
    for (int i = 0; i < length; i++) {
        uint8_t c;
        [self.preTagLengthData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        preTagLength = [preTagLength stringByAppendingString:charString];
    }
    
    return preTagLength;
}

@end
