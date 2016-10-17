//
//  FLVScriptTagData.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "FLVTag.h"

typedef NS_ENUM(NSInteger, AMFDataType) {//tag类型
    AMF_DATA_TYPE_NUMBER      = 0x00,//数字
    AMF_DATA_TYPE_BOOL        = 0x01,//bool
    AMF_DATA_TYPE_STRING      = 0x02,//字符串
    AMF_DATA_TYPE_OBJECT      = 0x03,//对象
    AMF_DATA_TYPE_NULL        = 0x05,//null
    AMF_DATA_TYPE_UNDEFINED   = 0x06,//未定义
    AMF_DATA_TYPE_REFERENCE   = 0x07,//引用
    AMF_DATA_TYPE_MIXEDARRAY  = 0x08,//数组
    AMF_DATA_TYPE_OBJECT_END  = 0x09,//对象尾,表示object结束
    AMF_DATA_TYPE_ARRAY       = 0x0a,//数组
    AMF_DATA_TYPE_DATE        = 0x0b,//日期
    AMF_DATA_TYPE_LONG_STRING = 0x0c,//长字符串
    AMF_DATA_TYPE_UNSUPPORTED = 0x0d//不支持
};

@interface FLVScriptTag : FLVTag

@end
