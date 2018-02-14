//
//  ViewController.m
//  Labo1Snow
//
//  Created by Turcotte, Michael on 2018-01-31.
//  Copyright © 2018 Turcotte, Michael. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableToQueue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    athletes = [[NSMutableArray alloc] init];
    raceParticipants = [[NSMutableArray alloc] init];
    leaderboard = [[NSMutableArray alloc] init];
    currentParticipantIndex = -1;
    
    timercount = 0; // set timer
    timerLabel.text = [NSString stringWithFormat:@"0"];//put starting text
    [self toggleStartButton:stopbtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method here updates the text within the timer
//Needs work
-(void)count {
    timercount = timercount + 1;
    timerLabel.text = [NSString stringWithFormat:@"%i", timercount];
}

//Method starts the timer
-(IBAction)start:(id)sender {
    timercount = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:true];
    [self toggleStartButton:startbtn];
    [self toggleStartButton:stopbtn];
}

//Toggle Start Button on or off
-(void)toggleStartButton:(UIButton*)button {
    if (button.enabled == YES) {
        button.enabled = NO;
    } else {
        button.enabled = YES;
    }
}

//Method stops the timer and adds a descent entry with the current athlete
-(IBAction)stop:(id)sender{
    [timer invalidate];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Judge Athlete"
                                                                              message: @"Add penalties, disqualify and/or confirm time."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"penalties";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Mark DNF" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"You failed! Adding at the bottom of the list in DNF");// mark as DNF
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Submit Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        int athleteTime = 0;
        NSArray * textfields = alertController.textFields;
        UITextField * penalties = textfields[0];
        int penaltiesFixed = [[NSString stringWithFormat:@"%@", penalties.text] integerValue]; // converting the penalties
        if (penaltiesFixed >= 3) {
            NSLog(@"You failed! Adding at the bottom of the list in DNF");// mark as DNF
        } else {
            athleteTime = timercount + (penaltiesFixed * 30);// increase penalty amount
            [self addTimeAndUpdateLeaderboard:athleteTime];
            [self updateStandings];
            timerLabel.text = [NSString stringWithFormat:@"0"];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [self toggleStartButton:startbtn];
    [self toggleStartButton:stopbtn];
}

//Add current athlete to the leaderboard
-(void)addTimeAndUpdateLeaderboard:(int)athleteTime {
    [currentathlete setObject:[NSNumber numberWithInt:athleteTime] forKey:@"time"];
    [leaderboard addObject:[NSMutableDictionary dictionaryWithDictionary:currentathlete]];
}

//Method restarts the timer
-(IBAction)restart:(id)sender{
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"0"];
    [timer invalidate];
}

//Method here captures the athlete information from a popup window.
-(IBAction)captueAthlete:(id)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Enter New Athlete"
                                                                              message: @"First name, Last Name and Country"
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
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"sortingKey";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * firstname = textfields[0];
        UITextField * lastname = textfields[1];
        UITextField * country = textfields[2];
        UITextField * sortingKey = textfields[3];
        
        //Add athlete to participant list
        NSMutableDictionary * athlete = [[NSMutableDictionary alloc] init];
        [athlete setObject:firstname.text forKey:@"firstname"];
        [athlete setObject:lastname.text forKey:@"lastname"];
        [athlete setObject:country.text forKey:@"country"];
        [athlete setObject:[NSNumber numberWithInt:0] forKey:@"time"];
        [athlete setObject:sortingKey.text forKey:@"sortingKey"];
        
        //Assuming unique sortingKeys
        [athletes addObject:athlete];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

//Method here starts a new race with the current particpiants
-(IBAction)startNewRace:(id)sender{
    currentParticipantIndex = -1;
    if ([athletes count] < 4) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You need at least 4 participant!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        //Start new race competition
        //Copy all athletes to list of participants
        for (NSMutableDictionary * obj in athletes) {
            NSMutableDictionary * participant = [NSMutableDictionary dictionaryWithDictionary:obj];
            [raceParticipants addObject:participant];
        }
        
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"sortingKey" ascending:YES];
        [raceParticipants sortUsingDescriptors:@[descriptor]];
        [self updateStandings];
    }
}

//Method will update the view with appropriate information.
-(void)updateStandings {
    
    currentParticipantIndex = currentParticipantIndex + 1;
    int participantSize = [raceParticipants count];
    
    if(participantSize > currentParticipantIndex) {
        currentathlete = [raceParticipants objectAtIndex:currentParticipantIndex];
        currentAthleteNameLabel.text = [NSString stringWithFormat:@"%@", currentathlete[@"firstname"]];
        if(participantSize > currentParticipantIndex+1) {
            NSDictionary * nextAthlete1 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(currentParticipantIndex+1)]];
            athlete1.text = [NSString stringWithFormat:@"%@", nextAthlete1[@"firstname"]];
            if(participantSize > currentParticipantIndex+2) {
                NSDictionary * nextAthlete2 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(currentParticipantIndex+2)]];
                athlete2.text = [NSString stringWithFormat:@"%@", nextAthlete2[@"firstname"]];
                if (participantSize > currentParticipantIndex+3) {
                    NSDictionary * nextAthlete3 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(currentParticipantIndex+3)]];
                    athlete3.text = [NSString stringWithFormat:@"%@", nextAthlete3[@"firstname"]];
                } else {
                    athlete3.text = nil;
                }
            } else {
                athlete2.text = nil;
            }
        } else {
            athlete1.text = nil;
        }
    } else {
        //End Race 1 here, update for race 2?
    }
}

@end
