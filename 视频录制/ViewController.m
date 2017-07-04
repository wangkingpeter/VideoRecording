//
//  ViewController.m
//  视频录制
//
//  Created by wangyupeng wang on 2017/6/30.
//  Copyright © 2017年 kingpeter. All rights reserved.
//
#import "ViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PlayViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSURL *videoUrl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(100,100,100,50);
    [button setTitle:@"开始录制"forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    button.backgroundColor=[UIColor grayColor];
    button.showsTouchWhenHighlighted=YES;
    [button addTarget:self action:@selector(start:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    UIButton*playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame=CGRectMake(100,200,100,50);
    [playBtn setTitle:@"播放视频"forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    playBtn.backgroundColor=[UIColor grayColor];
    playBtn.showsTouchWhenHighlighted=YES;
    [playBtn addTarget:self action:@selector(plsyBtn:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}


#pragma mark -开始录制
-(void)start:(UIButton*)sender{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
       //判断是否可以拍摄
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断是否拥有拍摄权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            return;
        }
        
        //拍摄
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //录制的类型 下面为视频
        
        imagePicker.mediaTypes=@[(NSString*)kUTTypeMovie];
        
        //录制的时长
        imagePicker.videoMaximumDuration=10.0;
        
        //模态视图的弹出效果
        imagePicker.modalPresentationStyle=UIModalPresentationOverFullScreen;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}



#pragma mark -录制完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    //返回的媒体类型是照片或者视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //照片的处理
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }];
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        //视频的处理
        [picker dismissViewControllerAnimated:YES completion:^() {
            
            //文件管理器
            NSFileManager* fm = [NSFileManager defaultManager];
            
            //创建视频的存放路径
            NSString * path = [NSString stringWithFormat:@"%@/tmp/video%.0f.merge.mp4", NSHomeDirectory(), [NSDate timeIntervalSinceReferenceDate] * 1000];
            NSURL *mergeFileURL = [NSURL fileURLWithPath:path];
            videoUrl = mergeFileURL;
            
            //通过文件管理器将视频存放的创建的路径中
            [fm copyItemAtURL:[info objectForKey:UIImagePickerControllerMediaURL] toURL:mergeFileURL error:nil];
            AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
            
            //根据AVURLAsset得出视频的时长
            CMTime   time = [asset duration];
            int seconds = ceil(time.value/time.timescale);
            NSString *videoTime = [NSString stringWithFormat:@"%d",seconds];
  
            //可以根据需求判断是否需要将录制的视频保存到系统相册中
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
//            
//            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
//                [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
//                                            completionBlock:^(NSURL *assetURL, NSError *error){
//                                                
//                                            }];
//            }
            
            }];
    }
}



#pragma mark - 播放视频
- (void)plsyBtn:(UIButton*)sender{
    PlayViewController*playVC = [[PlayViewController alloc]init];
    playVC.videoURL = videoUrl;
    [self presentViewController:playVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
