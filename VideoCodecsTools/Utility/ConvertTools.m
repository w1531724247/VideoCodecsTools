//
//  ConvertTools.m
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "ConvertTools.h"
#import "FLVAnalyzer.h"
#import "NSData+Hex.h"
#import "FLVVideoTag.h"
#import "FLVVideoTag+SPSPPS.h"

@interface ConvertTools ()

@property (nonatomic, strong) FLVAnalyzer *analyzer;

@end

@implementation ConvertTools

- (void)convertFLV:(NSString *)flvPath toH264:(NSString *)h264Path {
    self.analyzer = [[FLVAnalyzer alloc] initWithFilePath:flvPath];
    [self.analyzer dumpTag];
    
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    for (int i = 0; i < self.analyzer.videoTagArray.count; i++) {
        FLVVideoTag *videoTag = [self.analyzer.videoTagArray objectAtIndex:i];
        if (0 == i) {
            [h264Data appendData:[self NALUStartData]];
            [h264Data appendData:[videoTag sequenceParameterSetNALUnits]];
            [h264Data appendData:[self NALUStartData]];
            [h264Data appendData:[videoTag pictureParameterSetNALUnits]];
        } else {
            NSData *nalusData = [self generateNaulSequenceWithData:[videoTag nalusData]];
            [h264Data appendData:nalusData];
        }
    }
    
    [h264Data writeToFile:h264Path atomically:YES];
}

- (void)convertH264:(NSString *)h264Path toFLV:(NSString *)flvPath {
    
}

- (NSData *)generateNaulSequenceWithData:(NSData *)nalusData {
    //将flv中的nalu的长度数据,换成h264中nalu的起始码(都是4个字节)
    NSMutableData *naulSequenceData = [NSMutableData data];
    for (int i = 0; i < nalusData.length;) {
        [naulSequenceData appendData:[self NALUStartData]];
        NSData *naluLengthData = [nalusData subdataWithRange:NSMakeRange(i, 4)];
        i +=4 ;
        int naluLength = [naluLengthData dataToInt];
        NSData *naluData = [nalusData subdataWithRange:NSMakeRange(i, naluLength)];
        i += naluLength;
        
        [naulSequenceData appendData:naluData];
    }
    
    return naulSequenceData;
}

- (NSData *)NALUStartData {
    NSMutableData *separateData = [[NSMutableData alloc] init];
    uint8_t byte = 0x00;
    
    [separateData appendBytes:&byte length:sizeof(uint8_t)];
    [separateData appendBytes:&byte length:sizeof(uint8_t)];
    [separateData appendBytes:&byte length:sizeof(uint8_t)];
    byte = 0x01;
    [separateData appendBytes:&byte length:sizeof(uint8_t)];
    
    return separateData;
}

- (uint8_t)aStringToUint8_t:(NSString *)aString {
    if (aString.length > 1) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"只能一个字符一个字符的逐个转换哦" userInfo:nil];
    }
    
    uint8_t value = 0;
    if ([aString isEqualToString:@"0"]) {
        value = 0x0;
    }
    if ([aString isEqualToString:@"1"]) {
        value = 0x1;
    }
    if ([aString isEqualToString:@"2"]) {
        value = 0x2;
    }
    if ([aString isEqualToString:@"3"]) {
        value = 0x3;
    }
    if ([aString isEqualToString:@"4"]) {
        value = 0x4;
    }
    if ([aString isEqualToString:@"5"]) {
        value = 0x5;
    }
    if ([aString isEqualToString:@"6"]) {
        value = 0x6;
    }
    if ([aString isEqualToString:@"7"]) {
        value = 0x7;
    }
    if ([aString isEqualToString:@"8"]) {
        value = 0x8;
    }
    if ([aString isEqualToString:@"9"]) {
        value = 0x9;
    }
    if ([aString isEqualToString:@"a"] || [aString isEqualToString:@"A"]) {
        value = 0xA;
    }
    if ([aString isEqualToString:@"b"] || [aString isEqualToString:@"B"]) {
        value = 0xB;
    }
    if ([aString isEqualToString:@"c"] || [aString isEqualToString:@"C"]) {
        value = 0xC;
    }
    if ([aString isEqualToString:@"d"] || [aString isEqualToString:@"D"]) {
        value = 0xD;
    }
    if ([aString isEqualToString:@"e"] || [aString isEqualToString:@"E"]) {
        value = 0xE;
    }
    if ([aString isEqualToString:@"f"] || [aString isEqualToString:@"F"]) {
        value = 0xF;
    }
    return value;
}

@end
