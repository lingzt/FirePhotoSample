//
//  ViewController.h
//  FirePhotoSample
//
//  Created by ling toby on 7/5/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

