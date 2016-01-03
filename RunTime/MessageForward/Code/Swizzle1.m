Class class = [self class];
instanceMethodSwizzle(class, @selector(methodInOrigin), @selector(hook_methodInOrigin));
instanceMethodSwizzle(class, @selector(methodInCategory), @selector(hook_methodInCategory));