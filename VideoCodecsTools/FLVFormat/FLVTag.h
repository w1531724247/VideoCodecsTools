//
//  FLVTag.h
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLVTagHeader.h"

@interface FLVTag : NSObject

@property (nonatomic, strong, readonly) FLVTagHeader *header;
@property (nonatomic, strong, readonly) NSData *bodyData;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithLocal:(NSUInteger)local flvData:(NSData *)flvData;

@end
