id objc_msgSend(id self, SEL _cmd, ...)
{
    if(!self->class->initialized)
        [self->class initialize];
    ...send the message...
}