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
    raceNumber = 1;// indicates which race to perform
    timerLabel.text = [NSString stringWithFormat:@"0"];// put starting text
    
    [self toggleButton:stopbtn];
    [self toggleButton:startbtn];
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
    [self toggleButton:startbtn];
    [self toggleButton:stopbtn];
}

//Toggle Start Button on or off
-(void)toggleButton:(UIButton*)button {
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
        [self addTimeAndUpdateLeaderboard:999];
        [self updateStandings];
        timerLabel.text = [NSString stringWithFormat:@"0"];
        NSLog(@"You failed! Adding at the bottom of the list in DNF");// mark as DNF
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Submit Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        int athleteTime = 0;
        NSArray * textfields = alertController.textFields;
        UITextField * penalties = textfields[0];
        int penaltiesFixed = [[NSString stringWithFormat:@"%@", penalties.text] integerValue]; // converting the penalties
        if (penaltiesFixed >= 3) {
            [self addTimeAndUpdateLeaderboard:999];
            [self updateStandings];
            timerLabel.text = [NSString stringWithFormat:@"0"];
            NSLog(@"You failed! Adding at the bottom of the list in DNF");// mark as DNF
        } else {
            athleteTime = timercount + (penaltiesFixed * 30);// increase penalty amount
            [self addTimeAndUpdateLeaderboard:athleteTime];
            [self updateStandings];
            timerLabel.text = [NSString stringWithFormat:@"0"];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [self toggleButton:startbtn];
    [self toggleButton:stopbtn];
}

//Add current athlete to the leaderboard
-(void)addTimeAndUpdateLeaderboard:(int)athleteTime {
    [currentathlete setObject:[NSNumber numberWithInt:athleteTime] forKey:@"time"];
    
    int foundIndex = -1;
    
    for (NSMutableDictionary * obj in leaderboard) {
        if ([obj[@"sortingKey"] isEqualToString:currentathlete[@"sortingKey"]]) {
            foundIndex = [leaderboard indexOfObject:obj];
        }
    }
    
    if (foundIndex != -1) {
        int leaderboardTime = [[[leaderboard objectAtIndex:foundIndex] valueForKey:@"time"] intValue];
        if (athleteTime < leaderboardTime) {
             [[leaderboard objectAtIndex:foundIndex] setValue:[NSNumber numberWithInt:athleteTime] forKey:@"time"];
        }
    } else {
        [leaderboard addObject:[NSMutableDictionary dictionaryWithDictionary:currentathlete]];
    }
    
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    [leaderboard sortUsingDescriptors:@[descriptor]];
    NSMutableString * leaderboardString = [[NSMutableString alloc] init];
    
    for (NSMutableDictionary * obj in leaderboard) {
        if ([obj[@"time"] intValue] == 999) {
            [leaderboardString appendFormat:@"Name: %@, %@: %@\n_____________\n", obj[@"lastname"], obj[@"firstname"], @"DNF"];
             } else {
                  [leaderboardString appendFormat:@"Name: %@, %@: %@ secs\n_____________\n", obj[@"lastname"], obj[@"firstname"], obj[@"time"]];
             }
    }
    leaderboardLabel.text = leaderboardString;
    [leaderboardLabel sizeToFit];
}

//Method restarts the timer
-(IBAction)restart:(id)sender{
    timercount = 0;
    timerLabel.text = [NSString stringWithFormat:@"0"];
    [timer invalidate];
}

//Method here captures the athlete information from a popup window.
-(IBAction)captureAthlete:(id)sender{
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
        NSMutableString * athletesString = [[NSMutableString alloc] init];
        
        for (NSMutableDictionary * obj in athletes) {
            [athletesString appendFormat:@"Name: %@, %@: %@\nFrom: %@\n_____________\n", obj[@"lastname"], obj[@"firstname"], obj[@"sortingKey"], obj[@"country"]];
        }
        
        athletesLabel.text = athletesString;
        [athletesLabel sizeToFit];
        
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

//Method here starts a new race with the current particpiants
-(IBAction)startNewRace:(id)sender{
    currentParticipantIndex = -1;
    raceStatus.text = [NSString stringWithFormat:@"1/2"];
    raceNumber = 1;
    
    if ([athletes count] < 1) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You need at least 1 participant!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        startbtn.enabled = YES;
        enterAthlete.enabled = NO;//disallow athletes to enter
        //Start new race competition
        [raceParticipants removeAllObjects];
        [leaderboard removeAllObjects];
        leaderboardLabel.text = nil;
        
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
        currentAthleteNameLabel.text = [NSString stringWithFormat:@"%@, %@", currentathlete[@"lastname"], currentathlete[@"firstname"]];
        currentAthleteCountryLabel.text = [NSString stringWithFormat:@"%@", currentathlete[@"country"]];
        
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
                athlete3.text = nil;
            }
        } else {
            athlete1.text = nil;
            athlete2.text = nil;
            athlete3.text = nil;
        }
    } else if (raceNumber == 1) {
        raceNumber = 2;
        [raceParticipants removeAllObjects];
        
        //Add the people again
        for (NSMutableDictionary * obj in athletes) {
            NSMutableDictionary * participant = [NSMutableDictionary dictionaryWithDictionary:obj];
            [raceParticipants addObject:participant];
        }
        
        raceStatus.text = [NSString stringWithFormat:@"2/2"];
        currentParticipantIndex = -1;
        
        [self updateStandings];
    } else if (raceNumber == 2) {
        //Show the winners and reset?
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Race Completed!"
                                                                                  message: @"Please see the leaderboard for final standings."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
 
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
        }]];
        athlete1.text = nil;
        athlete2.text = nil;
        athlete3.text = nil;
        currentAthleteCountryLabel.text = nil;
        currentAthleteNameLabel.text = nil;
        [self toggleButton:enterAthlete];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

@end
