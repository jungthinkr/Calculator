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

// still an issue with decimal with parentheses
// still an issue with parentheses
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


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    

    if ([touch.view isKindOfClass:[UIButton class]])
    {
        if (touch.view != clearHistory &&
            touch.view != showHistory)
        {
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
                [button.layer pop_addAnimation:animSkinny forKey:@"skinny"];
            }
        }];
        [button.layer pop_addAnimation:animBlue forKey:@"blue"];
        [button.titleLabel pop_addAnimation:fontBlue forKey:@"fontblue"];
        [button.layer pop_addAnimation:animFat forKey:@"fat"];
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
            text = [self compute: text];
            
                
                if (error) // Make red animation
                {
                    error = NO;
                    NSLog(@"error");
                // make red animation
                
                POPBasicAnimation* animRed = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                POPBasicAnimation* fontRed = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                POPBasicAnimation* animFat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                animRed.toValue = [UIColor redColor];
                fontRed.toValue = [UIColor redColor];
                animFat.toValue = @3;
                
                [animRed setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    if (finished)
                    {
                        POPBasicAnimation* animWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
                        POPBasicAnimation* fontWhite = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                        POPBasicAnimation* animSkinny = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderWidth];
                        animWhite.toValue = [UIColor whiteColor];
                        fontWhite.toValue = [UIColor whiteColor];
                        animSkinny.toValue = @1;
                        for (__strong UIView *subview in self.view.subviews)
                        {
                            if ([subview isKindOfClass:[UIButton class]])
                            {
                                UIButton* temp = (UIButton*)subview;
                                [temp.layer pop_addAnimation:animWhite forKey:@"white"];
                                [temp.titleLabel pop_addAnimation:fontWhite forKey:@"fontwhite"];
                                [temp.layer pop_addAnimation:animSkinny forKey:@"skinny"];
                                subview = temp;
                            }
                        }
                        
                    }
                }];
                for (__strong UIView *subview in self.view.subviews)
                {
                    if ([subview isKindOfClass:[UIButton class]])
                    {
                        UIButton* temp = (UIButton*)subview;
                        [temp.layer pop_addAnimation:animRed forKey:@"red"];
                        [temp.titleLabel pop_addAnimation:fontRed forKey:@"fontred"];
                        [temp.layer pop_addAnimation:animFat forKey:@"fat"];
                        
                        subview = temp;
                    }
                }
                
            }
            
        }
        numberTextField.text = (NSString*)text;
    }
        else
        {
             if (touch.view == showHistory){
                 [self.view bringSubviewToFront:History];
                 [self.view bringSubviewToFront:clearHistory];
                 NSLog(@"resultHIST:%@",resultHist);
                 if ([showHistory.titleLabel.text isEqualToString:@"History"])
                 {
                     [History reloadData];
                     History.hidden = NO;
                     clearHistory.hidden = NO;
                     [showHistory setTitle:@"Hide" forState:UIControlStateNormal];
                 }
                 else
                 {
                     History.hidden = YES;
                     clearHistory.hidden = YES;
                     [showHistory setTitle:@"History" forState:UIControlStateNormal];
                 }
            }
             else{
                 [resultHist removeAllObjects];
                 [expressionHist removeAllObjects];
                 [History reloadData];
             }
        }
        
        
    }
    
    return YES;
}

-(NSString*) compute:(NSString*)text
{
    NSLog(@"text: %@", text);
    text = [text stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
    text = [text stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    text = [text stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    if ([text rangeOfString:@"/0"].location != NSNotFound)
        {
            NSLog(@"divided by zero");
            parenthLogic = YES;
            error = YES;
            return 0;
        }
    // wrote my own parser
    // PEMDAS?
    NSExpression *expression;
    //Parenthesis
    NSInteger begincount = 0;
    NSInteger endcount = 0;
    NSLog(@"text: %@", text);
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
                if ([resultHist count] == 7)
                {
                    [resultHist removeObjectAtIndex:0];
                }
                if ([expressionHist count] == 7)
                {
                    [expressionHist removeObjectAtIndex:0];
                }
                [resultHist addObject:stringResult];
                [expressionHist addObject:text];
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

    cell.textLabel.text = [NSString stringWithFormat:@"%@ = %@",[expressionHist objectAtIndex:indexPath.row], [resultHist objectAtIndex:indexPath.row]];
    
    cell.textLabel.font  = myFont;
    return cell;
}


@end
