//
//  FLVVideoTagData+SPSPPS.h
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "FLVVideoTag.h"

/**
 *  FLV中第一个VideoTag(索引是0), 包含的是SPS,和PPS的信息
 */

@interface FLVVideoTag (SPSPPS)

- (int)configurationVersion;
- (int)AVCProfileIndication;
- (int)profile_compatibility;
- (int)AVCLevelIndication;
- (int)lengthSizeMinusOne;//FLV中NALU包长数据所使用的字节数, (lengthSizeMinusOne & 3）+1

- (int)numOfSequenceParameterSets;//SPS 的个数
- (int)sequenceParameterSetLength;//SPS 的长度
- (NSData *)sequenceParameterSetNALUnits;//SPS

- (int)numOfPictureParameterSets;//PPS 的个数
- (int)pictureParameterSetLength;//PPS 的长度
- (NSData *)pictureParameterSetNALUnits;//PPS
@end
