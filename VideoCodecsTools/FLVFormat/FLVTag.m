//
//  FLVTag.m
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVTag.h"
#import "NSData+Hex.h"

@interface FLVTag ()

@property (nonatomic, strong, readwrite) FLVTagHeader *header;
@property (nonatomic, strong, readwrite) NSData *bodyData;
@property (nonatomic, strong) NSData *headerData;
@property (nonatomic, assign) NSUInteger tagLength;
@property (nonatomic, strong, readwrite) NSData *data;

@end

@implementation FLVTag

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        if (data) {
            self.data = data;
        }
    }
    
    return self;
}

- (instancetype)initWithLocal:(NSUInteger)local flvData:(NSData *)flvData {

    if (self = [super init]) {
        if (flvData) {
            
            if (local + 11 < flvData.length) {
                self.headerData = [flvData subdataWithRange:NSMakeRange(local, 11)];
            } else {
                self.data = nil;
            }
            
            if (local + self.tagLength < flvData.length) {
                self.data = [flvData subdataWithRange:NSMakeRange(local, self.tagLength)];
            } else {
                self.data = nil;
            }
            self.header = [[FLVTagHeader alloc] initWithData:self.headerData];
        }
    }
    
    return self;
}

- (NSData *)headerData {
    if (!_headerData) {
        return [self.data subdataWithRange:NSMakeRange(0, 11)];
    }
    
    return _headerData;
}

- (NSData *)bodyData {
    if (!_bodyData) {
        return [self.data subdataWithRange:NSMakeRange(self.headerData.length, self.data.length - self.headerData.length)];
    }
    return _bodyData;
}

- (NSUInteger)tagLength {
    uint32_t bodySize = 0;
    uint8_t bytes[3] = {0};
    NSData *bodySizeData = [self.headerData subdataWithRange:NSMakeRange(1, 3)];
    [bodySizeData getBytes:&bytes range:NSMakeRange(0, 3)];
    
    bodySize = bytes[0];
    bodySize = bodySize << 8;
    bodySize = bodySize + bytes[1];
    bodySize = bodySize << 8;
    bodySize = bodySize + bytes[2];
    
    NSInteger tagLength = bodySize + self.headerData.length;
    
    return  tagLength;
}

@end
