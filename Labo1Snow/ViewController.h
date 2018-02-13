//
//  ViewController.h
//  Labo1Snow
//
//  Created by Turcotte, Michael on 2018-01-31.
//  Copyright © 2018 Turcotte, Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NSMutableToQueue.h"



@interface ViewController : UIViewController {

    IBOutlet UILabel *athlete1;//label next to go
    IBOutlet UILabel *athlete2;//label second to go
    IBOutlet UILabel *athlete3;//label third to go
    
    
    
    NSDictionary *athlete; //key/pair value of an individual athlete
    NSMutableArray *athletes; //list of all athletes to be part of a race
    NSMutableArray *leaderboard;//current leaderboard of the race
    NSMutableArray *raceParticipants;//participants of the race
    int nextParticipantIndex;//keep track of participant
    
    IBOutlet UILabel *timerLabel;//timer label
    int timercount;
    NSTimer *timer;
    
}

-(void)count;
-(IBAction)start:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)restart:(id)sender;
-(IBAction)captueAthlete:(id)sender;
-(IBAction)startNewRace:(id)sender;

@end

