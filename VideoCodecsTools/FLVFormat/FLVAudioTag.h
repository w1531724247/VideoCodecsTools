//
//  FLVAudioTagData.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVTag.h"

typedef NS_ENUM(NSInteger, FLVAudioSoundFormat) {//音频类型
    Audio_Sound_Type_Format_Linear_PCM_Platform_Endian        = 0x00,
    Audio_Sound_Type_Format_AD_PCM        = 0x01,
    Audio_Sound_Type_Format_MP3        = 0x02,
    Audio_Sound_Type_Format_Linear_PCM_Little_Endian        = 0x03,
    Audio_Sound_Type_Format_Nellymoser_16kHz_Mono        = 0x04,
    Audio_Sound_Type_Format_Nellymoser_8kHz_Mono        = 0x05,
    Audio_Sound_Type_Format_Nellymoser        = 0x06,
    Audio_Sound_Type_Format_G711_A_law_Logarithmic_PCM        = 0x07,
    Audio_Sound_Type_Format_G711_Mu_law_Logarithmic_PCM        = 0x08,
    Audio_Sound_Type_Format_Reserved        = 0x09,
    Audio_Sound_Type_Format_AAC        = 0x0A,
    Audio_Sound_Type_Format_Speex        = 0x0B,//没有12, 13这两种情况
    Audio_Sound_Type_Format_MP3_8kHz        = 0x0E,
    Audio_Sound_Type_Format_Device_Specific_sound        = 0x0F,
};

typedef NS_ENUM(NSInteger, FLVAudioSoundRate) {//采样率
    Audio_Sound_Rate_5_5kHz        = 0x00,//5.5 kHz
    Audio_Sound_Rate_11kHz        = 0x01,//11 kHz
    Audio_Sound_Rate_22kHz        = 0x02,//22 kHz
    Audio_Sound_Rate_44kHz        = 0x03,//44 kHz
};

typedef NS_ENUM(NSInteger, FLVAudioSoundSize) {//采样点的大小
    Audio_Sound_Size_8bit        = 0x00,//8-bit samples
    Audio_Sound_Size_16bit        = 0x01,//16-bit samples
};

typedef NS_ENUM(NSInteger, FLVAudioSoundType) {//帧类型
    Audio_Sound_Type_Mono        = 0x00,//单声道
    Audio_Sound_Type_Stereo        = 0x01,//立体声
};

@interface FLVAudioTag : FLVTag

@end
