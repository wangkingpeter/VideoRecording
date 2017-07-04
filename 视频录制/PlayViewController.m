//
//  PlayViewController.m
//  视频录制
//
//  Created by wangyupeng wang on 2017/6/30.
//  Copyright © 2017年 kingpeter. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayViewController (){
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    AVPlayer *player;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    AVURLAsset *_anAsset = [AVURLAsset URLAssetWithURL:_videoURL options:options];
    playerItem = [AVPlayerItem playerItemWithAsset:_anAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(100, 100 , 200, 300);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
