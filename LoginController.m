//
//  AppDelegate.h
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "LoginController.h"
#import "LoginInfo.h"
#import "JSONKit.h"
#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "DemoViewController.h"
#import "AudioView.h"
#import "Memo.h"
#import "MDAudioFile.h"
#import "MDAudioPlayerController.h"

@interface LoginController ()
- (void)onLogin:(QButtonElement *)buttonElement;

@property (nonatomic, retain) NSMutableArray *fileArray;

@end

@implementation LoginController

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    
    //    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.separatorStyle=NO;
    //    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.3542 green:0.3532 blue:0.2548 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;
    
    ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
    
    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]){
        //        cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}


- (void)loginCompleted:(LoginInfo *)info {
    [self loading:NO];
    NSLog(@"%@,%@",info.login,info.password);
    if (([info.login isEqualToString:@""]||info.login==nil)||([info.password isEqualToString:@""]||info.password==nil)) {
        UIAlertView *WarnAlert=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"用户名或密码为空" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
        [WarnAlert show];
        MCRelease(WarnAlert);
    }else if(info.login.length<4||info.login.length>16){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示：" message:@"账户名必须在4～16位之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if(info.password.length<4||info.password.length>16){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示：" message:@"密码必须在4～16位之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        
        dispatch_queue_t myQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        
        //内网测试数据，为了保证程序的通用性，下面用假数据代替
        //        dispatch_async(myQueue, ^{
        //            __block NSURL *pasUrl=nil;
        //            __block ASIHTTPRequest *pasRequest=nil;
        //            dispatch_sync(myQueue, ^{
        //                pasUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.16:8023/MeetingSystemss/LoginMeeting?username=%@&password=%@",info.login,info.password]];
        //                pasRequest = [ASIHTTPRequest requestWithURL:pasUrl];
        //                [pasRequest startSynchronous];
        //            });
        //            dispatch_sync(mainQueue, ^{
        //                NSError *loginError = [pasRequest error];
        //                if(!loginError)
        //                {
        //                    NSData *pasResponse = pasRequest.responseData;
        //                    NSDictionary *pasDic = [NSJSONSerialization JSONObjectWithData:pasResponse options:kNilOptions error:nil];
        //                    NSString *isYes = [pasDic objectForKey:@"flag"];
        //                    if ([isYes isEqualToString:@"YES"])
        //                    {
        //                        NSURL *conferenceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.16:8023/MeetingSystemss/GetMeetingTitle?username=%@",info.login]];
        //                        ASIHTTPRequest *conferenceRequest = [ASIHTTPRequest requestWithURL:conferenceUrl];
        //                        [conferenceRequest startSynchronous];
        //                        NSError *conferenceError = [conferenceRequest error];
        //                        if (!conferenceError)
        //                        {
        //                            NSData *conferenceResponse = conferenceRequest.responseData;
        //                            NSDictionary *conferenceDic = [NSJSONSerialization JSONObjectWithData:conferenceResponse options:kNilOptions error:nil];
        //                            NSArray *startArr = [conferenceDic objectForKey:@"start"];
        //                            NSArray *endArr = [conferenceDic objectForKey:@"end"];
        //                            NSMutableArray *startName = [[NSMutableArray alloc] initWithCapacity:0];
        //                            NSMutableArray *endName = [[NSMutableArray alloc] initWithCapacity:0];
        //                            for (int i = 0; i < startArr.count; i++) {
        //                                [startName addObject:[[startArr objectAtIndex:i] objectForKey:@"Conference_title"]];
        //                            }
        //                            for (int i = 0; i < endArr.count; i++) {
        //                                [endName addObject:[[endArr objectAtIndex:i] objectForKey:@"Conference_title"]];
        //                            }
        //                            ViewController *regist = [[ViewController alloc] init];
        //                            [self.navigationController pushViewController:regist animated:YES];
        //                        }
        //                        else
        //                        {
        //                            NSLog(@"%@",conferenceError);
        //                        }
        //                    }
        //                }
        //            });
        //
        //        });
        
        dispatch_async(myQueue, ^{
            __block  NSString *strPass=nil;
            dispatch_sync(myQueue, ^{
                NSString *yonghuxinxi=@"{\"mahailong\":\"sunao\",\"majian\":\"sunao\",\"zhangjian\":\"sunao\",\"zhangwei\":\"sunao\",\"liuqingxuan\":\"sunao\"}";
                NSData *data=[yonghuxinxi dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic=[data objectFromJSONData];
               strPass=[dic objectForKey:info.login];
            });
            dispatch_sync(mainQueue, ^{
                if (strPass==nil||[strPass isEqualToString:@""]) {
                    UIAlertView *WarnAlertb=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"用户名不存在" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
                    [WarnAlertb show];
                    MCRelease(WarnAlertb);
                }else{
                    if([strPass  isEqualToString:info.password]){
                        
                        //            QRootElement *root=[Login createMainFrom];
                        //            ViewController *view=[[ViewController alloc] initWithRoot:root];
                        
                        NSMutableArray *songs = [[NSMutableArray alloc] init];
                        Memo *mymemo=[[Memo alloc]init];
                        
                        self.fileArray = [[NSMutableArray alloc]initWithArray:[mymemo loadOldFile]];
                        NSLog(@"my file is %@",self.fileArray);
                        
                        [songs removeAllObjects];
                        for (NSString *song in self.fileArray)
                        {
                            NSString *soundFilePath=[mymemo.filePath stringByAppendingPathComponent:song];
                            //初始化音频类 并且添加播放文件,把音频文件转换成url格式
                            MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:soundFilePath]];
                            [songs addObject:audioFile];
                            MCRelease(audioFile);
                        }
                        
                        MDAudioPlayerController *mdaudio=nil;
                        if ([self.fileArray count]==0) {
                             mdaudio=[[MDAudioPlayerController alloc] init];
                        }else{
                             mdaudio= [[MDAudioPlayerController alloc] initWithSoundFiles:songs atPath:mymemo.filePath andSelectedIndex:0];
                        }
                        
                        [self.navigationController pushViewController:mdaudio animated:YES];

                        MCRelease(songs);
                        MCRelease(mymemo);
                        MCRelease(mdaudio);
                    }else {
                        UIAlertView *WarnAlertb=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"密码错误" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
                        [WarnAlertb show];
                        MCRelease(WarnAlertb);
                    }
                }
            });
        });
        


        

    }
}

//-(void)requestFinished:(ASIHTTPRequest*)request
//{
//    NSData *pasResponse = request.responseData;
//
//    NSLog(@"sss is %@",pasResponse);
//    NSDictionary *pasDic =[pasResponse objectFromJSONData];
//    NSLog(@"sss is %@",pasDic);
//
//
//}

- (void)onLogin:(QButtonElement *)buttonElement {
    
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    
    [self.root fetchValueIntoObject:info];
    
    [self performSelector:@selector(loginCompleted:) withObject:info afterDelay:2];
}


- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
//    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
//    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
//    NSLog(@"Must return");
    
}


@end