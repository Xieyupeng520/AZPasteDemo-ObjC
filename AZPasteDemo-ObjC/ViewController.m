//
//  ViewController.m
//  AZPasteDemo-ObjC
//
//  Created by cocozzhang on 2019/10/8.
//  Copyright © 2019 cocozzhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    dispatch_source_t _timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initPasteBoard];
//    [self setDataToPasteBoard];
//    [self checkPasteBoard];
//    [self playPasteBoard];
//    [self optionDatePasteBoard];
//    [self optionLocalPasteBoard];
    [self setDataForType];
}

- (void)initPasteBoard {
    NSLog(@"come in");
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"go in");
    UIPasteboard* uPasteBoard = [UIPasteboard pasteboardWithUniqueName];
    NSLog(@"go in 1");
    UIPasteboard* uPasteBoard1 = [UIPasteboard pasteboardWithUniqueName];
    NSLog(@"gPasteBoard=%@, uPasteBoard=%@，uPasteBoard1=%@", gPasteBoard.name, uPasteBoard.name, uPasteBoard1.name);
}

- (void)setDataForType {
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"0) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
    
    NSString* key = @"weizhong";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:@"20200415" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [gPasteBoard setData:data forPasteboardType:key];
    NSLog(@"1) data:%@, items:%@", [gPasteBoard dataForPasteboardType:key], gPasteBoard.items);
    
    //清空剪贴板
    gPasteBoard.string = @"";
    NSLog(@"2) data:%@, items:%@", [gPasteBoard dataForPasteboardType:key].description, gPasteBoard.items);
    
    [gPasteBoard setItems:@[@{key:data}]];
    NSLog(@"2) data:%@, items:%@", [gPasteBoard dataForPasteboardType:key].description, gPasteBoard.items);
}

- (void)optionDatePasteBoard {
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"0) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
    
    NSDate* date = [NSDate date];
    NSLog(@"date:%@", date.description);
    [gPasteBoard setItems:@[@{
                                @"public.utf8-plain-text" : @"Happy",
    }] options:@{
        UIPasteboardOptionExpirationDate:[date dateByAddingTimeInterval:5]
    }];
    
    __block int count = 1;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%d)string:%@, items:%@", count++, gPasteBoard.string, gPasteBoard.items);
    });
    dispatch_resume(_timer);
}

- (void)optionLocalPasteBoard {
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"0) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
    
    [gPasteBoard setItems:@[@{
                                @"public.utf8-plain-text" : @"Beautyyes",
    }] options:@{
        UIPasteboardOptionLocalOnly:@(YES)
    }];
    NSLog(@"1) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
}

- (void)playPasteBoard {
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"0) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
    
    gPasteBoard.string = @"play";
    NSLog(@"1) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
    
    NSDictionary* userInfo = @{
        @"a" : @"aaa",
        @"b" : [NSURL URLWithString:@"bbb"],
        @"c" : UIColor.grayColor
    };
    NSData* userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo requiringSecureCoding:YES error:nil];
    NSString* oString = gPasteBoard.string;
    [gPasteBoard addItems:@[@{
//        @"public.utf8-plain-text" : oString,
        @"myUserInfo" : userInfoData
    }]];
    NSLog(@"2) string:%@, items:%@", gPasteBoard.string, gPasteBoard.items);
}

- (void)checkPasteBoard {
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    [gPasteBoard setItems:@[@{
                                @"public.utf8-plain-text":[NSURL URLWithString:@"www.cc.com"],
                                @"public.url":@"www.cc.com",
    }]];
    NSLog(@"image:%@, string:%@, url:%@, color:%@, types:%@, items:%@ (numberOfItems:%ld)", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items, gPasteBoard.numberOfItems);
    NSLog(@"hasStrings：%d(strings：%@), hasURLs：%d(URLs：%@)",gPasteBoard.hasStrings, gPasteBoard.strings, gPasteBoard.hasURLs, gPasteBoard.URLs);
}

- (void)setDataToPasteBoard {
    UIImage* image = [UIImage imageNamed:@"001"];
    UIPasteboard* gPasteBoard = [UIPasteboard generalPasteboard];
    
    gPasteBoard.image = image;
    NSLog(@"1)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    gPasteBoard.string = @"aaaa";
    NSLog(@"2)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    gPasteBoard.URL = [NSURL URLWithString:@"www.aa.com"];
    NSLog(@"3)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    gPasteBoard.color = UIColor.redColor;
    NSLog(@"4)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    
    //image 没用
    [gPasteBoard setValue:@[image] forPasteboardType:@"com.apple.uikit.image"];
    NSLog(@"5)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    [gPasteBoard setValue:@[image] forPasteboardType:@"public.jpeg"];
    NSLog(@"6)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    [gPasteBoard setValue:@[image] forPasteboardType:@"public.png"];
    NSLog(@"7)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    
    //string 有用
    [gPasteBoard setValue:@"bbb" forPasteboardType:@"public.utf8-plain-text"];
    NSLog(@"8)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    
    //url 有用
    [gPasteBoard setValue:[NSURL URLWithString:@"www.bb.com"] forPasteboardType:@"public.url"];
    NSLog(@"9)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    
    //color 没用
//    [gPasteBoard setValue:@[UIColor.blueColor] forPasteboardType:@"com.apple.uikit.color"];
//    NSLog(@"10)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
    
    if (1-1 == 0) {
        [gPasteBoard setItems:@[@{
                                    @"com.apple.uikit.image":image,
                                    @"public.jpeg":image,
                                    @"public.utf8-plain-text":@"ccc",
                                    @"public.url":[NSURL URLWithString:@"www.cc.com"],
                                    @"com.apple.uikit.color":UIColor.grayColor
        }]];
        NSLog(@"11)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@ (numberOfItems:%ld)", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items, gPasteBoard.numberOfItems);
    } else {
        [gPasteBoard addItems:@[@{
                                        @"com.apple.uikit.image":image,
                                        @"public.jpeg":image,
                                        @"public.utf8-plain-text":@"ccc",
                                        @"public.url":[NSURL URLWithString:@"www.cc.com"],
                                        @"com.apple.uikit.color":UIColor.grayColor
            }]];
        NSLog(@"11)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@ (numberOfItems:%ld)", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items, (long)gPasteBoard.numberOfItems);
    }
    
    [gPasteBoard setValue:@{
                                @"com.apple.uikit.image":image,
                                @"public.jpeg":image,
                                @"public.utf8-plain-text":@"ccc",
                                @"public.url":[NSURL URLWithString:@"www.cc.com"],
                                @"com.apple.uikit.color":UIColor.grayColor
    } forPasteboardType:@"abcd"];
    NSLog(@"12)image:%@, string:%@, url:%@, color:%@, types:%@, items:%@", gPasteBoard.image, gPasteBoard.string, gPasteBoard.URL, gPasteBoard.color, gPasteBoard.pasteboardTypes, gPasteBoard.items);
}

@end
