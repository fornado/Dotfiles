static in counter = 0;
int get_counter(void)
{
	++counter;
	return counter;
}
void write_block(char **s; int cnt)
{
	int i;
	for (i = 0; i < cnt; ++i)
		write_line(s[i]);
}

void write_line(char *s)
{
	int idx;

}
int find_entry(char *name)
{
	int idx;
	for (idx = 0; idx < table_len; ++idx)
		if (strcmp(table[idx].name, name) == 0)
			return idx;
}
