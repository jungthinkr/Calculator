//
//  ViewController.m
//  Calculator
//
//  Created by Aaron Liu on 1/26/16.
//  Copyright © 2016 Aaron Liu. All rights reserved.
//
//
#import "ViewController.h"
#import "pop/POP.h"
#include <math.h>

@interface ViewController ()
{
    UIView* gradientView;
    __weak IBOutlet UITextField *numberTextField;
    __weak IBOutlet UIButton *decimal;
    __weak IBOutlet UIButton *zero;
    __weak IBOutlet UIButton *one;
    __weak IBOutlet UIButton *two;
    __weak IBOutlet UIButton *three;
    __weak IBOutlet UIButton *four;
    __weak IBOutlet UIButton *five;
    __weak IBOutlet UIButton *six;
    __weak IBOutlet UIButton *seven;
    __weak IBOutlet UIButton *eight;
    __weak IBOutlet UIButton *nine;
    __weak IBOutlet UIButton *clear;
    __weak IBOutlet UIButton *parenth;
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *divide;
    __weak IBOutlet UIButton *multiply;
    __weak IBOutlet UIButton *subtract;
    __weak IBOutlet UIButton *add;
    __weak IBOutlet UIButton *equal;
    __weak IBOutlet UIButton *negative;
    __weak IBOutlet UITableView *History;
    __weak IBOutlet UIButton *showHistory;
    __weak IBOutlet UIButton *clearHistory;
    __weak IBOutlet UIButton *power;
    __weak IBOutlet UISegmentedControl *powButtons;
    BOOL parenthLogic;
    BOOL parenthFinish;
    BOOL error;
    BOOL decimalCheck;
    NSInteger parenthCount;
    IBOutlet UITapGestureRecognizer *tapGesture;
    UIAlertController *alert;
    NSMutableArray* expressionHist;
    NSMutableArray* resultHist;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize tapGesture
    //tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    tapGesture.delegate = self;
    numberTextField.delegate = self;
    // Table stuff
    History.delegate = self;
    History.dataSource = self;
    History.hidden = YES;
    clearHistory.hidden = YES;
    resultHist = [[NSMutableArray alloc]init];
    expressionHist = [[NSMutableArray alloc]init];
    ///////////
    [numberTextField becomeFirstResponder];
    // Initialize Gradient View
    gradientView = [[UIView alloc] initWithFrame:self.view.frame];
    gradientView.alpha = .7;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    //add border color to buttons (borderWidth is in runtime attributes)
    decimal.layer.borderColor = [UIColor whiteColor].CGColor;
    zero.layer.borderColor = [UIColor whiteColor].CGColor;
    negative.layer.borderColor = [UIColor whiteColor].CGColor;
    equal.layer.borderColor = [UIColor whiteColor].CGColor;
    add.layer.borderColor = [UIColor whiteColor].CGColor;
    decimal.layer.borderColor = [UIColor whiteColor].CGColor;
    three.layer.borderColor = [UIColor whiteColor].CGColor;
    two.layer.borderColor = [UIColor whiteColor].CGColor;
    one.layer.borderColor = [UIColor whiteColor].CGColor;
    four.layer.borderColor = [UIColor whiteColor].CGColor;
    five.layer.borderColor = [UIColor whiteColor].CGColor;
    six.layer.borderColor = [UIColor whiteColor].CGColor;
    subtract.layer.borderColor = [UIColor whiteColor].CGColor;
    six.layer.borderColor = [UIColor whiteColor].CGColor;
    five.layer.borderColor = [UIColor whiteColor].CGColor;
    four.layer.borderColor = [UIColor whiteColor].CGColor;
    seven.layer.borderColor = [UIColor whiteColor].CGColor;
    eight.layer.borderColor = [UIColor whiteColor].CGColor;
    nine.layer.borderColor = [UIColor whiteColor].CGColor;
    multiply.layer.borderColor = [UIColor whiteColor].CGColor;
    divide.layer.borderColor = [UIColor whiteColor].CGColor;
    back.layer.borderColor = [UIColor whiteColor].CGColor;
    parenth.layer.borderColor = [UIColor whiteColor].CGColor;
    clear.layer.borderColor = [UIColor whiteColor].CGColor;

