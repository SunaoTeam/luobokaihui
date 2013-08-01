//
//  AppDelegate.m
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "RootViewController.h"
#import "DemoViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "AViewController.h"
#import "AudioView.h"
#import "DownloadViewController.h"
#import "BaiduMusicViewController.h"
#import "MDAudioPlayerController.h"
#import "MDAudioFile.h"
#import "Memo.h"
#import "ScrollViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController
@synthesize fileArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    NSMutableArray *songs = [[NSMutableArray alloc] init];
    Memo *mymemo=[[Memo alloc]init];
    self.fileArray = [[NSMutableArray alloc]initWithArray:[mymemo loadOldFile]];
    [self.fileArray removeObject:@"Temp,"];
    NSLog(@"%@",self.fileArray);
    
    [songs removeAllObjects];
    for (NSString *song in self.fileArray)
    {
        NSString *soundFilePath=[mymemo.filePath stringByAppendingPathComponent:song];
        //初始化音频类 并且添加播放文件,把音频文件转换成url格式
        MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:soundFilePath]];
        
        [songs addObject:audioFile];
    }
    
    if (!_sideMenu) {
        
        
        RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"音乐播放器" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MDAudioPlayerController *viewController = [[MDAudioPlayerController alloc] init];
            viewController = [[MDAudioPlayerController alloc] initWithSoundFiles:songs atPath:mymemo.filePath andSelectedIndex:0];
            viewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            
            [menu setRootViewController:navigationController];
            
        }];
        
        RESideMenuItem *exploreItem=[[RESideMenuItem alloc] initWithTitle:@"音乐下载" action:^(RESideMenu *menu, RESideMenuItem *item) {
            BaiduMusicViewController *secondViewController = [[BaiduMusicViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *exploreItemb=[[RESideMenuItem alloc] initWithTitle:@"正在下载的音乐" action:^(RESideMenu *menu, RESideMenuItem *item) {
            DownloadViewController *secondViewController = [[DownloadViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            
            [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *activityItem=[[RESideMenuItem alloc] initWithTitle:@"录音" action:^(RESideMenu *menu, RESideMenuItem *item) {
            AViewController *secondViewController = [[AViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            
            [menu setRootViewController:navigationController];
        }];
        
        
        RESideMenuItem *profileItem=[[RESideMenuItem alloc] initWithTitle:@"关于我们" action:^(RESideMenu *menu, RESideMenuItem *item) {
            ScrollViewController *secondViewController = [[ScrollViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            
            [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            
            [menu setRootViewController:navigationController];
        }];
        
        
        RESideMenuItem *logOutItem=[[RESideMenuItem alloc] initWithTitle:@"注销" action:^(RESideMenu *menu, RESideMenuItem *item) {
            UIActionSheet *alertView = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView showInView:self.view];
        }];
        
        
        NSArray *myArray=[[NSArray alloc] initWithObjects:homeItem,exploreItem,exploreItemb,activityItem,profileItem,logOutItem, nil];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:myArray];
        //        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        //        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    [_sideMenu show];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        QRootElement *root=[[QRootElement alloc] initWithJSONFile:@"loginJson"];
        UINavigationController *nav=[QuickDialogController controllerWithNavigationForRoot:root];
        [nav.navigationBar setBarStyle:UIBarStyleBlack];
        [self.sideMenu setRootViewController:nav];
    }
    
    
}

@end
