//
//  FLVAnalyzer.m
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/12.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FLVAnalyzer.h"
#import "FLVHeader.h"
#import "FLVTag.h"
#import "FLVVideoTag.h"
#import "NSData+Hex.h"

@interface FLVAnalyzer ()
@property (nonatomic, strong) NSData *flvData;
@property (nonatomic, strong) FLVHeader *headerData;
@property (nonatomic, assign) NSUInteger nextTagIndex;//下一个tag的起始位置
@property (nonatomic, strong) FLVTag *scriptTag;

@property (nonatomic, strong) NSMutableArray *videoTags;
@property (nonatomic, strong) NSMutableArray *audioTags;

@end

@implementation FLVAnalyzer

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.videoTags = [NSMutableArray array];
        self.audioTags = [NSMutableArray array];
        self.flvData = [NSData dataWithContentsOfFile:filePath];
        self.headerData = [[FLVHeader alloc] initWithData:[self.flvData subdataWithRange:NSMakeRange(0, 13)]];
        self.nextTagIndex = self.headerData.data.length;
    }
    
    return self;
}

#pragma mark ----- public
- (void)dumpTag {
    while (1) {
        if (self.nextTagIndex < self.flvData.length) {
            FLVTag *currentTag = [[FLVTag alloc] initWithLocal:self.nextTagIndex flvData:self.flvData];
            if (!currentTag.data) {
                break;
            }
            switch (currentTag.header.type) {
                case FLV_TAG_TYPE_AUDIO: {//音频信息
                    
                }
                    break;
                case FLV_TAG_TYPE_VIDEO: {//视频信息
                    FLVVideoTag *videoTag = [[FLVVideoTag alloc] initWithLocal:self.nextTagIndex flvData:self.flvData];
                    [self.videoTags addObject:videoTag];
                }
                    break;
                case FLV_TAG_TYPE_META: {//数据信息
                    self.scriptTag = currentTag;
                }
                    break;
                    
                default:
                    break;
            }
            
            self.nextTagIndex = self.nextTagIndex + currentTag.data.length + 4;
        } else {
            break;
        }
    }
}

- (void)firstVideoTagInfo {
    
}

- (void)compareFile:(NSString *)aFilePath andFile:(NSString *)bFilePath {
    NSData *aData = [NSData dataWithContentsOfFile:aFilePath];
    NSData *bData = [NSData dataWithContentsOfFile:bFilePath];
    NSInteger num = 0;
    if (aData.length != bData.length) {
        NSLog(@"文件大小不一样");
    } else if (aData.length == bData.length) {
        for (int i = 0; i < aData.length; i++) {
            uint8_t aByte = 0;
            uint8_t bByte = 0;
            [aData getBytes:&aByte range:NSMakeRange(i, 1)];
            [bData getBytes:&bByte range:NSMakeRange(i, 1)];
            if (aByte == bByte) {
                
            } else {
                num++;
            }
        }
        NSLog(@"有%ld个字节不一样", num);
    }
}

#pragma mark ----- getter
- (NSArray *)videoTagArray {
    
    return [NSArray arrayWithArray:self.videoTags];
}

- (NSArray *)audioTagArray {
    
    return [NSArray arrayWithArray:self.audioTags];
}

@end
