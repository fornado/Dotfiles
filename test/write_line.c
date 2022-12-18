#include abc.h
#ifdef USE_POPEN ~
	fd = popen("ls", "r") ~
#else ~
	fd = fopen("tmp", "w") ~
#endif ~
void write_line(char *s) 
{
	while(*s != 0)
		write_char(*s++);
	if (aa) 
	{
		return 1
	}
	return 2
}
int func1(void)
{
	if (flag)
		return flag
	return 1;
}
#if defined(HAS_INC_H) ~
	a = a + inc(); ~
# ifdef USE_THEME ~
	a += 3; ~
# endif ~
	set_width(a); ~

	/*
	 * a comment about
	 * wonderful life.
	 * /
if (a == b && (c == d || (e > f)) && x > y) ~
