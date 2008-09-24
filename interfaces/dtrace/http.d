kdbplus$target:::http-get
{
	printf("%d %s", arg0, copyinstr(arg1, arg2));
}

kdbplus$target:::http-post
{
        printf("%d %s", arg0, copyinstr(arg1, arg2));
}

kdbplus$target:::http-auth
{
        printf("%s", copyinstr(arg0));
}

