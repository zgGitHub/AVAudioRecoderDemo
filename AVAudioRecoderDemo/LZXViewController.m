//
//  LZXViewController.m
//  AVAudioRecoderDemo
//
//  Created by LZXuan on 15-1-30.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "LZXViewController.h"
#import <AVFoundation/AVFoundation.h>

//录音机协议
@interface LZXViewController ()<AVAudioRecorderDelegate>
{
    AVAudioRecorder *_recoder;  //录音
    AVAudioPlayer *_player;
}
@end

@implementation LZXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.recordButton.tag = 101;
    self.stopRecord.tag = 102;
    self.pauseRecord.tag = 103;
    
    
    self.playButton.tag = 201;
    self.stopPlay.tag = 202;
    self.pausePlay.tag = 203;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 101://录音
        {
            if (!_recoder) {
                //沙盒路径
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/myTest.caf"];//保存录音文件的路径
                
                //第二个参数：录音相关设置
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                //1.设置录音格式:AVFormatIDKey
                [dict setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
                //2.设置录音采样速率:AVSampleRateKey 8000/44100/96000
                [dict setObject:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
                //3.设置录音质量:AVEncoderAudioQualityKey
                [dict setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
                //4.设置线性采样位数:AVLinearPCMBitDepthKey 8/16/24
                [dict setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
                //5.录音通道:AVNumberOfChannelsKey 1/2
                [dict setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
                
                //音频会话
                //
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryRecord error:nil];
                [session setActive:YES error:nil];
                //录音对象
                _recoder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:dict error:nil];
                //设置代理
                _recoder.delegate = self;
            }
            [_recoder prepareToRecord];
            [_recoder record];
        }
            break;
        case 102://停止
        {
            [_recoder stop];
        }
            break;
        case 103://暂停
        {
            [_recoder pause];
        }
            break;
            
        default:
            break;
    }

    
}
#pragma mark - AVAudioRecorderDelegate相关
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音完毕");
    
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"出错");
    NSLog(@"error:%@",error);
}
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"中断开始");
}
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"中断结束");
    //中断结束后，
    //判断是否要恢复录音/播放
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [_recoder record];
    }
}



- (IBAction)playClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 201://播放
        {
            
            if (!_player) {
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/myTest.caf"];
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
            }
            [_player play];
        }
            break;
        case 202://停止
        {
            [_player stop];
        }
            break;
        case 203://暂停
        {
            [_player pause];
        }
            break;
            
        default:
            break;
    }
}
/*
 
 
 AVAudioSession类由AVFoundation框架引入。每个IOS应用都有一个音频会话。这个会话可以被AVAudioSession类的sharedInstance类方法访问，如下：
 
 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 
 复制代码
 
 在获得一个AVAudioSession类的实例后，你就能通过调用音频会话对象的setCategory:error:实例方法，来从IOS应用可用的不同类别中作出选择。下面列出了可供使用的音频会话类别：
 AVAudioSessionCategorySoloAmbient
 
 
 这个类别非常像AVAudioSessionCategoryAmbient类别，除了会停止其他程序的音频回放，比如iPod程序。当设备被设置为静音模式，你的音频回放将会停止。
 
 
 AVAudioSessionCategoryRecord
 这会停止其他应用的声音（比如iPod）并让你的应用也不能初始化音频回放（比如AVAudioPlayer）。在这种模式下，你只能进行录音。使用这个类别，调用AVAudioPlayer的prepareToPlay会返回YES，但是调用play方法将返回NO。主UI界面会照常工作。这时，即使你的设备屏幕被用户锁定了，应用的录音仍会继续。
 
 
 AVAudioSessionCategoryPlayback
 这个类别会静止其他应用的音频回放（比如iPod应用的音频回放）。你可以使用AVAudioPlayer的prepareToPlay和play方法，在你的应用中播放声音。主UI界面会照常工作。这时，即使屏幕被锁定或者设备为静音模式，音频回放都会继续。
 
 
 AVAudioSessionCategoryPlayAndRecord
 这个类别允许你的应用中同时进行声音的播放和录制。当你的声音录制或播放开始后，其他应用的声音播放将会停止。主UI界面会照常工作。这时，即使屏幕被锁定或者设备为静音模式，音频回放和录制都会继续。
 
 
 AVAudioSessionCategoryAudioProcessing
 这个类别用于应用中进行音频处理的情形，而不是音频回放或录制。设置了这种模式，你在应用中就不能播放和录制任何声音。调用AVAPlayer的prepareToPlay和play方法都将返回NO。其他应用的音频回放，比如iPod，也会在此模式下停止。
 
 
 AVAudioSessionCategoryAmbient
 这个类别不会停止其他应用的声音，相反，它允许你的音频播放于其他应用的声音之上，比如iPod。你的应用的主UI县城会工作正常。调用AVAPlayer的prepareToPlay和play方法都将返回YES。当用户锁屏时，你的应用将停止所有正在回放的音频。仅当你的应用是唯一播放该音频文件的应用时，静音模式将停止你程序的音频回放。如果正当iPod播放一手歌时，你开始播放音频，将设备设为静音模式并不能停止你的音频回放。

 */


@end
