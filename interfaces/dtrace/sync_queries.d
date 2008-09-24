kdbplus$target:::port-open
{
        printf("%d %s %s",arg0, copyinstr(arg1), copyinstr(arg2));
}

kdbplus$target:::port-close
{ 
	printf("%d", arg0);
}

kdbplus$target:::port-sync-query
{
	query_timings[arg0] = timestamp;
	printf("%d %s", arg0, copyinstr(arg1, arg2));
}

kdbplus$target:::port-async-query
{
	query_timings[arg0] = timestamp;
        printf("%d %s", arg0, copyinstr(arg1, arg2));
}

kdbplus$target:::port-query-end
{
	query_time = timestamp - query_timings[arg0];
        @client_time[arg0] = sum(query_time);
	query_timings[arg0] = 0;
	printf("Client on handle %d executed for %d ns", arg0, query_time);
}

dtrace:::END
{
     printf("\n\t\tHandle\t Total query time in nanoseconds");
     printa(@client_time);
}
