//
//  SLEditViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//
#import "SLMainTableViewController.h"
#import "SLEditViewController.h"
#import "SLShoppingListData.h"

@interface SLEditViewController ()
{
    NSMutableArray *editVCArray;
}

@end

@implementation SLEditViewController

@synthesize indexpath;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!_isEditing) {
        
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(addListDataAction:)];
        self.navigationItem.rightBarButtonItem = addBtn;
        self.title = NSLocalizedString(@"Add", "");

        // AddList Data.
        
    } else {
        
        self.title = NSLocalizedString(@"Edit", "");
        editVCArray = [[SLShoppingListData sharedInstance] getSLDataArray: self.indexpath];
        
        _editTextView.text = [editVCArray objectAtIndex: indexpath.row][@"data"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillChange:)
                                                 name: UIKeyboardDidShowNotification
                                               object: nil];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [_editTextView becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    [_editTextView resignFirstResponder];
    
}

-(void)viewDidAppear: (BOOL)animated {
    
    [super viewDidAppear: animated];
    
}

- (void)keyboardWillChange: (NSNotification *)notification {
    
    NSLog(@"KeyBoard Height : %f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    _bottomHeightTxtView.constant = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
}

-(void)appendDataDictToPlist: (NSString *) editText {
    
    if ([editText length] == 0) {
        
        NSLog(@"length zero");
        
    } else {
        
        NSLog(@"appendDataDictToPlist : %@", editText);
        
        NSMutableDictionary *editList = [NSMutableDictionary dictionary];
        [editList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
        [editList setValue: editText forKey: @"data"];
        
        // [[SLShoppingListData sharedInstance].SLDataArray insertObject: editList atIndex: 0];
        [editVCArray insertObject: editList atIndex: 0];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: editVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
    }
}

- (IBAction)SaveList: (id)sender {
    
    NSString *edited = _editTextView.text;
    NSLog(@"edited : %@", edited);
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [edited componentsSeparatedByCharactersInSet:separator];
    NSMutableArray *newAdded = [[rows subarrayWithRange:NSMakeRange(1, rows.count-1)] mutableCopy];
    if (_isEditing) {
        
        if ([self.delegate respondsToSelector: @selector(editedList:newAdded:)]) {
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            for (int i=0; i < [newAdded count]; i++) {
                if ([[newAdded objectAtIndex:i] isEqualToString:@""]) {
                    [indexes addIndex: i];
                }
            }
            [newAdded removeObjectsAtIndexes: indexes];
            [self.delegate editedList: rows[0] newAdded: newAdded];
        }
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}

-(IBAction) addListDataAction: (id)sender
{
    NSLog(@"addListDataAction");
    
    NSString *addText = _editTextView.text;
    NSLog(@"addText : %@", addText);
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSMutableArray *rows = [[addText componentsSeparatedByCharactersInSet: separator] mutableCopy];
    
    if ([self.delegate respondsToSelector: @selector(addedList:)]) {
        
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        for (int i=0; i < [rows count]; i++) {
            if ([[rows objectAtIndex:i] isEqualToString:@""]) {
                [indexes addIndex: i];
            }
        }
        [rows removeObjectsAtIndexes: indexes];
        [self.delegate addedList: rows];
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)CancelList: (id)sender {
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
