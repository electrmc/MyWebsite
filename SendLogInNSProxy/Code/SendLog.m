@interface SendLog : NSObject
@property (strong, nonatomic) NSMutableArray *logSequence;// 决定从字典中取值的顺序
- (NSString*)packageLog;
- (void)send;
@end

@implementation SendLog{
    NSMutableDictionary *_innerDictionary;// 属性值存在这里
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _innerDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

// 将setter,getter方法转为字典的设值和取值
#pragma mark - Message Forwading
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    // getter -> objectForKey:
    // setter -> setObject:forKey:
    SEL changedSelector = aSelector;
    if ([self propertyNameScanFromGetterSelector:aSelector]) {
        changedSelector = @selector(objectForKey:);
    }else if ([self propertyNameScanFromSetterSelector:aSelector]) {
        changedSelector = @selector(setObject:forKey:);
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
    NSMethodSignature *sign = [[_innerDictionary class] instanceMethodSignatureForSelector:changedSelector];
    return sign;
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    NSString *propertyName = nil;
    
    // Try getter
    propertyName = [self propertyNameScanFromGetterSelector:invocation.selector];
    if (propertyName) {
        invocation.selector = @selector(objectForKey:);
        [invocation setArgument:&propertyName atIndex:2]; // self, _cmd, key
        [invocation invokeWithTarget:_innerDictionary];
        return;
    }
    
    // Try setter
    propertyName = [self propertyNameScanFromSetterSelector:invocation.selector];
    if (propertyName) {
        // setObject:forKey:
        invocation.selector = @selector(setObject:forKey:);
        [invocation setArgument:&propertyName atIndex:3]; // self, _cmd, obj, key
        
        // removeObjectForKey:
        void *argument = NULL;
        [invocation getArgument:&argument atIndex:2];
        if (!argument) {
            NSMethodSignature *siganture = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
            invocation = [NSInvocation invocationWithMethodSignature:siganture];
            invocation.selector = @selector(removeObjectForKey:);
            [invocation setArgument:&propertyName atIndex:2];
        }
        [invocation invokeWithTarget:_innerDictionary];
        return;
    }
    [super forwardInvocation:invocation];
}

- (NSString *)propertyNameScanFromGetterSelector:(SEL)selector{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    if (parameterCount == 0) {
        return selectorName;
    }
    return nil;
}

- (NSString *)propertyNameScanFromSetterSelector:(SEL)selector{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    
    if ([selectorName hasPrefix:@"set"] && parameterCount == 1) {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        NSString *property = [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)];
        NSString *lowercaseStr = [property substringWithRange:NSMakeRange(0, 1)].lowercaseString;
        property = [property stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:lowercaseStr];
        return property;
    }
    return nil;
}

// 拼接字符串
- (NSString*)packageLog{
    NSMutableString *string = [NSMutableString string];
    NSString *key,*value;
    for (int i=0; i<self.logSequence.count; i++) {
        key = self.logSequence[i];
        value = _innerDictionary[key];
        if ([value isKindOfClass:[NSString class]]) {
            [string appendString:value];
        }
        [string appendString:@"|"];
    }
    return string;
}

- (void)send{
    NSString *log = [self packageLog];
    // send log
}
@end
