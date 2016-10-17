//
//  FLVAnalyzer.h
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/12.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLVAnalyzer : NSObject

@property (nonatomic, strong, readonly) NSArray *videoTagArray;
@property (nonatomic, strong, readonly) NSArray *audioTagArray;


- (instancetype)initWithFilePath:(NSString *)filePath;
- (void)dumpTag;
- (void)firstVideoTagInfo;

- (void)compareFile:(NSString *)aFilePath andFile:(NSString *)bFilePath;

@end
