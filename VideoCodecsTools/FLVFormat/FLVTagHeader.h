//
//  FLVTag.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, FLVTagType) {//tag类型
    FLV_TAG_TYPE_AUDIO = 0x08,
    FLV_TAG_TYPE_VIDEO = 0x09,
    FLV_TAG_TYPE_META  = 0x12
};

@interface FLVTagHeader : NSObject
@property (nonatomic, assign) FLVTagType type;
@property (nonatomic, assign) NSUInteger bodySize;
@property (nonatomic, copy) NSString *bodySizeStr;
@property (nonatomic, copy) NSString *timeStampStr;
@property (nonatomic, copy) NSString *timeStampExtendedStr;
@property (nonatomic, copy) NSString *streamIDStr;
@property (nonatomic, strong) NSData *data;

- (instancetype)initWithData:(NSData *)data;

@end
