//
//  ViewController.m
//  Live Photos
//
//  Created by Jay Versluis on 30/09/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import Photos;
@import PhotosUI;
@import MobileCoreServices;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHLivePhotoViewDelegate>

@property BOOL livePhotoIsAnimating;

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

- (IBAction)grabLivePhoto:(id)sender {
    
    // create an image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    // make sure we include Live Photos (otherwise we'll only get UIImages)
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];
    picker.mediaTypes = mediaTypes;
    
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)playHint:(id)sender {
    
    // grab a reference to our Photo View
    PHLivePhotoView *photoView = [self.view viewWithTag:87];
    
    // if we're currently animating, ignore this request
    if (self.livePhotoIsAnimating) {
        return;
    }
    
    // play short "hint" animation
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
}

- (IBAction)playFullAnimation:(id)sender {
    
    // grab a reference to our Photo View
    PHLivePhotoView *photoView = [self.view viewWithTag:87];
    
    // if we're currently animating, ignore this request
    if (self.livePhotoIsAnimating) {
        return;
    }
    
    // play full animation
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

# pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // if we have a live photo view already, remove it
    if ([self.view viewWithTag:87]) {
        UIView *subview = [self.view viewWithTag:87];
        [subview removeFromSuperview];
    }
    
    // check if this is a Live Image, otherwise present a warning
    PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
    if (!photo) {
        [self notLivePhotoWarning];
        return;
    }
    
    // create a Live Photo View
    PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
    photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.tag = 87;
    
    // bring up the Live Photo View
    [self.view addSubview:photoView];
    [self.view sendSubviewToBack:photoView];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notLivePhotoWarning {
    
    // create an alert view
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a Live Photo" message:@"Sadly this is a standard image so we can't show it in our Live Photo VIew. \n\nSorry :-(" preferredStyle:UIAlertControllerStyleAlert];
    
    // add a single action
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    // and display it
    [self presentViewController:alert animated:YES completion:nil];
    
}

# pragma mark - Live Photo View Delegate

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    
    self.livePhotoIsAnimating = YES;
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    
    self.livePhotoIsAnimating = NO;
}

@end
