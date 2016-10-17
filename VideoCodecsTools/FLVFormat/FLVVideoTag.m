//
//  FLVVideoTagData.m
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVVideoTag.h"
@interface FLVVideoTag ()

@end

@implementation FLVVideoTag

#pragma mark ----- getter

- (FLVVideoTagDataFrameType)frameTpye {
    uint8_t firstByte = 0;
    [self.bodyData getBytes:&firstByte length:1];
    firstByte = firstByte >> 4;
    switch (firstByte) {
        case Video_Tag_Data_Frame_Type_KEYFRAME:
            return Video_Tag_Data_Frame_Type_KEYFRAME;
            break;
        case Video_Tag_Data_Frame_Type_INTER_FRAME:
            return Video_Tag_Data_Frame_Type_INTER_FRAME;
            break;
        case Video_Tag_Data_Frame_Type_DISPOSABLE_INTER_FRAME:
            return Video_Tag_Data_Frame_Type_DISPOSABLE_INTER_FRAME;
            break;
        case Video_Tag_Data_Frame_Type_GENERATED_KEYFRAME:
            return Video_Tag_Data_Frame_Type_GENERATED_KEYFRAME;
            break;
        case Video_Tag_Data_Frame_Type_VIDEO_INFO_OR_COMMAND_FRAME:
            return Video_Tag_Data_Frame_Type_VIDEO_INFO_OR_COMMAND_FRAME;
            break;
        default:
            return Video_Tag_Data_Frame_Type_KEYFRAME;
            break;
    }
}

- (FLVVideoTagDataCodecID)codecID {
    uint8_t firstByte = 0;
    [self.bodyData getBytes:&firstByte length:1];
    firstByte = firstByte << 4;
    firstByte = firstByte >> 4;
    switch (firstByte) {
        case Video_CodecID_H263_Video_Packet:
            return Video_CodecID_H263_Video_Packet;
            break;
        case Video_CodecID_Screen_Video_Packet:
            return Video_CodecID_Screen_Video_Packet;
            break;
        case Video_CodecID_VP6_FLV_Video_Packet:
            return Video_CodecID_VP6_FLV_Video_Packet;
            break;
        case Video_CodecID_VP6_FLV_Alpha_Video_Packet:
            return Video_CodecID_VP6_FLV_Alpha_Video_Packet;
            break;
        case Video_CodecID_Screen_V2_Video_Packet:
            return Video_CodecID_Screen_V2_Video_Packet;
            break;
        case Video_CodecID_AVC_Video_Packet:
            return Video_CodecID_AVC_Video_Packet;
            break;
        default:
            return Video_CodecID_H263_Video_Packet;
            break;
    }
}

- (NSData *)videoData {
    if (!_videoData) {
        _videoData = [self.bodyData subdataWithRange:NSMakeRange(1, self.bodyData.length - 1)];
    }
    return _videoData;
}

- (AVCVideoPacketType)packetType {
    uint8_t secondByte = 0;
    [self.videoData getBytes:&secondByte range:NSMakeRange(0, 1)];
    
    switch (secondByte) {
        case AVC_Video_Packet_Type_Sequence_Header:
            return AVC_Video_Packet_Type_Sequence_Header;
            break;
        case AVC_Video_Packet_Type_NALU:
            return AVC_Video_Packet_Type_NALU;
            break;
        case AVC_Video_Packet_Type_Sequence_End:
            return AVC_Video_Packet_Type_Sequence_End;
            break;
        default:
            return AVC_Video_Packet_Type_Sequence_Header;
            break;
    }
}

- (uint32_t)compositionTime {
    uint32_t timeByte = 0;
    [self.videoData getBytes:&timeByte range:NSMakeRange(1, 3)];
    
    return timeByte;
}

- (NSData *)nalusData {
    if (self.packetType == AVC_Video_Packet_Type_NALU) {
        //从第五字节开始
        return [self.videoData subdataWithRange:NSMakeRange(4, self.videoData.length - 4)];
    } else if (self.packetType == AVC_Video_Packet_Type_Sequence_Header){
        return [self.videoData subdataWithRange:NSMakeRange(4, self.videoData.length - 4)];
    } else if (self.packetType == AVC_Video_Packet_Type_Sequence_End) {
        @throw [NSException exceptionWithName:@"错误信息:" reason:@"这是最后一个VideoTag" userInfo:nil];
        return nil;
    }
    
    return nil;
}

@end
