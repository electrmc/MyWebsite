@protocol ViewPropertiesProtocol &#60NSObject&#62
@optional
- (NSString*)viewStockCode;
- (NSString*)viewStockName;
@end

@interface LogError:NSObject
- (id)logError;
@end
@implementation LogError
- (id)logError{
    NSLog(@"ViewPropertiesProxy error");
    return nil;
}
@end

// 将协议的实现对象放到mapTable中，用到时，直接用该单例执行协议方法
@interface ViewPropertiesProxy : NSProxy &#60ViewPropertiesProtocol&#62
+ (instancetype)shareViewPropertiesProxy;
- (void)registerSelector:(SEL)protocolSel handler:(id&#60ViewPropertiesProtocol&#62)handler;
@end

@interface ViewPropertiesProxy ()
@property (strong, nonatomic)LogError *logError;
@property (strong, nonatomic)NSMapTable *mapTable;
@end

@implementation ViewPropertiesProxy

+ (instancetype)shareViewPropertiesProxy{
    static ViewPropertiesProxy *instance;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [ViewPropertiesProxy alloc];
        // key:copy value:weak
        instance.mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                                  valueOptions:NSMapTableWeakMemory];
        instance.logError = [[LogError alloc]init];
    });
    return instance;
}

- (void)registerSelector:(SEL)protocolSel handler:(id)handler {
    if (!handler) {
        return;
    }
    [_mapTable setObject:handler forKey:NSStringFromSelector(protocolSel)];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel{
    NSString *selector = NSStringFromSelector(sel);
    id handler = [_mapTable objectForKey:selector];
    
    if (handler != nil && [handler respondsToSelector:sel]) {
        return [handler methodSignatureForSelector:sel];
    } else {
        return [LogError instanceMethodSignatureForSelector:@selector(logError)];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *selector = NSStringFromSelector(invocation.selector);
    id handler = [_mapTable objectForKey:selector];
    
    if (handler != nil && [handler respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:handler];
    } else {
        invocation.selector = @selector(logError);
        [invocation invokeWithTarget:_logError];
    }
}
@end
