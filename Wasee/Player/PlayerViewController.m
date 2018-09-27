//
//  PlayerViewController.m
//  Wasee
//
//  Created by 陈忠杰 on 2018/4/18.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerView.h"
#import "UIUitls.h"

static NSString * const PBJViewControllerVideoPath = @"https://resource.v123.cn/v/Data/upload/cloud/201611/937770344/video/201803/5aaa2e2ed9a7b.mp4";

@interface PlayerViewController () <
    GVRRendererViewControllerDelegate,
    WaseeSceneRendererDelegate,
    PlayerViewDelegate>
{
    BOOL isVRMode;
}


@property(nonatomic) AVPlayer *player;
@property(nonatomic) WaseeSceneRenderer *sceneRenderer;
@property(nonatomic) GVRRendererView *renderView;
@property(nonatomic, strong)PlayerView* playerView;
@property(nonatomic, strong)PlayerView* playerView1;
//@property(nonatomic) UIButton *textPlayButton;
//@property(nonatomic) UIButton *cardButton;
//@property(nonatomic) UIToolbar *toolbar;
//@property(nonatomic) UIBarButtonItem *playButton;
//@property(nonatomic) UIBarButtonItem *pauseButton;
//@property(nonatomic) UIBarButtonItem *progressBar;
@property(nonatomic, assign) BOOL isLookAt;

@property(nonatomic, weak)NSTimer *timer;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    
    _playerView = [[PlayerView alloc] init];
    _playerView.backgroundColor = [UIColor blueColor];
    _playerView.delegate = self;
    [self.view addSubview:_playerView];
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(60);
    }];
    
    
    _playerView1 = [[PlayerView alloc] init];
    _playerView1.backgroundColor = [UIColor blueColor];
    _playerView1.delegate = self;
    [self.view addSubview:_playerView1];
    _playerView1.hidden = YES;
    [_playerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(60);
    }];
    
    
    //    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"congo" ofType:@"mp4"];
    //    NSURL *videoURL = [[NSURL alloc] initFileURLWithPath:videoPath];
    NSURL *mediaURL = [NSURL URLWithString:PBJViewControllerVideoPath];
    _player = [AVPlayer playerWithPlayerItem:[[AVPlayerItem alloc] initWithURL:mediaURL]];
    
    //    _player = [AVPlayer playerWithURL:videoURL];
    
    GVRRendererViewController* gvrViewController = [[GVRRendererViewController alloc] init];
    gvrViewController.delegate = self;
    _renderView = gvrViewController.rendererView;

    [self.view addSubview:_renderView];
    [self addChildViewController:gvrViewController];
    //    _panoView.overlayView.hidesBackButton = YES;
    //    _panoView.overlayView.hidesCardboardButton = YES;
    
    
    _sceneRenderer = (WaseeSceneRenderer *)gvrViewController.rendererView.renderer;
    GVRVideoRenderer *videoRenderer = [_sceneRenderer.renderList objectAtIndex:0];
    videoRenderer.player = _player;
    
    _sceneRenderer.VRModeEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    if(isVRMode)
    {
    }
    else
    {
        [_renderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-200);
        }];
        //        _panoView.VRModeEnabled = NO;
        _sceneRenderer.VRModeEnabled = NO;
    }
    
}


#pragma mark - PlayerViewDelegate
//播放按钮
-(void)playerViewOnPlaySelect
{
    [self updateVideoPlayback];
}

#pragma mark - GVRRendererViewControllerDelegate

- (void)didTapTriggerButton {
    [self updateVideoPlayback];
}

- (GVRRenderer *)rendererForDisplayMode:(GVRDisplayMode)displayMode {
    GVRVideoRenderer *videoRenderer = [[GVRVideoRenderer alloc] init];
    videoRenderer.player = _player;
    [videoRenderer setSphericalMeshOfRadius:50
                                  latitudes:12
                                 longitudes:24
                                verticalFov:180
                              horizontalFov:360
                                   meshType:kGVRMeshTypeMonoscopic];
    
    WaseeSceneRenderer *sceneRenderer = [[WaseeSceneRenderer alloc] init];
    [sceneRenderer.renderList addRenderObject:videoRenderer];

    
    // Hide reticle in embedded display mode.
    if (displayMode == kGVRDisplayModeEmbedded)
    {
        sceneRenderer.hidesReticle = YES;
        _playerView1.hidden = YES;
    }
    else {
        // In fullscreen mode, add the toolbar to the GL scene.
//        [_playerView1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(20);
//        }];
        _playerView1.hidden = NO;
        GVRUIViewRenderer *viewRenderer = [[GVRUIViewRenderer alloc] initWithView:_playerView1];
        
        // Position the playback controls half a meter in front (z = -0.5).
        GLKMatrix4 position = GLKMatrix4MakeTranslation(-0.0, 0, -0.5);
        // Rotate along x axis so that it looks oriented towards us.
        position = GLKMatrix4RotateX(position, GLKMathDegreesToRadians(-0));
        viewRenderer.position = position;
        
        [sceneRenderer.renderList addRenderObject:viewRenderer];
    }
    
    sceneRenderer.delegate = self;
    return sceneRenderer;
}

-(BOOL)shouldHideTransitionView
{
    return YES;
}

#pragma mark - Private

- (void)updateVideoPlayback {
    if (_player.rate == 1.0) {
        [_player pause];
//        _toolbar.items = @[ _playButton, _pauseButton, _progressBar ];
        //        _panoView.overlayView.hidesBackButton = NO;
        //        _panoView.overlayView.hidesCardboardButton = NO;
    } else {
        
        [_player play];
//        _toolbar.items = @[ _playButton, _pauseButton, _progressBar ];
        
        //        _panoView.overlayView.hidesBackButton = YES;
        //        _panoView.overlayView.hidesCardboardButton = YES;
        
        
    }
}

#pragma mark - WaseeSceneRendererDelegate
- (void)WaseeSceneRendererOnGaze:(bool)isLookAt
{
    if (isLookAt && !_isLookAt)
    {
        [_player play];
    }
    else
    {
        _isLookAt = NO;
        [_timer invalidate];
    }
}

- (void)WaseeSceneRendererOnLookAt:(bool)isLookAt
{
    if (isLookAt)
    {
        NSLog(@"isLookAt");
    }
    else
    {
        NSLog(@"not isLookAt");
    }
}


- (BOOL)shouldAutorotate{

    return YES;

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;  //支持横向
}

@end
