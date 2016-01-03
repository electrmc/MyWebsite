+ (void)load
{
    Method method = class_getClassMethod([NSMutableArray class], @selector(allocWithZone:));
    IMP originalImp = method_getImplementation(method);
    
    IMP imp = imp_implementationWithBlock(^id(id me, NSZone * zone) {
        id obj = ((id (*)(id,SEL,NSZone *))originalImp)(me, @selector(allocWithZone:), zone);
        return [SwizzleProxy proxyWithObject:obj];
    });
    
    method_setImplementation(method, imp);
}

+ (id)proxyWithObject:(id)obj
{
    SwizzleProxy *proxy = [self alloc];
    proxy->_obj = obj;
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:_obj];
    [invocation invoke];
    const char *selname = sel_getName([invocation selector]);
    if ([@(selname) hasPrefix:@"init"] && [[invocation methodSignature] methodReturnType][0] == '@') {
        const void * ret;
        [invocation getReturnValue:&ret];
        ret = CFBridgingRetain([SwizzleProxy proxyWithObject:CFBridgingRelease(ret)]);
        [invocation setReturnValue:&ret];
    }
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_obj methodSignatureForSelector:sel];
}
