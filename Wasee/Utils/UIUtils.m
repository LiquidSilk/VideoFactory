//
//  UIUtils.m
//  Wasee
//
//  Created by 陈忠杰 on 2017/7/19.
//  Copyright © 2017年 陈忠杰. All rights reserved.
//

#import "UIUitls.h"
#import <AVFoundation/AVFoundation.h>


@implementation UIUtils


+ (UIImageView *)roundFrameImageView:(UIImageView *)imageView
{
    [imageView layoutIfNeeded];
    //  把头像设置成圆形
    imageView.layer.cornerRadius = imageView.frame.size.width/2;//裁成圆角
    imageView.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    //  给头像加一个圆形边框
    imageView.layer.borderWidth = 1.5f;//宽度
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
    return imageView;
}

//创建UIImage
+ (UIImage *) imageWithFrame:(CGRect)frame color:(int)color alpha:(CGFloat)alpha {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColorFromRGBA(color,alpha) CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void) setNavigationTransparent:(UIViewController *)viewController percent:(float)percent
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        //标题栏透明度
        UIView *navigationBar = [[viewController.navigationController.navigationBar subviews] objectAtIndex:0];
        navigationBar.backgroundColor = UIColorFromRGB(BTN_GREEN);
        [navigationBar setAlpha:percent];
        
        //导航栏透明
        UINavigationBar * bar = viewController.navigationController.navigationBar;
        //    UIImage *bgImage = [UIUtils imageWithFrame:CGRectMake(0, 0, kScreenW, XFHeadViewMinH) alpha:percent];
        //    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        
        //标题透明
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:255 alpha:percent]}];
        if (percent == 0)
        {
//            viewController.title = @"";
        }
        else
        {
            viewController.title = NSLocalizedString(@"navigation_title", @"Wasee");
        }
//    });
}

///------------------------------一下测试把图片转换为视频;
+ (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    //CGSize drawSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    //BOOL baseW = drawSize.width < drawSize.height;
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


+ (void)compressImages:(UIImage *)image
             frameRate:(int)frameRate
              duration:(int)duration
             exportUrl:(NSURL*)exportUrl
            completion:(void(^)(NSURL *outurl))block;
{
    if(image!=nil && image.size.width>0 && image.size.height>0)
    {
        CGSize size = image.size;
        __block AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:exportUrl
                                                                       fileType:AVFileTypeMPEG4
                                                                          error:nil];
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
        AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        
        NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        
        if ([videoWriter canAddInput:writerInput])
            NSLog(@"");
        else
            NSLog(@"");
        
        [videoWriter addInput:writerInput];
        
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        //合成多张图片为一个视频文件
        dispatch_queue_t dispatchQueue = dispatch_queue_create("lansongImageConvertVideoQueue", NULL);
        int __block frame = 0;
        [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
            while ([writerInput isReadyForMoreMediaData])
            {
                if(++frame > duration * frameRate)  //结束;
                {
                    [writerInput markAsFinished];
                    //[videoWriter_ finishWriting];
                    if(videoWriter.status == AVAssetWriterStatusWriting){
                        NSCondition *cond = [[NSCondition alloc] init];
                        [cond lock];
                        [videoWriter finishWritingWithCompletionHandler:^{
                            [cond lock];
                            [cond signal];
                            [cond unlock];
                        }]; //
                        [cond wait];
                        [cond unlock];
                        !block?:block(exportUrl);
                    }
                    break;
                }
                CVPixelBufferRef buffer = NULL;
                buffer=(CVPixelBufferRef)[UIUtils pixelBufferFromCGImage:[image CGImage] size:size];
                if (buffer)
                {
                    if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, frameRate)])
                    {
                        NSLog(@"fail");
                    }else
                    {
                        NSLog(@"当前进度:%d",frame / duration * frameRate);
                    }
                    CFRelease(buffer);
                }
            }
        }];
    }else{
        !block?:block(nil);
    }
}


@end
