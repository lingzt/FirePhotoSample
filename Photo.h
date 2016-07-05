//
//  Photo.h
//  FirePhotoSample
//
//  Created by ling toby on 7/5/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString *downloadURL;
@property (nonatomic, strong) NSString *timestamp;

-(instancetype)initPhotoWithDownloadURL:(NSString *)downloadURL andTimestamp:(NSString *)timestamp;

@end
