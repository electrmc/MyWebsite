//
//  main.m
//  Property
//
//  Created by MiaoChao on 15/12/13.
//  Copyright © 2015年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    NSObject *_myHouse; // 能被子类继承是和使用的保护变量但是不能被外界访问
    NSString *_sex; // 由于@synthesize的原因，将会存在sex,_sex两个变量
}

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *sex;

// 实现了readonly的getter方法或readwrite的setter&getter方法，编译器将不会自动合成变量
// 如果在setter和getter方法中没有对变量设值和返回值时，那么将不会存在该变量。这种情况下需要手动调用@synthesize
@property (nonatomic,retain) NSString *weight;
@property (nonatomic,retain,readonly) NSString *height;
@property (nonatomic,assign) NSInteger age;

@property NSObject *objc;//objc是不能实现setter和getter方法，因为我们不能保证线程安全

- (void)nextYear;

@end

@implementation Person{
    NSObject *_myMoney; // 能被子类继承是和使用的保护变量但是不能被外界访问
}

@synthesize firstName = _firstName; // 这一句将有编译器做，没事就别写
@synthesize lastName = ivar_lastName;
@synthesize sex; // 变量名字将是sex，而不是_sex，相当于@synthesize sex = sex;
@synthesize height = _privateHeight;

- (instancetype)init{
    self = [super init];
    if (self) {
        _age = 1;
    }
    return self;
}

// 如果只实现了weight的setter或getter方法（不是正常的实现），那么该变量还是存在的
// 但是此时无论另一个的实现是否正常，该变量将不会存在
- (void)setWeight:(NSString *)weight{
    NSLog(@"编译器将不会自动生成_weight变量");
}

- (NSString*)weight{
    NSString *str =@"很可惜，这里不存在_weight变量";
    return str;
}

- (void)setAge:(NSInteger)age{
    NSLog(@"年龄怎么能手动设置呢?!");
}

- (void)nextYear{
    _age +=1;
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",_age]);
}

- (NSString*)height{
    NSString *str = @"身高改变不了，而且是保密的，想要知道身高请访问_privateHeight";
    return str;
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *aPerson = [[Person alloc]init];
        aPerson.age = 1000;
        [aPerson nextYear];
        NSLog(@"%@",aPerson.weight);
        NSLog(@"%@",aPerson.height);
        
    }
    return 0;
}
