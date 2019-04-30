//
//  MyHackss.m
//  deepfinity
//
//  Created by Hamidreza Vakilian on 10/28/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "MyHacks.h"
#import "Codebase_definitions.h"

void MyHacks$moveStatusBarOut(void)
{
    UIWindow* statusBarWindow = MyHacks$statusBarWindow();
    //i didn't use -statusBarFrame.size.height because sometimes [[UIApplication sharedApplication] statusBarFrame] returns 0,0,0,0
    statusBarWindow.frame = CGRectSetY(statusBarWindow, -100);
}

UIWindow* MyHacks$statusBarWindow(void)
{
    return (UIWindow *)[[UIApplication sharedApplication] valueForKey:MyHacks$EncodeText(@"tubuvtCbsXjoepx", -1)];
   
}

void MyHacks$moveStatusBarIn(void)
{
    UIWindow* statusBarWindow = MyHacks$statusBarWindow();
    statusBarWindow.frame = CGRectSetY(statusBarWindow, 0);
}

NSString* MyHacks$EncodeText(NSString *string, int key)
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < (int)[string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        c += key;
        [result appendString:[NSString stringWithCharacters:&c length:1]];
    }
    
    return result;
}
