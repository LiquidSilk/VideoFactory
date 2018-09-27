#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AVAsset+CTVideoView.h"
#import "CTVideoView+Download.h"
#import "CTVideoView+FullScreen.h"
#import "CTVideoView+OperationButtons.h"
#import "CTVideoView+PlayControlPrivate.h"
#import "CTVideoView+PlayControl.h"
#import "CTVideoView+Time.h"
#import "CTVideoView+VideoCoverView.h"
#import "UIPanGestureRecognizer+ExtraMethods.h"
#import "CTVideoView.h"
#import "CTVideoDataCenter.h"
#import "CTVideoRecord.h"
#import "CTVideoTable.h"
#import "CTVideoDownloadManager.h"
#import "CTVideoViewCommonHeader.h"
#import "CTVideoViewDefinitions.h"

FOUNDATION_EXPORT double CTVideoPlayerViewVersionNumber;
FOUNDATION_EXPORT const unsigned char CTVideoPlayerViewVersionString[];

