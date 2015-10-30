/*
 *	To fix the 'dtrace: 5860 dynamic variable drops with non-empty dirty list'.
 *
 *	See dtrace_tips.pdf and the internet
 */
#pragma D option dynvarsize=64m

pid$target::malloc:entry
{
        @ = quantize(arg0);

        /*printf ("%s malloc()ing %d bytes...", execname, arg0);*/

        self->entry_time = timestamp;
}

pid$target::malloc:return
/self->entry_time/
{
        this->delta_time = timestamp - self->entry_time;

        /* printf ("\tmalloc completed in %d ns", this->delta_time); */
        self->entry_time = 0;
        this->delta_time = 0;
}
