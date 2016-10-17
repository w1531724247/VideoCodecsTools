//
//  FLVTag.m
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVTagHeader.h"

@interface FLVTagHeader ()

@property (nonatomic, strong) NSData *tagTypeData;
@property (nonatomic, strong) NSData *bodySizeData;
@property (nonatomic, strong) NSData *timeStampData;
@property (nonatomic, strong) NSData *timeStampExtendedData;
@property (nonatomic, strong) NSData *streamIDData;

@end

@implementation FLVTagHeader

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        if (data) {
            _data = data;
        }
    }
    
    return self;
}

- (NSData *)tagTypeData {
    return [self.data subdataWithRange:NSMakeRange(0, 1)];
}

- (NSData *)bodySizeData {
    return [self.data subdataWithRange:NSMakeRange(self.tagTypeData.length, 3)];
}

- (NSData *)timeStampData {
    return [self.data subdataWithRange:NSMakeRange(self.tagTypeData.length + self.bodySizeData.length, 3)];
}

- (NSData *)timeStampExtendedData {
    return [self.data subdataWithRange:NSMakeRange(self.tagTypeData.length + self.bodySizeData.length + self.timeStampData.length, 1)];
}

- (NSData *)streamIDData {
    return [self.data subdataWithRange:NSMakeRange(self.tagTypeData.length + self.bodySizeData.length + self.timeStampData.length + self.streamIDData.length, 3)];
}

- (FLVTagType)type {
    uint8_t c;
    [self.tagTypeData getBytes:&c range:NSMakeRange(0, 1)];
    switch (c) {
        case 0x08:
            return FLV_TAG_TYPE_AUDIO;
            break;
        case 0x09:
            return FLV_TAG_TYPE_VIDEO;
            break;
        case 0x12:
            return FLV_TAG_TYPE_META;
            break;
            
        default:
            return FLV_TAG_TYPE_META;
            break;
    }
}

- (NSString *)bodySizeStr {
    NSString *bodySizeStr = [NSString string];
    if (!_data) {
        return bodySizeStr;
    }
    
    int headerLength = 3;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.bodySizeData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        bodySizeStr = [bodySizeStr stringByAppendingString:charString];
    }
    
    return bodySizeStr;
}

- (NSString *)timeStampStr {
    NSString *timeStampStr = [NSString string];
    if (!_data) {
        return timeStampStr;
    }
    
    int headerLength = 3;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.timeStampData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        timeStampStr = [timeStampStr stringByAppendingString:charString];
    }
    
    return timeStampStr;
}

- (NSString *)timeStampExtendedStr {
    NSString *timeStampExtendedStr = [NSString string];
    if (!_data) {
        return timeStampExtendedStr;
    }
    
    int headerLength = 1;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.timeStampExtendedData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        timeStampExtendedStr = [timeStampExtendedStr stringByAppendingString:charString];
    }
    
    return timeStampExtendedStr;
}

- (NSString *)streamIDStr {
    NSString *streamIDStr = [NSString string];
    if (!_data) {
        return streamIDStr;
    }
    
    int headerLength = 3;
    for (int i = 0; i < headerLength; i++) {
        uint8_t c;
        [self.timeStampData getBytes:&c range:NSMakeRange(i, 1)];
        NSString* charString = [NSString stringWithFormat:@"%02x " , c];
        streamIDStr = [streamIDStr stringByAppendingString:charString];
    }
    
    return streamIDStr;
}

- (NSUInteger)bodySize {
    NSUInteger bodySize;
    [self.bodySizeData getBytes:&bodySize length:self.bodySizeData.length];
    
    return bodySize;
}

@end
