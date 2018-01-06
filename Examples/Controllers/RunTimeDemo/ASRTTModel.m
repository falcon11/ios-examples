//
//  ASRTTModel.m
//  Examples
//
//  Created by Ashoka on 05/01/2018.
//  Copyright © 2018 Ashoka. All rights reserved.
//

#import "ASRTTModel.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation ASRTTModel

+ (void)func1 {
    printf("%s %s", __FUNCTION__, _cmd);
}


/**
 <#Description#>

 @param arg1 <#arg1 description#>
 @param arg2 <#arg2 description#>
 */
- (void)func2:(id)arg1 arg2:(id)arg2 {
    NSLog(@"%s %@ %@", __FUNCTION__, [arg1 description], [arg2 description]);
}

- (void)func3 {
    [self func2:@"hello" arg2:@"world"];
}

- (void)func4 {
//    [self func3];
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("func3"));
}

@end
