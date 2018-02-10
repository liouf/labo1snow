//
//  ViewController.h
//  Labo1Snow
//
//  Created by Turcotte, Michael on 2018-01-31.
//  Copyright © 2018 Turcotte, Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

int timercount;

@interface ViewController : UIViewController {
    IBOutlet UILabel *timerLabel;
    
    NSTimer *timer;
}

-(void)count;
-(IBAction)start:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)restart:(id)sender;

@end

