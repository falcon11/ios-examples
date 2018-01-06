//
//  RunTimeDemoViewController.m
//  Examples
//
//  Created by Ashoka on 05/01/2018.
//  Copyright © 2018 Ashoka. All rights reserved.
//

#import "RunTimeDemoViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSDate *begin;

@interface RunTimeDemoViewController (){
}

@end

@implementation RunTimeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    ((void (*)(id, SEL, BOOL))(void *)_objc_msgForward)(self, @selector(viewWillDisappear:), YES);
}

+ (void)dynamicAddPrintHelloWord {
    SEL sel = @selector(myPrint);
    // class_addMethod 可以重写父类方法.
    // "v@:": Since the function must take at least two arguments—self and _cmd, the second and third characters must be “@:” (the first character is the return type).
    class_addMethod(self, sel, (IMP)printSomething, "v@:@");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    begin = [NSDate date];
    [self performSelector:@selector(myPrint) withObject:@"hello world"];
}

- (int)push {
    UIViewController* v = [UIViewController new];
    [self presentViewController:v animated:YES completion:nil];
    return 1;
}

void printSomething(id self, SEL _cmd, id text)
{
    NSLog(@"%s %s:动态添加的方法", __FUNCTION__, _cmd);
    NSLog(@"%@", text);
    NSLog(@"time: %lf", [[NSDate date] timeIntervalSinceDate: begin]);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    BOOL rslt = [super resolveInstanceMethod:sel];
    if (sel == @selector(myPrint)) {
        [self dynamicAddPrintHelloWord];
        int count;
        //只打印该类自己实现的方法，不打印父类方法
        Method *m = class_copyMethodList(self, &count);
        Method *t = m;
        for(int i=0; i< count; i++) {
            NSLog(@"method: %s, %s, %s", method_getName(t[i]), method_getDescription(t[i])->name, method_getDescription(t[i])->types);
        }
        rslt = YES;
    }
    return rslt; // 1
}

- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    id rslt = [super forwardingTargetForSelector:aSelector];
    //    rslt = self.target;
    return rslt; // 2
}

//OBJC_SWIFT_UNAVAILABLE("")
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    id rslt = [super methodSignatureForSelector:aSelector];
    if (aSelector == @selector(myPrint)) {
        NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        rslt = sig;
    }
    return rslt; // 3
}

//OBJC_SWIFT_UNAVAILABLE("")
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = anInvocation.selector;
    NSLog(@"target: %@, %@", anInvocation.target, anInvocation);
    if (sel == @selector(myPrint)) {
        class_addMethod(self.class, @selector(myPrint), (IMP)printSomething, "v@:@");
        [anInvocation invokeWithTarget:self];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    // 在crash前 保存crash数据，供分析
    [super doesNotRecognizeSelector:aSelector]; // crash
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
