//
//  FileUtils.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/5/31.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "FileUtils.h"
#import "ZipArchive.h"

@implementation FileUtils


+ (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)getProjDir:(NSString*) projPath
{
    NSString* path = [[FileUtils documentFolderPath] stringByAppendingPathComponent:projPath];
    return path;
}

+ (NSString *)getFileProjPath:(NSString*) projPath fileName:(NSString *)fileName
{
    NSString* path = [FileUtils getProjDir:projPath];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString*)downloadFile:(NSString*)fileUrl
                 projPath:(NSString*)projPath
                 fileName:(NSString*)fileName
{
    NSString *documentPath = [self documentFolderPath];
    NSString *_projPath = [documentPath stringByAppendingPathComponent:projPath];
    NSString *_fileName = [_projPath stringByAppendingPathComponent:fileName];//fileName就是保存文件的文件名
    // Copy the database sql file from the resourcepath to the documentpath
    [self createDir:projPath];
    
    NSURL *url = [NSURL URLWithString:fileUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [data writeToFile:_fileName atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    return fileName;
}

//+ (NSString*)asynDownloadFile:(NSString*)fileUrl
//                     projPath:(NSString*)projPath
//                     fileName:(NSString*)fileName
//                   onProgress:(void(^)(float progress))progressBlock
//                     onFinish:(void(^)(NSString *))finishBlock
//{
//    NSString *documentPath = [self documentFolderPath];
//    NSString *_projPath = [documentPath stringByAppendingPathComponent:projPath];
//    NSString *_fileName = [_projPath stringByAppendingPathComponent:fileName];//fileName就是保存文件的文件名
//    // Copy the database sql file from the resourcepath to the documentpath
//    [self createDir:projPath];
//    
//    NSURL* localFile = [self getFileURLProjPath:projPath fileName:fileName];
//    [LSNetworking download:fileUrl localFile:localFile onProgress:progressBlock onFinish:finishBlock];
//    
//    return fileName;
//}

+ (BOOL)unzip:(NSString*) zipPath unzipto:(NSString*) unzipto
{
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipto];
    return isSuccess;
}


//保存文件到 ~/Documents/projxxx/images/
+ (void)saveImage:(UIImage *)tempImage projPath:(NSString*) projPath withName:(NSString *)imageName
{
    [FileUtils saveImage:tempImage projPath:projPath type:@"images" withName:imageName];
}

//保存文件到 ~/Documents/projxxx/xxxx/
+ (void)saveImage:(UIImage *)tempImage
         projPath:(NSString*) projPath
             type:(NSString*) type
         withName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* imagePath = [[documentsDirectory stringByAppendingPathComponent:projPath] stringByAppendingPathComponent:type];
    NSString* fullPathToFile = [imagePath stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/*
 * 创建文件夹
 */
+ (BOOL)createDir:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir])
    {
        //先判断目录是否存在，不存在才创建
        BOOL res = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    }
    else
        return NO;
}

+ (BOOL)fileExist:(NSString*) projPath fileName:(NSString *)fileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, projPath, fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


+ (BOOL)fileExist:(NSURL *)url
{
    NSError *err;
    if ([url checkResourceIsReachableAndReturnError:&err] == NO)
        return NO;
    return YES;
}

+ (void)deleteFile:(NSString*) projPath fileName:(NSString *)fileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, projPath, fileName];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave)
    {
        NSLog(@"no  have");
        return ;
    }
    else
    {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele)
        {
            NSLog(@"dele success");
        }
        else
        {
            NSLog(@"dele fail");
        }
        
    }
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path])
    {
//        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    
    //获得目标文件的上级目录
//    NSString *toDirPath = [self directoryAtPath:toPath];

    
    if (![self isExistsAtPath:toPath])
    {
        // 创建复制路径
        if (![self createDir:toPath])
        {
            return NO;
        }
        // 复制文件，如果不覆盖且文件已存在则会复制失败
        BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
        return isSuccess;
    }
    
    return NO;
}

+ (BOOL)isExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)directoryAtPath:(NSString *)path
{
    return [path stringByDeletingLastPathComponent];
}


+ (NSURL*)getFileURLProjPath:(NSString*) projPath fileName:(NSString *)fileName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *path = [url URLByAppendingPathComponent:projPath];
    NSURL *videoUrl = [path URLByAppendingPathComponent:fileName];
    return videoUrl;
}

+ (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

@end
