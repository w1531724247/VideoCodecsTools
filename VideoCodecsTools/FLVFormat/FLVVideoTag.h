//
//  FLVVideoTagData.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVTag.h"

typedef NS_ENUM(NSInteger, FLVVideoTagDataFrameType) {//帧类型
    Video_Tag_Data_Frame_Type_KEYFRAME        = 0x01,//关键帧
    Video_Tag_Data_Frame_Type_INTER_FRAME      = 0x02,//非关键帧
    Video_Tag_Data_Frame_Type_DISPOSABLE_INTER_FRAME      = 0x03,//h263的非关键帧
    Video_Tag_Data_Frame_Type_GENERATED_KEYFRAME        = 0x04,//为服务器生成关键帧
    Video_Tag_Data_Frame_Type_VIDEO_INFO_OR_COMMAND_FRAME   = 0x05,//视频信息或命令帧
};

typedef NS_ENUM(NSInteger, FLVVideoTagDataCodecID) {//编码类型
    Video_CodecID_H263_Video_Packet        = 0x02,//H263VideoPacket
    Video_CodecID_Screen_Video_Packet      = 0x03,//ScreenVideopacket
    Video_CodecID_VP6_FLV_Video_Packet      = 0x04,//VP6FLVVideoPacket
    Video_CodecID_VP6_FLV_Alpha_Video_Packet        = 0x05,//VP6FLVAlphaVideoPacket
    Video_CodecID_Screen_V2_Video_Packet   = 0x06,//ScreenV2VideoPacket
    Video_CodecID_AVC_Video_Packet   = 0x07,//AVCVideoPacket(h264)
};

typedef NS_ENUM(NSInteger, AVCVideoPacketType) {//
    AVC_Video_Packet_Type_Sequence_Header       = 0x00,//为AVCSequence Header
    AVC_Video_Packet_Type_NALU      = 0x01,//为AVC NALU
    AVC_Video_Packet_Type_Sequence_End      = 0x02,//为AVC end ofsequence
};

@interface FLVVideoTag : FLVTag

@property (nonatomic, assign, readonly) FLVVideoTagDataFrameType frameTpye;
@property (nonatomic, assign, readonly) FLVVideoTagDataCodecID codecID;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, assign, readonly) AVCVideoPacketType packetType;
@property (nonatomic, assign, readonly) uint32_t compositionTime;//相对时间
@property (nonatomic, assign, readonly) NSData *nalusData;//在AVC_Video_Packet_Type_Sequence_Header中是AVCDecodeConfigurationRecord, 在AVC_Video_Packet_Type_NALU中是NALU数据(可能只包含一个NALU数据,也可能包含多个NALU数据)

@end
