//
//  ALivcLiveSession.h
//  LiveCapture
//
//  Created by yly on 16/3/2.
//  Copyright © 2016年 Alibaba Video Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlivcLConfiguration.h"

typedef NS_ENUM(NSInteger, ALIVC_LIVE_BITRATE_STATUS) {
    AlivcLiveBitrateRaise = 0,  // 码率上升
    AlivcLiveBitrateDown,   // 码率下降
    AlivcLiveDataDiscard,   // 丢弃缓存
};

@protocol AlivcLiveSessionDelegate;

@interface AlivcLiveSession : NSObject

/*!
 *  是否开启美颜
 */
@property (nonatomic, assign) BOOL enableSkin;

/*!
 *  闪光灯
 */
@property (nonatomic, assign) AVCaptureTorchMode torchMode; 

/*!
 *  摄像头方向
 */
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

/*!
 *  是否静音
 *  默认为NO，不静音
 */
@property (nonatomic, assign) BOOL enableMute;

/*!
 *  AlivcLiveSessionDelegate
 */
@property (nonatomic, weak) id<AlivcLiveSessionDelegate> delegate;

@property (nonatomic, assign) ALIVC_LIVE_BITRATE_STATUS bitrateStatus;


/*!
 *  当前版本号
 *
 *  @return 版本号
 */
+ (NSString *)alivcLiveVideoVersion;

/*!
 *  init
 *
 *  @param configuration 配置
 *
 *  @return AlivcLiveSession
 */
- (instancetype)initWithConfiguration:(AlivcLConfiguration *)configuration;

/*!
 *  预览View
 *
 *  @return 预览View
 */
- (UIView *)previewView;

/*!
 *  开始
 */
- (void)alivcLiveVideoStartPreview;

/*!
 *  停止
 */
- (void)alivcLiveVideoStopPreview;

/*!
 *  转换摄像头
 */
- (void)alivcLiveVideoRotateCamera;

/*!
 *  对焦
 *
 *  @param point     位置
 *  @param autoFocus 是否自动对焦
 */
- (void)alivcLiveVideoFocusAtAdjustedPoint:(CGPoint)point autoFocus:(BOOL)autoFocus;

/*!
 *  缩放
 *
 *  @param zoom 缩放倍数
 */
- (void)alivcLiveVideoZoomCamera:(CGFloat)zoom;

/*!
 *  更新live配置，可以更新码率和帧率，但是只能在connectServer之前调用
 *
 *  @param block 配置
 */
- (void)alivcLiveVideoUpdateConfiguration:(void(^)(AlivcLConfiguration *configuration))block;

/*!
 *  推流连接
 */
- (void)alivcLiveVideoConnectServer;

/*!
 *  推流连接
 *
 *  @param url 推流URL
 */
- (void)alivcLiveVideoConnectServerWithURL:(NSString *)url;

/*!
 *  推流断开连接
 */
- (void)alivcLiveVideoDisconnectServer;

/*!
 *  调试信息
 *
 *  @return 调试信息
 */
- (AlivcLDebugInfo *)dumpDebugInfo;

/*!
 *  当前码率
 *
 *  @return 码率
 */
- (NSInteger)alivcLiveVideoBitRate;


/*!
 *  调整美颜程度
 *
 *  @param value 美颜程度 (0 - 1 初始美颜程度为1)
 */
- (void)alivcLiveVideoChangeSkinValue:(CGFloat)value;


/*!
 *  调整相机曝光度
 *
 *  @param value 曝光度 (-10 - 10 默认0)
 */
- (void)alivcLiveVideoChangeExposureValue:(CGFloat)value;

@end


@protocol AlivcLiveSessionDelegate <NSObject>

@required
/*!
 * 推流错误
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session error:(NSError *)error;

/*!
 * 网络很慢，已经不建议直播
 */
- (void)alivcLiveVideoLiveSessionNetworkSlow:(AlivcLiveSession *)session;


@optional
/*!
 * 推流连接成功
 */
- (void)alivcLiveVideoLiveSessionConnectSuccess:(AlivcLiveSession *)session;

/*!
 * 摄像头获取成功
 */
- (void)alivcLiveVideoOpenVideoSuccess:(AlivcLiveSession *)session;

/*!
 * 麦克风获取成功
 */
- (void)alivcLiveVideoOpenAudioSuccess:(AlivcLiveSession *)session;

/*!
 * 音频设备打开失败
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session openAudioError:(NSError *)error;

/*!
 * 视频设备打开失败
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session openVideoError:(NSError *)error;

/*!
 * 音频编码失败
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session encodeAudioError:(NSError *)error;

/*!
 * 视频编码失败
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session encodeVideoError:(NSError *)error;

/*!
 * 码率变化
 */
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session bitrateStatusChange:(ALIVC_LIVE_BITRATE_STATUS)bitrateStatus;

/*!
 * 重连超时
 */
- (void)alivcLiveVideoReconnectTimeout:(AlivcLiveSession *)session error:(NSError *)error;

@end
