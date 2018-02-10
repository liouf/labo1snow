//
//  ViewController.m
//  Labo1Snow
//
//  Created by Turcotte, Michael on 2018-01-31.
//  Copyright © 2018 Turcotte, Michael. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"0"];
    // Do any additional setup after loading the view, typically from a nib.
    // Here is an added comment for commit test.
    
    double UserInfoArray[10];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)count {
    timercount = timercount + 1;
    timerLabel.text = [NSString stringWithFormat:@"%i", timercount];
}
-(IBAction)start:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:true];
}
-(IBAction)stop:(id)sender{
    [timer invalidate];
}
-(IBAction)restart:(id)sender{
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"0"];
    [timer invalidate];
}
@end
