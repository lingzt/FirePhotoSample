//
//  ViewController.m
//  FirePhotoSample
//
//  Created by ling toby on 7/5/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"

@import Firebase;
@import FirebaseStorage;
@import FirebaseDatabase;

@interface ViewController ()
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
@property (strong, nonatomic) FIRStorage *firebaseStorage;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.imageView.image == nil){
    }else{
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = [self reduceImageSize:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)reduceImageSize:(UIImage *)image {
    NSLog(@"ORIGINAL IMAGE: width-%f, height-%f", image.size.width, image.size.height);
    //creating a frame
    CGSize newSize = CGSizeMake(image.size.width/6, image.size.height/6);
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    //Where to the frame the new painting is going to be placed
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"SMALL IMAGE: width-%f, height-%f", smallImage.size.width, smallImage.size.height);
    return smallImage;
}


- (IBAction)upload:(UIButton *)sender {
    [self firebaseSetUp];
}


- (IBAction)takePicture:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePicker animated:NO completion:nil];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [imagePicker setDelegate:self];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}

- (IBAction)chooseFromGallery:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [imagePicker setDelegate:self];
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:NO completion:nil];
}



#pragma mark Firebase Methods

-(void)firebaseSetUp {
    _firebaseStorage = [FIRStorage storage];
    _firebaseStorageRef = [_firebaseStorage referenceForURL:@"gs://firephotosample.appspot.com"];
    NSData *resizedImgData =  UIImageJPEGRepresentation(_imageView.image, .50);
    [self uploadPhotoToFirebase:resizedImgData];
}

-(void)uploadPhotoToFirebase:(NSData *)imageData {
    
    //Create a uniqueID for the image and add it to the end of the images reference.
    NSString *uniqueID = [[NSUUID UUID]UUIDString];
    NSString *newImageReference = [NSString stringWithFormat:@"images/%@.jpg", uniqueID];
    //imagesRef creates a reference for the images folder and then adds a child to that folder, which will be every time a photo is taken.
    FIRStorageReference *imagesRef = [_firebaseStorageRef child:newImageReference];
    //This uploads the photo's NSData onto Firebase Storage.
    FIRStorageUploadTask *uploadTask = [imagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.description);
        } else {
            Photo *photo = [[Photo alloc]initPhotoWithDownloadURL:[NSString stringWithFormat:@"%@", metadata.downloadURL] andTimestamp:[self createFormattedTimeStamp]];
            [self savePhotoObjectToFirebaseDatabase:photo];
        }
    }];
    [uploadTask resume];
}

-(void)savePhotoObjectToFirebaseDatabase:(Photo *)photo {
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *photosRef = [firebaseRef child:@"photos"].childByAutoId;
    NSDictionary *photoDict = @{@"downloadURL": photo.downloadURL, @"timestamp": photo.timestamp};
    
    [photosRef setValue:photoDict];
}

#pragma mark Timestamp and Date Formatter Methods
-(NSString *)createFormattedTimeStamp {
    NSDate *timestamp = [NSDate date];
    NSString *stringTimestamp = [self formatDate:timestamp];
    return stringTimestamp;
}


-(NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss a"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}




@end
