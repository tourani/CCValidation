//
//  ViewController.m
//  CCValidation
//
//  Created by Sanjay Tourani on 5/3/15.
// 
//

#import "ViewController.h"
#define CARD_NUMBER 110
#define EXPIRY_DATE 111
#define CVV_NUMBER 112
@interface ViewController ()
typedef NS_OPTIONS(NSUInteger, CCardName) {
    None = 0,
    Amex,
    discover,
    JCB,
    Master,
    Visa,
    Other
};
@property(nonatomic, assign) CCardName cardName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.cardName = None;
    
    int topYmargin = 160;
    
    UITapGestureRecognizer * resignFlds = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:resignFlds];
    
    cardNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    [self.view addSubview:cardNumber];
    cardNumber.center = CGPointMake(self.view.frame.size.width/2-30, topYmargin);
    cardNumber.borderStyle = UITextBorderStyleRoundedRect;
    cardNumber.textAlignment = NSTextAlignmentCenter;
    cardNumber.placeholder = @"Card Number";
    cardNumber.keyboardType = UIKeyboardTypeNumberPad;
    cardNumber.delegate = self;
    cardNumber.tag = CARD_NUMBER;

    cardTypeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [self.view addSubview:cardTypeView];
    cardTypeView.contentSize = CGSizeMake(50, cardTypeView.frame.size.height*7);
    for (int i = 0; i < 7; i ++) {
        UIImageView * lable;
        if (i == 0 || i == 6) {
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericCard.png"]];
        }else if(i == 1){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Amex.png"]];
        }else if (i == 2){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Discover.png"]];
        }else if(i == 3){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JCB.png"]];
        }else if(i == 4){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mastercard.png"]];
        }else if(i == 5){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Visa.png"]];
        }
        lable.center = CGPointMake(cardTypeView.frame.size.width/2, (cardTypeView.frame.size.height * i)+cardTypeView.frame.size.height/2);
        [cardTypeView addSubview:lable];
    }
    cardTypeView.pagingEnabled = YES;
    cardTypeView.center = CGPointMake(self.view.frame.size.width/2+115, topYmargin);
    UIView * coverViewT = [[UIView alloc] initWithFrame:cardTypeView.frame];
    [coverViewT setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:coverViewT];
    
    cvvTypeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [self.view addSubview:cvvTypeView];
    cvvTypeView.contentSize = CGSizeMake(50, cvvTypeView.frame.size.height*7);
    for (int i = 0; i < 2; i ++) {
        UIImageView * lable;
        if (i == 0) {
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CVV.png"]];
        }else if(i == 1){
            lable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AmexCVV.png"]];
        }
        lable.center = CGPointMake(cvvTypeView.frame.size.width/2, (cvvTypeView.frame.size.height * i)+cvvTypeView.frame.size.height/2);
        [cvvTypeView addSubview:lable];
    }
    cvvTypeView.pagingEnabled = YES;
    cvvTypeView.center = CGPointMake(self.view.frame.size.width/2+115, topYmargin + 75);
    UIView * coverCVVViewT = [[UIView alloc] initWithFrame:cvvTypeView.frame];
    [coverCVVViewT setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:coverCVVViewT];
    
    UIPickerView * picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;

    date = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:date];
    date.center = CGPointMake(self.view.frame.size.width/2 - 90, topYmargin + 75);
    date.borderStyle = UITextBorderStyleRoundedRect;
    date.textAlignment = NSTextAlignmentCenter;
    date.placeholder = @"Expiry";