    //style show history button
    //showHistory.layer.borderWidth = 2;
    //showHistory.layer.borderColor = [UIColor whiteColor].CGColor;
    //showHistory.layer.cornerRadius = 15;
    //initialize MISC
    parenthLogic = YES;
    parenthFinish = YES;
    error = NO;
    decimalCheck = NO;
    alert=   [UIAlertController
              alertControllerWithTitle:@"My Title"
              message:@"Enter User Credentials"
              preferredStyle:UIAlertControllerStyleAlert];

    parenthCount = 0;

    powButtons.hidden = YES;
    // make red faster


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //NSLog(@"pow: %f", pow(8,2));

    if ([touch.view isKindOfClass:[UIButton class]])
    {
        if (touch.view != clearHistory &&
            touch.view != showHistory &&
            touch.view != power)
        {
            if (powButtons.hidden == NO)
            {
                powButtons.hidden = YES;
                power.transform = CGAffineTransformMakeScale(1.0, 1.0);
                power.hidden = NO;
                showHistory.hidden=NO;
            }
            
        [self.view bringSubviewToFront:(UIButton*)touch.view];
        UIButton * button = (UIButton*)touch.view;
        // make blue animation
        POPBasicAnimation* animBlue = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
        POPBasicAnimation* fontBlue = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        POPBasicAnimation* animFat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
        animBlue.toValue = [UIColor cyanColor];
        fontBlue.toValue = [UIColor cyanColor];
        animFat.toValue = @3;
        
        [animBlue setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished)
            {
                POPBasicAnimation* animWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                POPBasicAnimation* fontWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                POPBasicAnimation* animSkinny = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                animWhite.toValue = [UIColor whiteColor];
                fontWhite.toValue = [UIColor whiteColor];
                animSkinny.toValue = @1;
                [button.layer pop_addAnimation:animWhite forKey:@"white"];
                [button.titleLabel pop_addAnimation:fontWhite forKey:@"fontwhite"];
                //[button.layer pop_addAnimation:animSkinny forKey:@"skinny"];
            }
        }];
        [button.layer pop_addAnimation:animBlue forKey:@"blue"];
        [button.titleLabel pop_addAnimation:fontBlue forKey:@"fontblue"];
        //[button.layer pop_addAnimation:animFat forKey:@"fat"];
        NSString* text = numberTextField.text;
        NSString* lastCharacter = [NSString stringWithFormat:@"%c",[text characterAtIndex:text.length-1]];
        
