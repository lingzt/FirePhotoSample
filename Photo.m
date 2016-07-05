//
//  Photo.m
//  FirePhotoSample
//
//  Created by ling toby on 7/5/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initPhotoWithDownloadURL:(NSString *)downloadURL andTimestamp:(NSString *)timestamp {
    self = [super init];
    if (self) {
        _downloadURL = downloadURL;
        _timestamp = timestamp;
    }
    return self;
}

@end