//    date.keyboardType = UIKeyboardTypeNumberPad;
    date.inputView = picker;
    date.delegate = self;
    date.tag = EXPIRY_DATE;
    
    cvvnum = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:cvvnum];
    cvvnum.center = CGPointMake(self.view.frame.size.width/2 + 30, topYmargin + 75);
    cvvnum.borderStyle = UITextBorderStyleRoundedRect;
    cvvnum.textAlignment = NSTextAlignmentCenter;
    cvvnum.placeholder = @"CVV";
    cvvnum.keyboardType = UIKeyboardTypeNumberPad;
    cvvnum.delegate = self;
    cvvnum.tag = CVV_NUMBER;
    
    
    
    UIButton * validateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [validateButton setFrame:CGRectMake(0, 0, 280, 50)];
    [self.view addSubview:validateButton];
    validateButton.center = CGPointMake(self.view.frame.size.width/2, topYmargin + 150);
    [validateButton addTarget:self action:@selector(validateCardNumber) forControlEvents:UIControlEventTouchUpInside];
    [validateButton setTitle:@"Validate" forState:UIControlStateNormal];
    [validateButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [validateButton setBackgroundColor:[UIColor blueColor]];
    validateButton.layer.cornerRadius = 7;
    
    
    // cover layer
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    [coverView setBackgroundColor:[UIColor clearColor]];
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"5555555555554444 %d",[self luhnValidation:@"555555"]);
//    NSLog(@"371449635398431 %d",[self luhnValidation:@"371449635398431"]);
//    NSLog(@"3530111333300000 %d",[self luhnValidation:@"3530111333300000"]);
//    NSLog(@"378282246310005 %d",[self luhnValidation:@"378282246310005"]);
//    NSLog(@"6011111111111117 %d",[self luhnValidation:@"6011111111111117"]);
//    NSLog(@"4111111111111111 %d",[self luhnValidation:@"4111111111111111"]);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 12;
    }else{
        return 75;
    }
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if(component == 0){
        date.text = [NSString stringWithFormat:@"%d/%d",row+1,[[[date.text componentsSeparatedByString:@"/"] lastObject] intValue]];
    }else{
        date.text = [NSString stringWithFormat:@"%d/%d",[[[date.text componentsSeparatedByString:@"/"] firstObject] intValue],row+15];
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d",row+1];
    }else{
        return [NSString stringWithFormat:@"20%d",row+15];
    }
}
-(void) hideKeyboard{
    [cardNumber resignFirstResponder];
    [cvvnum resignFirstResponder];
    [date resignFirstResponder];
}
-(void) validateCardNumber{
    [self hideKeyboard];
    if (cardNumber.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter card number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    if (date.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select Expiry date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    if (self.cardName == Amex) {
        if (cardNumber.text.length != 15) {
            [[[UIAlertView alloc] initWithTitle:@"Invalid Card Number" message:@"Card number must be 15 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            return;
        }else{
            if ([self luhnValidation:cardNumber.text]) {
                // check for cvv number
                if (cvvnum.text.length != 4) {
                    [[[UIAlertView alloc] initWithTitle:@"Invalid CVV Number" message:@"CVV number must be 4 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Valid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Invalid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }
    }else if(self.cardName == Other){
            if ([self luhnValidation:cardNumber.text]) {
                [[[UIAlertView alloc] initWithTitle:@"Valid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Invalid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
    }else{
        if (cardNumber.text.length != 16) {
            [[[UIAlertView alloc] initWithTitle:@"Invalid Card Number" message:@"Card number must be 16 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            return;
        }else{
            if ([self luhnValidation:cardNumber.text]) {
                // check for cvv number
                if (cvvnum.text.length != 3) {
                    [[[UIAlertView alloc] initWithTitle:@"Invalid CVV Number" message:@"CVV number must be 3 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Valid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Invalid Card Number" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }
    }
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == EXPIRY_DATE) {
        if (date.text.length == 0) {
            date.text = @"1/15";
        }
    }
    [textField addSubview:coverView];
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    [coverView removeFromSuperview];
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // validating the card

    switch (textField.tag) {
        case CARD_NUMBER:
            if (string.length) {
                [self cardTypeChecking:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            }else{
                [self cardTypeChecking:textField.text.length ? [textField.text substringToIndex:textField.text.length-1]:@""];
            }
            if (self.cardName == Amex) {
                if (string.length && textField.text.length == 15) {
                    return NO;
                }else
                    return YES;
            }else if(self.cardName == Other){
                return YES;
            }else{
                if (string.length && textField.text.length == 16) {
                    return NO;
                }
                return YES;
            }
            break;
        case CVV_NUMBER:
            if (self.cardName == Amex) {
                if (string.length && textField.text.length == 4) {
                    return NO;
                }else
                    return YES;
//            }else if(self.cardName == Other){
//                return YES;
            }else{
                if (string.length && textField.text.length == 3) {
                    return NO;
                }
                return YES;
            }
            break;
            break;
        default:
            break;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) cardTypeChecking:(NSString *) cardno{
    // Amex - starting with 34-done, 37-done
    // Discover - starting with 6011-done, 622126-622925-done, 644-649-done, 65-done
    // jcb - starting with 3528-3589-done
    // master starting with 51-55-done
    // visa 4-done
    
    switch (cardno.length) {
        case 0:
            self.cardName = None;
            NSLog(@"None");
            break;
        case 1:
            if ([[NSString stringWithFormat:@"%c", [cardno characterAtIndex:0]] intValue] == 4) {
                self.cardName = Visa;
                NSLog(@"Visa");
            }else{
                self.cardName = Other;
                NSLog(@"other");
            }
            break;
        case 2:{
            int twoDigits = [[NSString stringWithFormat:@"%c%c", [cardno characterAtIndex:0],[cardno characterAtIndex:1]] intValue];
            if (twoDigits >= 51 && twoDigits <= 55) {
                NSLog(@"Master card ");
                self.cardName = Master;
            }
            else if (twoDigits == 34 || twoDigits == 37){
                NSLog(@"Amex");
                self.cardName = Amex;
            }else{
            }
            
        }
            break;
        case 3:{
            int threeDigits = [[NSString stringWithFormat:@"%c%c%c", [cardno characterAtIndex:0],[cardno characterAtIndex:1],[cardno characterAtIndex:2]] intValue];
            if (threeDigits >= 644 && threeDigits <= 649){
                NSLog(@"Discover");
                self.cardName = discover;
            }else{
            }
            
        }
            break;
        case 4:{
            int fourDigits = [[NSString stringWithFormat:@"%c%c%c%c", [cardno characterAtIndex:0],[cardno characterAtIndex:1],[cardno characterAtIndex:2],[cardno characterAtIndex:3]] intValue];
            if (fourDigits == 6011){
                self.cardName = discover;
                NSLog(@"Discover");
            }else if (fourDigits >= 3528 && fourDigits <= 3589){
                self.cardName = JCB;
                NSLog(@"JCB");
            }else{
            }
            
        }
            break;
        case 6:{
            long sixDigit = [[NSString stringWithFormat:@"%c%c%c%c%c%c", [cardno characterAtIndex:0],[cardno characterAtIndex:1],[cardno characterAtIndex:2],[cardno characterAtIndex:3],[cardno characterAtIndex:4],[cardno characterAtIndex:5]] intValue];
            if (sixDigit >= 622126 && sixDigit <= 622925){
                NSLog(@"Discover");
                self.cardName = discover;
            }else{
            }
            
        }
            break;
        default:
            break;
    }
    
    [cardTypeView setContentOffset:CGPointMake(0, cardTypeView.frame.size.height * self.cardName) animated:YES];
    [cvvTypeView setContentOffset:CGPointMake(0, cvvTypeView.frame.size.height * (self.cardName == Amex)) animated:YES];
}


- (BOOL) luhnValidation:(NSString *)cardno {
    [self cardTypeChecking:cardno];
    
    // converting each element to
    // minimum 3 digits to handle crash.
    if (cardno.length < 3) {
        return NO;
    }
    NSMutableArray *numsArray = [[NSMutableArray alloc] initWithCapacity:[cardno length]];
    for (int i=0; i < [cardno length]; i++) {
        NSString *num  = [NSString stringWithFormat:@"%c", [cardno characterAtIndex:i]];
        [numsArray addObject:num];
    }
    int singlesSum = 0;
    int mulByNAddSum = 0;
    int lenght = numsArray.count;
    for (int i = lenght - 3; i >= 0; i-=2) {
        singlesSum += [(NSString *)[numsArray objectAtIndex:i] intValue];
    }
    for (int i = lenght - 2; i >= 0; i-=2) {
        mulByNAddSum += [(NSString *)[numsArray objectAtIndex:i] intValue]/5 + (2*[(NSString *)[numsArray objectAtIndex:i] intValue]) % 10;
    }
    int total = singlesSum + mulByNAddSum;
    // check sum = 10 - (( sum of alternative nums starting from reverse index 1 (sum of result of (digit x 2))) + sum of other numbers)
    // last %10 is to handle 0 case.
    int checkSum = (10 - (total % 10))%10;
    return checkSum == [(NSString *)[numsArray objectAtIndex:lenght - 1] intValue];
}
@end
