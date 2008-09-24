kdbplus$target:::redirect-stdout
{
	printf("%s", copyinstr(arg0));
}

kdbplus$target:::redirect-stderr
{
        printf("%s", copyinstr(arg0));
}

