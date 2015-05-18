//
//  ViewController.h
//  CCValidation
//
//  Created by Sanjay Tourani on 5/3/15.
//  
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField * cardNumber;
    UITextField * date;
    UITextField * cvvnum;
    UIScrollView * cardTypeView;
    UIScrollView * cvvTypeView;
    
    UIView * coverView;
}

@end

