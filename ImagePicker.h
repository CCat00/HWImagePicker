//
//  ImagePicker.h
//  Mole
//
//  Created by HanWei on 15/8/22.
//  Copyright (c) 2015年 AndLiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImagePicker;
@protocol ImagePickerDelegate <NSObject>

- (void)selectedImageComplete:(ImagePicker *)mImagePicker img:(UIImage *)image;

@end

@interface ImagePicker : NSObject


@property (nonatomic) BOOL isAllowEditing;

@property (nonatomic, weak) id <ImagePickerDelegate> mDelegate;

+ (instancetype)shareImagePicker;

- (void)showActionSheet:(UIViewController *)viewController;

@end