        if (touch.view == zero){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if (([lastCharacter rangeOfCharacterFromSet:
                  [NSCharacterSet characterSetWithCharactersInString:@"0123456789.()x+-÷‾"]].location == NSNotFound) && ![text isEqualToString:@""])
            {
                if([lastCharacter isEqualToString:@")"])
                {
                  numberTextField.text = [NSString stringWithFormat:@"%@%@",text,@"x0.0"];
                  decimalCheck = NO;
                }
                else
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"0.0"];
                }
                
            }
            else
            {
                if([lastCharacter isEqualToString:@")"])
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"x0"];
                    decimalCheck = NO;
                }
                else
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"0"];
                }
            }
        }
        else if (touch.view == one){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x1"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".1"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"1"];
            }
        }
        else if (touch.view == two){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x2"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".2"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"2"];
            }
        }
        else if (touch.view == three){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x3"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".3"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"3"];
            }
        }
        else if (touch.view == four){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x4"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".4"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"4"];
            }
        }
        else if (touch.view == five){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x5"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".5"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"5"];
            }
        }
        else if (touch.view == six) {
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x6"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".6"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"6"];
            }
        }
        else if (touch.view == seven) {
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x7"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".7"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"7"];
            }
        }
        else if (touch.view == eight){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x8"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".8"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"8"];
            }
        }
        else if (touch.view == nine){
            if ([lastCharacter isEqualToString:@"("])
            {
                parenthLogic = NO;
                parenthFinish = NO;
            }
            if([lastCharacter isEqualToString:@")"])
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"x9"];
                decimalCheck = NO;
            }
            else if (([lastCharacter isEqualToString:@"0"]) && (text.length == 1)){
                text = [NSString stringWithFormat:@"%@%@",text,@".9"];
            }
            else{
                text = [NSString stringWithFormat:@"%@%@",text,@"9"];
            }
        }


        else if (touch.view == back){
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-x÷"]].location != NSNotFound)
            {
                if (decimalCheck == NO)
                {
                    decimalCheck = YES;
                }
                
            }
            if ([lastCharacter isEqualToString:@"("])
            {
                --parenthCount;
                parenthLogic = YES;
            }
            else if ([lastCharacter isEqualToString:@")"])
            {
                ++parenthCount;
                parenthLogic = NO;
            }
            else
            {}
            if ([text length] > 0) {
                text = [text substringToIndex:[text length] - 1];
            }
            else {
            }
            NSLog(@"parenthcount %lu", parenthCount);
            
        }
        else if (touch.view == divide){
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789)"]].location != NSNotFound)
            {
                decimalCheck = NO;
                text = [NSString stringWithFormat:@"%@%@",text,@"÷"];
            }
        }
        else if (touch.view == multiply) {
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789)"]].location != NSNotFound)
            {
                decimalCheck = NO;
                text = [NSString stringWithFormat:@"%@%@",text,@"x"];
            }
        }
        else if (touch.view == subtract){
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789)"]].location != NSNotFound)
            {
                decimalCheck = NO;
                text = [NSString stringWithFormat:@"%@%@",text,@"-"];
            }
        }

        else if (touch.view == add) {
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789)"]].location != NSNotFound)
            {
                decimalCheck = NO;
                text = [NSString stringWithFormat:@"%@%@",text,@"+"];
            }
        }
        else if (touch.view == clear){
            parenthLogic = YES;
            parenthCount = 0;
            text = @"";
        }
        else if (touch.view == decimal) {
            
            // do a check for a single decimal
            
            if (([text rangeOfString:@"."].location == NSNotFound) || (decimalCheck == NO))
            {
                decimalCheck = YES;
                if ((text.length == 0) || ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"()x+-÷‾"]].location != NSNotFound))
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"0."];
                }
                else
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"."];
                }
            }
            else
            {
                // do nothing
            }
            
        }
        else if (touch.view == parenth) {

            if ([text length] == 0)
            {
                parenthLogic = YES;
            }
            if (parenthLogic)
            {
                if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789)"]].location != NSNotFound)
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"x("];
                    decimalCheck = NO;
                }
                else
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@"("];
                }
                ++parenthCount;
            }
            else
            {
                if (![lastCharacter isEqualToString:@"("])
                {
                    text = [NSString stringWithFormat:@"%@%@",text,@")"];
                     --parenthCount;
                }
                else
                {
                    parenthLogic = YES;
                    parenthFinish = YES;
                    text = [NSString stringWithFormat:@"%@%@",text,@"("];
                    ++parenthCount;
                }
               
                if (parenthCount == 0)
                {
                    parenthLogic = YES;
                }
                else
                {
                    
                }
                
            }
            NSLog(@"parenthcount %lu", parenthCount);
            
        }
        else if (touch.view == negative) {
            if ([lastCharacter rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]].location == NSNotFound)
            {
                text = [NSString stringWithFormat:@"%@%@",text,@"-"];
            }
            

        }
        else {
            for (__strong UIView *subview in self.view.subviews)
            {
                if ([subview isKindOfClass:[UIButton class]])
                {
                    if (subview != showHistory &&
                        subview != clearHistory){
                        UIButton* temp = (UIButton*)subview;

                       // [(UIButton*)subview.layer pop_removeAllAnimations];
                        temp.layer.borderColor = [UIColor whiteColor].CGColor;
                       // [(UIButton*)subview.titleLabel pop_removeAllAnimations];
                        subview = temp;
                    }
                }
            }
            text = [self compute: text];
            
            
                if (error) // Make red animation
                {
                    error = NO;
                    NSLog(@"error");
                // make red animation
                    {
                        tapGesture.enabled = NO;
                        POPBasicAnimation* animRed = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                        POPBasicAnimation* fontRed = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                        POPBasicAnimation* animFat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                        POPBasicAnimation* animWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                        POPBasicAnimation* fontWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                        POPBasicAnimation* animSkinny = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                        animRed.toValue = [UIColor redColor];
                        fontRed.toValue = [UIColor redColor];
                        animFat.toValue = @3;
                        animWhite.toValue = [UIColor whiteColor];
                        fontWhite.toValue = [UIColor whiteColor];
                        animSkinny.toValue = @1;
                        [fontRed setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                            if (finished)
                            {
                               
                                for (__strong UIView *subview in self.view.subviews)
                                {
                                    if ([subview isKindOfClass:[UIButton class]])
                                    {
                                        if (subview != showHistory &&
                                            subview != clearHistory){
                                            UIButton* temp = (UIButton*)subview;
                                            [temp.layer pop_addAnimation:animWhite forKey:@"white"];
                                            [temp.titleLabel pop_addAnimation:fontWhite forKey:@"fontwhite"];
                                            subview = temp;
                                        }
                                    }
                                }
                                
                            }
                        }];
                        [fontWhite setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                            if (finished)
                            {
                                tapGesture.enabled = YES;
                            }
                        }];
                        for (__strong UIView *subview in self.view.subviews)
                        {
                            if ([subview isKindOfClass:[UIButton class]])
                            {
                                if (subview != showHistory &&
                                    subview != clearHistory){
                                    UIButton* temp = (UIButton*)subview;
                                    [temp.layer pop_removeAllAnimations];
                                    [temp.titleLabel pop_removeAllAnimations];
                                    [temp.layer pop_addAnimation:animRed forKey:@"red"];
                                    [temp.titleLabel pop_addAnimation:fontRed forKey:@"fontred"];
                                    // [temp.layer pop_addAnimation:animFat forKey:@"fat"];
                                    
                                    subview = temp;
                                }
                            }
                        }
                        
                    }
                    

                
            }
                /*else
                {
                    error = NO;
                    NSLog(@"No Error");
                    // make blue animation
                    tapGesture.enabled = NO;
                    POPBasicAnimation* animBlue = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                    POPBasicAnimation* fontBlue = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                    POPBasicAnimation* animFat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                    animBlue.toValue = [UIColor cyanColor];
                    fontBlue.toValue = [UIColor cyanColor];
                    animFat.toValue = @3;
                    
                    POPBasicAnimation* animWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                    POPBasicAnimation* fontWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                    POPBasicAnimation* animSkinny = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                    animWhite.toValue = [UIColor whiteColor];
                    fontWhite.toValue = [UIColor whiteColor];
                    animSkinny.toValue = @1;

                    [fontBlue setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                        if (finished)
                        {
                            
                            for (__strong UIView *subview in self.view.subviews)
                            {
                                if ([subview isKindOfClass:[UIButton class]])
                                {
                                    if (subview != showHistory &&
                                        subview != clearHistory){
                                        UIButton* temp = (UIButton*)subview;
                                        [temp.layer pop_addAnimation:animWhite forKey:@"white"];
                                        [temp.titleLabel pop_addAnimation:fontWhite forKey:@"fontwhite"];
                                        //[temp.layer pop_addAnimation:animSkinny forKey:@"skinny"];
                                        subview = temp;
                                    }
                                }
                            }
                            
                        }
                    }];
                    [fontWhite setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                        if (finished)
                        {
                            tapGesture.enabled = YES;
                        }
                    }];
                    
                    for (__strong UIView *subview in self.view.subviews)
                    {
                        if ([subview isKindOfClass:[UIButton class]])
                        {
                            if (subview != showHistory &&
                                subview != clearHistory){
                                UIButton* temp = (UIButton*)subview;
                                [temp.layer pop_removeAllAnimations];
                                [temp.titleLabel pop_removeAllAnimations];
                                [temp.layer pop_addAnimation:animBlue forKey:@"blue"];
                                [temp.titleLabel pop_addAnimation:fontBlue forKey:@"fontblue"];
                               // [temp.layer pop_addAnimation:animFat forKey:@"fat"];
                                
                                subview = temp;
                            }
                        }
                    }
                    
                }*/
            
        }
        numberTextField.text = (NSString*)text;
    }
        else
        {
             if (touch.view == showHistory){
                 [self.view bringSubviewToFront:History];
                 [self.view bringSubviewToFront:clearHistory];
                 NSLog(@"resultHIST:%@",resultHist);
                 power.enabled = NO;
                 if ([showHistory.titleLabel.text isEqualToString:@"🕒"])
                 {

                     //growUP.toValue = {600,400};
                     
                     [History reloadData];
                     History.hidden = NO;
                     
                     tapGesture.enabled = NO;
                     showHistory.enabled = NO;
                     History.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     [UIView animateWithDuration: 0.7
                                           delay: 0            // DELAY
                          usingSpringWithDamping: 0.5
                           initialSpringVelocity: 0.5
                                         options:0
                                      animations:^
                      {
                          History.transform = CGAffineTransformMakeScale(1, 1);
                      }
                                      completion:^(BOOL finished)
                      {
                          if (finished)
                          {
                              tapGesture.enabled = YES;
                              showHistory.enabled =YES;
                              clearHistory.hidden = NO;
                              POPBasicAnimation *moveRight = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                              
                              moveRight.toValue=[NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2, 180)];
                              [clearHistory pop_addAnimation:moveRight forKey:@"move"];
                          }
                      }];

                     [tapGesture setCancelsTouchesInView:NO];
                     [showHistory setTitle:@"⌨" forState:UIControlStateNormal];
                     
                 }
                 else
                 {
                     tapGesture.enabled = NO;
                     showHistory.enabled = NO;
                     [UIView animateWithDuration: 0.3
                                           delay: 0            // DELAY
                          usingSpringWithDamping: 1
                           initialSpringVelocity: 0.5
                                         options: 0
                                      animations:^
                      {
                          History.transform = CGAffineTransformMakeScale(0.0005, 0.0005);
                      }
                                      completion:^(BOOL finished)
                      {
                          if (finished)
                          {
                              History.hidden = YES;
                              tapGesture.enabled = YES;
                              showHistory.enabled = YES;
                              power.enabled = YES;
                        }
                      }];
                     clearHistory.hidden = YES;

                     [showHistory setTitle:@"🕒" forState:UIControlStateNormal];

                 }
            }
             else if (touch.view == clearHistory){
                 [resultHist removeAllObjects];
                 [expressionHist removeAllObjects];
                 [History reloadData];
             }
            else if (touch.view == power)
            {
                //tapGesture.enabled = NO;
                showHistory.hidden = YES;
                
                NSLog(@"hi");
                [UIView animateWithDuration: 0.3
                                      delay: 0            // DELAY
                     usingSpringWithDamping: 1
                      initialSpringVelocity: 0.5
                                    options: 0
                                 animations:^
                 {
                     power.transform = CGAffineTransformMakeScale(1, 0.0005);
                 }
                                 completion:^(BOOL finished)
                 {
                     if (finished)
                     {
                         powButtons.selected = NO;
                         [powButtons setSelectedSegmentIndex:UISegmentedControlNoSegment];
                         powButtons.hidden = NO;
                         /*for (__strong UIView *subview in self.view.subviews)
                         {
                             if ([subview isKindOfClass:[UIButton class]])
                             {
                                 if (subview != showHistory &&
                                     subview != clearHistory){
                                     UIButton* temp = (UIButton*)subview;
                                     temp.alpha = .5;
                                     temp.enabled = NO;
                                     
                                     
                                     subview = temp;
                                 }
                             }
                         }*/

                         POPBasicAnimation *moveLeft = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
                         
                         moveLeft.toValue=[NSValue valueWithCGRect:
                                            CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-(powButtons.bounds.size.width/2),
                                                150, powButtons.bounds.size.width, powButtons.bounds.size.height)];
                         
                         [powButtons pop_addAnimation:moveLeft forKey:@"move"];


                     }
                 }];

            }
        }
        
        
    }
    else if([touch.view isKindOfClass:[UISegmentedControl class]]){
        powButtons.hidden = YES;
    }
    else{}
    
    return YES;
}

