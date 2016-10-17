//
//  FLVVideoTagData+SPSPPS.m
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FLVVideoTag+SPSPPS.h"
#import "NSData+Hex.h"

@implementation FLVVideoTag (SPSPPS)

- (int)configurationVersion {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t version = 0;
    [self.nalusData getBytes:&version range:NSMakeRange(0, 1)];
    
    return version;
}

- (int)AVCProfileIndication {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t indication = 0;
    [self.nalusData getBytes:&indication range:NSMakeRange(1, 1)];
    
    return indication;
}

- (int)profile_compatibility {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t compatibility = 0;
    [self.nalusData getBytes:&compatibility range:NSMakeRange(2, 1)];
    
    return compatibility;
}

- (int)AVCLevelIndication {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t indication = 0;
    [self.nalusData getBytes:&indication range:NSMakeRange(3, 1)];
    
    return indication;
}

- (int)lengthSizeMinusOne {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t lengthSize = 0;
    [self.nalusData getBytes:&lengthSize range:NSMakeRange(4, 1)];
    lengthSize = lengthSize & 0x03;//前6位是保留位, 后2位是lengthSizeMinusOne
    lengthSize += 1;
    
    return lengthSize;
}

- (int)numOfSequenceParameterSets {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t num = 0;
    [self.nalusData getBytes:&num range:NSMakeRange(5, 1)];
    num = num & 0x1f;//前3位是保留位,后5位是num
    
    return num;
}

- (int)sequenceParameterSetLength {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    NSData *lengthData = [self.nalusData subdataWithRange:NSMakeRange(6, 2)];
    int length = [lengthData dataToInt];
    
    return length;
}

- (NSData *)sequenceParameterSetNALUnits {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return nil;
    }
    NSRange range = NSMakeRange(8, self.sequenceParameterSetLength);
    return [self.nalusData subdataWithRange:range];
}

- (int)numOfPictureParameterSets {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    uint8_t num = 0;
    NSRange range = NSMakeRange(8 + self.sequenceParameterSetLength, 1);
    [self.nalusData getBytes:&num range:range];
    
    return num;
}

- (int)pictureParameterSetLength {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return -1;
    }
    
    int length = 0;
    NSRange range = NSMakeRange(8 + self.sequenceParameterSetLength + 1, 2);
    NSData *lengthData = [self.nalusData subdataWithRange:range];
    length = [lengthData dataToInt];
    
    return length;
}

- (NSData *)pictureParameterSetNALUnits {
    if (self.packetType != AVC_Video_Packet_Type_Sequence_Header) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这不是一个AVC_Video_Packet_Type_Sequence_Header的数据" userInfo:nil];
        return nil;
    }
    
    NSRange range = NSMakeRange(8 + self.sequenceParameterSetLength + 1 + 2, self.pictureParameterSetLength);
    return [self.nalusData subdataWithRange:range];
}

@end
