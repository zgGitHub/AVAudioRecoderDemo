//
//  LZXViewController.h
//  AVAudioRecoderDemo
//
//  Created by LZXuan on 15-1-30.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZXViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopRecord;
@property (weak, nonatomic) IBOutlet UIButton *pauseRecord;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlay;
@property (weak, nonatomic) IBOutlet UIButton *pausePlay;

- (IBAction)recordClick:(id)sender;

- (IBAction)playClick:(id)sender;

@end
