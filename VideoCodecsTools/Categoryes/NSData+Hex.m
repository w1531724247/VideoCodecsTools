//
//  NSData+Hex.m
//  FlvEye
//
//  Created by QMTV on 16/10/11.
//  Copyright © 2016年 LFC. All rights reserved.
//

#import "NSData+Hex.h"

@implementation NSData (Hex)

- (NSString *)hexText {
    NSString *dataText = [NSString string];
    NSUInteger dataLength = self.length;
    unsigned char c;
    for (int i = 0; i < dataLength; i++) {
        if (i%4 == 0 && i >0) {
            printf(" ");
        }
        if (i%16 == 0 && i > 0) {
            printf("\n");
        }
        [self getBytes:&c range:NSMakeRange(i, 1)];
        printf("%02x", c);
    }
    
    return dataText;
}

- (int)dataToInt {
    if (self.length > sizeof(int)) {
        return -1;
    }
    
    int length = 0;
    uint8_t num = 0;
    for (int i = 0; i < self.length; i++) {
        [self getBytes:&num range:NSMakeRange(i, 1)];
        length = length + num;
        if (i != (self.length - 1)) {
            length = length << 8;
        }
    }
    
    return length;
}


@end
