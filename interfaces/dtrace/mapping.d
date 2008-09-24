kdbplus$target:::map-file
{
	printf("File %s mapped at %p", copyinstr(arg0), arg1);
}

kdbplus$target:::unmap-file
{
        printf("Region at %p unmapped", arg0);
}

