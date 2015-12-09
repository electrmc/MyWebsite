//
//  InvocationTest.m
//  RuntimeFunction
//
//  Created by MiaoChao on 15/10/15.
//  Copyright © 2015年 MiaoChao. All rights reserved.
//

#import "InvocationTest.h"

@implementation InvocationTest

- (NSArray *)addTestString1:(NSString *)str1 string2:(NSString*)str2{
    return @[str1,str2];
}

/*******************************normal方式*******************************/
- (void)performSelNormal{
    InvocationTest *test1 = [[InvocationTest alloc] init];
    NSArray *strAry = [test1 addTestString1:@"str1" string2:@"str2"];
    NSLog(@"normal = %@",strAry);
    
    //performSelector最多可以有两个参数
    NSLog(@"performSelector = %@",[test1 performSelector:@selector(addTestString1:string2:) withObject:@"str1" withObject:@"str2"]);
}

/*******************************NSInvocation方式***************************/
- (void)performSelInvocation{
    NSMethodSignature *signature = [[InvocationTest class] instanceMethodSignatureForSelector:@selector(addTestString1:string2:)];
    NSInvocation *myInvocation = [NSInvocation invocationWithMethodSignature:signature];
    
    InvocationTest *test1 = [[InvocationTest alloc] init];
    [myInvocation setTarget:test1];
    
    //此处的方法必须要是实现了的方法
    
    [myInvocation setSelector:@selector(addTestString1:string2:)];
    
    // 如果此消息有参数需要传入，参数是void*类型，需要注意的是atIndex的下标必须从2开始。
    // 因为：0 1 两个参数已经被target 和selector占用
    // id(泛型对象)和void*(泛型指针)并非完全一样
    // 此方法仅仅是把str1拷贝到buffer中，不会有持有对象，因此需要防止对象被释放
    
    NSString *str1 = @"invocationStr1",*str2 = @"invocationStr2";;
    [myInvocation setArgument:&str1 atIndex:2];
    [myInvocation setArgument:&str2 atIndex:3];
    
    // retain所有参数（包含target），防止参数被释放dealloc
    // 释放由系统控制，至于要retain还是copy系统会决定，block系统会copy
    
    [myInvocation retainArguments];
    
    // invoke 可以多次执行
    [myInvocation invoke];
    
    // 此处需要注意getReturnValue:参数的属性
    // getReturnValue方法只是简单地把返回值数据拷贝给内存中的buffer，不会考虑内存管理
    // 如下两句在在ARC中会出问题的，在MRC中不会有问题
    // NSArray *ary = nil; [myInvocation getReturnValue:&ary];
    // 原因:在ARC中默认的声明是__strong类型的，ary = xx;ary会持有xx的强引用
    // 通过getReturnValue:方法往ary中简单得拷贝数据后，ary并未对其指向的内存持有强引用
    // 而当ARC判断ary应当释放时，会对ary持有的对象发送release方法，就会造成过度释放问题
    // 详细解释如下
    // http://stackoverflow.com/questions/22018272/nsinvocation-returns-value-but-makes-app-crash-with-exc-bad-access
    
    // 下面是具体的解决方案
    void *tempResult=NULL;
    [myInvocation getReturnValue:&tempResult];
    NSArray *result = (__bridge NSArray*)tempResult;//ARC will retain pointer after assignment
    NSLog(@"The NSInvocation invoke string is:%@ in solution1",result);
    
    // 此处只能用__unsafe_unretained不能用__weak
    // NSArray * __weak tempResultSet;
    // __unsafe_unretained相当于assagin，不会自动把值置为nil
    NSArray * __unsafe_unretained tempResultSet;
    [myInvocation getReturnValue:&tempResultSet];
    NSArray *resultSet = tempResultSet;
    NSLog(@"The NSInvocation invoke string is:%@ in solution2",resultSet);
    
    [myInvocation invoke];
    NSString *resultStr1 = @"resultSpecial";
    // setReturnValue可以指定方法的返回值，而且只有在invoke之后才有效
    // 同时它不会受invoke返回值的约束，这里设定什么，则会返回什么
    // 该方法需要返回一个NSArray，这里设定NSString值
    [myInvocation setReturnValue:&resultStr1];
    
    [myInvocation getReturnValue:&tempResult];
    NSArray *result1 = (__bridge NSArray*)tempResult;
    NSLog(@"this result will special :%@",result1);
}

// NSObject __weak *objc;
// __weak 其功能是如果其指向的内存被释放了，那么他会自动设为nil
// 那么此功能的实现必定是在类似set和get方法中实现的
// 官方文档：http://clang.llvm.org/docs/AutomaticReferenceCounting.html#weak-unavailable-types
// 官方文档说过：如果“右值”指针指向的内存地址有内容，那么“左值”就会被更新为指向该内容的指针。
//             如果其指向的内容被释放，自身会自动设为nil。
//
// 此处需要注意的是“左值”，那么必定意味着赋值语句发生了，也就是调用了类似set的方法。
// 可以想象，在set方法中必定有判断过程，通过了一系列判断才会将objc成功赋值。
//
// 其次，自动设为nil是怎么发生的？应该是用到该指针时才会进行判断，然后决定将自身设为nil还是保持原值
// 否则，不是在用到时判断而是实时更新的话，程序中如此多得对象，可以想象系统需要维护一张多么大的关系表来保证实时的更新每个指针的内容
// 既然是用到时，那么必定是调用了get方法，可以相信，在get中进行了判断，决定是返回原值还是返回nil
//
// getReturnValue:&objc 是直接把值copy给了objc，跳过了set的过程。那么，本该在该过程中做得事情都没完成
// NSObject *otherObjc = objc;
// 此时调用get方法，而set方法未做，也就是很多前置条件未完成，那么get必定不过，返回nil
// 这也就解释了objc中明明有值，而将其赋值给otherObjc时，otherObjc却未nil
//
// __unsafe_unretained相当于assagin，不会有判断过程，(可能专门的set和get方法都不会有)，会直接把其值返回
//

/***************@encode(aType) 可以返回该类型的名称，以 C 字符串（char *）表示********************/
- (void)getTypeNameInCString{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"key1",
                                                                   [NSNumber numberWithDouble:100.00f],@"key2",
                                                                   [NSNumber numberWithInt:200],@"key3",
                                                                   [NSNumber numberWithFloat:300.0f], @"key4",nil];
    
    for(NSString *keym in dic){//这种方式，会无序的遍历dic中的key
        id value = [dic valueForKey:keym];
        if([value isKindOfClass:[NSNumber class]]){
            
            const char * pObjCType = [((NSNumber*)value) objCType];
            if (strcmp(pObjCType, @encode(int))  == 0) {
                NSLog(@"字典中key=%@的值是int类型,值为%d",keym,[value intValue]);
            }
            if (strcmp(pObjCType, @encode(float)) == 0) {
                NSLog(@"字典中key=%@的值是float类型,值为%f",keym,[value floatValue]);
            }
            if (strcmp(pObjCType, @encode(double))  == 0) {
                NSLog(@"字典中key=%@的值是double类型,值为%f",keym,[value doubleValue]);
            }
            if (strcmp(pObjCType, @encode(BOOL)) == 0) {
                NSLog(@"字典中key=%@的值是bool类型,值为%i",keym,[value boolValue]);
            }
        }
    }
}

@end
