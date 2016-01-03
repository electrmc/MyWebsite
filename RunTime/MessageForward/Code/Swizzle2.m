Method orig = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"addObject:"));
Method override = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject_override:));
method_exchangeImplementations(orig, override);