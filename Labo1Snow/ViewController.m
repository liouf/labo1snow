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
    nextParticipantIndex = 0; 
    
    timercount = 0; // set timer
    timerLabel.text = [NSString stringWithFormat:@"0"];//put starting text
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
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:true];
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
        int penaltiesFixed = [textfields[0] integerValue]; // converting the penalties
        if (penaltiesFixed >= 3) {
            NSLog(@"You failed! Adding at the bottom of the list in DNF");// mark as DNF
        } else {
            athleteTime = timercount + (penaltiesFixed * 30);// increase penalty amount
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
        NSDictionary * athlete = @{@"firstname": firstname.text, @"lastname" : lastname.text, @"country" : country.text, @"sortingKey" : sortingKey.text};//Assuming unique sortingKeys
        [athletes addObject:athlete];
        
        //Log all athletes
        for (id obj in athletes)
            NSLog(@"obj: %@", obj);
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

//Method here starts a new race with the current particpiants
-(IBAction)startNewRace:(id)sender{
    if ([athletes count] < 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You need at least 3 participant!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //Start new race competition

        //Copy all athletes to list of participants
        for (NSDictionary * obj in athletes) {
            NSDictionary * participant = [NSDictionary dictionaryWithDictionary:obj];
            [raceParticipants addObject:participant];
        }

        //Set Labels
        NSDictionary *nextAthlete1 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(nextParticipantIndex)]];
        NSDictionary *nextAthlete2 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(nextParticipantIndex+1)]];
        NSDictionary *nextAthlete3 = [NSDictionary dictionaryWithDictionary:[raceParticipants objectAtIndex:(nextParticipantIndex+2)]];
        
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        mutableString = nextAthlete1[@"firstname"];
        athlete1.text = mutableString;
        mutableString = nextAthlete2[@"firstname"];
        athlete2.text = mutableString;
        mutableString = nextAthlete3[@"firstname"];
        athlete3.text = mutableString;
    }
}

@end
