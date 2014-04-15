//
//  ViewController.m
//  LSHttpGetManagerDemo
//
//  Created by lslin on 14-4-15.
//  Copyright (c) 2014年 lslin. All rights reserved.
//

#import "ViewController.h"
#import "LSHttpGetManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView0;

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

- (IBAction)onGetButton0Pressed:(id)sender;
- (IBAction)onGetButton1Pressed:(id)sender;
- (IBAction)onGetButton2Pressed:(id)sender;
- (IBAction)onGetButton3Pressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGetButton0Pressed:(id)sender
{
    [self getRequestByIndex:0];
}

- (IBAction)onGetButton1Pressed:(id)sender
{
    [self getRequestByIndex:1];
}

- (IBAction)onGetButton2Pressed:(id)sender
{
    [self getRequestByIndex:2];
}

- (IBAction)onGetButton3Pressed:(id)sender
{
    [self getRequestByIndex:3];
}

- (void)getRequestByIndex:(NSUInteger)index
{
    UIImageView *img = nil;
    UITextField *text = nil;
    switch (index) {
        case 0: {
            img = self.imageView0;
            text = self.textField0;
            break;
        }
        case 1: {
            img = self.imageView1;
            text = self.textField1;
            break;
        }
        case 2: {
            img = self.imageView2;
            text = self.textField2;
            break;
        }
        case 3: {
            img = self.imageView3;
            text = self.textField3;
            break;
        }
        default:
            break;
    }
    
    if (img && text && text.text) {
        
        [[LSHttpGetManager sharedObject] sendHttpRequestWithUrl:text.text taskKey:text.text completion:^(BOOL succeed, NSData *recvData, NSError *error) {
            if (succeed) {
                img.image = [UIImage imageWithData:recvData];
            }
        }];
        
    }
}

@end