-(NSString*) compute:(NSString*)text
{
    NSLog(@"text: %@", text);
    NSString *express = text;
    text = [text stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
    text = [text stringByReplacingOccurrencesOfString:@"÷" withString:@"/1.0/"];
    NSLog(@"newtext: %@", text);

    // wrote my own parser
    // PEMDAS?
    NSExpression *expression;
    //Parenthesis
    NSInteger begincount = 0;
    NSInteger endcount = 0;
        
   // text = floatText;
    for (NSInteger i = 0; i < text.length; ++i) // loop through every character in text
    {
        NSString* character = [NSString stringWithFormat:@"%c",[text characterAtIndex:i]];
        if ([character isEqualToString:@"("])
        {
            ++begincount;
        }
        else if ([character isEqualToString:@")"])
        {
            ++endcount;
        }

    }

    if (begincount == endcount)
    {
        // make sure syntax doesn't lead to uncaught exception
        @try{
        expression = [NSExpression expressionWithFormat:[NSString stringWithFormat:@"%@", text]];
        }
        @catch(NSException *exception){
            error = YES;
            
        }
        @finally{
            
        }
            if (expression == nil)
            {
                parenthLogic = YES;
                error = YES;
                return 0;
            }
            else
            {
                NSLog(@"expression: %@", [expression expressionValueWithObject:nil context:nil]);
                NSNumber * numberResult = [expression expressionValueWithObject:nil context:nil] ;
                NSPredicate * parsed = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"1.0 * %@ = 0", text]];
                NSExpression * left = [(NSComparisonPredicate *)parsed leftExpression];
                numberResult = [left expressionValueWithObject:nil context:nil];
                
                NSString *stringResult = [numberResult stringValue];
                if ([stringResult isEqualToString:@"inf"])
                {
                    error = YES;
                    return 0;
                }
                if ([resultHist count] == 10)
                {
                    [resultHist removeObjectAtIndex:0];
                }
                if ([expressionHist count] == 10)
                {
                    [expressionHist removeObjectAtIndex:0];
                }
                [resultHist addObject:stringResult];
                [expressionHist addObject:express];
                return stringResult;
            }
    }
    else
    {
        parenthLogic = YES;
        error = YES;
        return 0;
    }
}

/// TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [resultHist count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ = %@",[expressionHist objectAtIndex:[expressionHist count]-indexPath.row-1], [resultHist objectAtIndex:[resultHist count]-indexPath.row-1]];
    
    cell.textLabel.font  = myFont;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // here we get the cell from the selected row.
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
   
    NSArray *getExpress = [selectedCell.textLabel.text componentsSeparatedByString:@" ="];
    NSString *expression = [getExpress objectAtIndex:0];
    expression = [expression stringByReplacingOccurrencesOfString:@"*" withString:@"x"];
    expression = [expression stringByReplacingOccurrencesOfString:@"/" withString:@"÷"];

    NSLog(@"expression: %@", expression);
    numberTextField.text = expression;
    tapGesture.enabled = NO;
    showHistory.enabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIView animateWithDuration: 0.3
                          delay: 0            // DELAY
         usingSpringWithDamping: 1
          initialSpringVelocity: 0.5
                        options: 0
                     animations:^
     {
         History.transform = CGAffineTransformMakeScale(0.0005, 0.0005);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             History.hidden = YES;
             showHistory.enabled = YES;
             tapGesture.enabled = YES;
        }
     }];
    clearHistory.hidden = YES;

    [showHistory setTitle:@"🕒" forState:UIControlStateNormal];

        // use the image in the next window using view controller instance of that view.
}
- (IBAction)decodeButton:(id)sender {
    NSLog(@"segmented control tapped");
    powButtons.hidden = YES;
    showHistory.hidden = NO;
    power.hidden = NO;
    power.transform = CGAffineTransformMakeScale(1.0, 1.0);
    for (__strong UIView *subview in self.view.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            if (subview != showHistory &&
                subview != clearHistory){
                UIButton* temp = (UIButton*)subview;
                temp.alpha = 1;
                temp.enabled = YES;
                // [temp.layer pop_addAnimation:animFat forKey:@"fat"];
                
                subview = temp;
            }
        }
    }
    
    if (powButtons.selectedSegmentIndex == 0 )
    {
        NSLog(@"x^2");
        numberTextField.text = [NSString stringWithFormat:@"%@%@",numberTextField.text,@"^"];
    }
    else if (powButtons.selectedSegmentIndex == 1)
    {
        NSLog(@"✓x");
        numberTextField.text = [NSString stringWithFormat:@"%@%@",numberTextField.text,@"✓"];
    }
    else {}
    
}
// 70, 250

@end
