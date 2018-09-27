//
//  FileUtils.h
//  Wasee
//
//  Created by 陈忠杰 on 2018/5/31.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FileUtils : NSObject

+ (NSString*)documentFolderPath;
+ (NSString*)getProjDir:(NSString*) projPath;
+ (NSString*)getFileProjPath:(NSString*) projPath fileName:(NSString*)fileName;
+ (NSString*)downloadFile:(NSString*)fileUrl projPath:(NSString*)projPath fileName:(NSString*)fileName;
+ (NSString*)asynDownloadFile:(NSString*)fileUrl
                     projPath:(NSString*)projPath
                     fileName:(NSString*)fileName
                   onProgress:(void(^)(float progress))progressBlock
                     onFinish:(void(^)(NSString* fileName))finishBlock;
+ (BOOL)unzip:(NSString*) zipPath unzipto:(NSString*) unzipto;
+ (void)saveImage:(UIImage*)tempImage projPath:(NSString*) projPath withName:(NSString*)imageName;


+ (BOOL)createDir:(NSString*)fileName;
+ (BOOL)fileExist:(NSString*) projPath fileName:(NSString*)fileName;
+ (BOOL)fileExist:(NSURL*)url;
+ (void)deleteFile:(NSString*) projPath fileName:(NSString*)fileName;

+ (NSURL*)getFileURLProjPath:(NSString*) projPath fileName:(NSString*)fileName;

+ (CGFloat)fileSize:(NSURL *)path;

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error;
@end
