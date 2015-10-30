/*
 *      To fix the 'dtrace: 5860 dynamic variable drops with non-empty dirty list'.
 *
 *      See dtrace_tips.pdf and the internet
 */
#pragma D option dynvarsize=64m

pid$target:$1::entry
{
        self->entry_time = timestamp;
}

pid$target:$1::return
/self->entry_time/
{
        this->delta_time = timestamp - self->entry_time;

        /* @histogram[probefunc] = quantize(this->delta_time); */
        @totals[probefunc] = sum(this->delta_time);

        /* printf ("\tCompleted in %d ns", this->delta_time); */
        self->entry_time = 0;
        this->delta_time = 0;
}

END
{
	/*	NOTE: the Mathematica analysis tools corrently look for the specific string "DTraceFcall"	*/
	printf("\n\n\n--------------------------- DTraceFcall-%s Output ---------------------------\n", $1);
}