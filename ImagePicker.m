//
//  ImagePicker.m
//  Mole
//
//  Created by HanWei on 15/8/22.
//  Copyright (c) 2015年 AndLiSoft. All rights reserved.
//

#import "ImagePicker.h"

#define kActionSheetTag  777

static ImagePicker *imagePicker = nil;

@interface ImagePicker () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIViewController    *_viewController;
    UIActionSheet       *_mActionSheet;
}

@end

@implementation ImagePicker


+ (instancetype)shareImagePicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [[self alloc] init];
    });
    return imagePicker;
}

- (void)showActionSheet:(UIViewController *)viewController
{
    if (_mActionSheet==nil) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄" ,@"从相册选择", nil];
        actionSheet.tag = kActionSheetTag;
        _mActionSheet = actionSheet;
    }
    _viewController = viewController;
    [_mActionSheet showInView:viewController.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = _isAllowEditing;
    if (actionSheet.tag == kActionSheetTag && buttonIndex == 1)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_viewController presentViewController:imgPicker animated:YES completion:nil];
        
    }
    else if (actionSheet.tag == kActionSheetTag && buttonIndex == 0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"此设备不支持拍照功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 2001;
            [alertView show];
            return;
        }
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [_viewController presentViewController:imgPicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*
     {
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x796356f0>";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=B6C0A21C-07C3-493D-8B44-3BA4C9981C25&ext=JPG";
     }
     */
    UIImage *image;
    if (_isAllowEditing) {
        image = info[@"UIImagePickerControllerEditedImage"];
    }
    else {
        image = info[@"UIImagePickerControllerOriginalImage"];
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(selectedImageComplete:img:)]) {
        [self.mDelegate selectedImageComplete:self img:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //取消选择相片
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
