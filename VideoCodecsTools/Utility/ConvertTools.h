//
//  ConvertTools.h
//  VideoCodecsTools
//
//  Created by QMTV on 16/10/13.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConvertTools : NSObject

- (void)convertFLV:(NSString *)flvPath toH264:(NSString *)h264Path;
- (void)convertH264:(NSString *)h264Path toFLV:(NSString *)flvPath;

@end
