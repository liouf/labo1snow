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
    // Do any additional setup after loading the view, typically from a nib.
    
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"00:00.000"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method here updates the text within the timer
-(void)count {
    timercount = timercount + 1;
    timerLabel.text = [NSString stringWithFormat:@"%i", timercount];
}

//Method starts the timer
-(IBAction)start:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:true];
}

//Method Stops the timer
-(IBAction)stop:(id)sender{
    [timer invalidate];
}

//Method restarts the timer
-(IBAction)restart:(id)sender{
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"00:00.000"];
    [timer invalidate];
}

//Method here captures the athlete information from a popup window.
-(IBAction)captueAthlete:(id)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Enter Athlete"
                                                                              message: @"First name, Last Name and Country Name"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"firstname";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"lastname";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"country";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * firstname = textfields[0];
        UITextField * lastname = textfields[1];
        UITextField * country = textfields[2];
        NSLog(@"%@:%@:%@",firstname.text,lastname.text,country.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
