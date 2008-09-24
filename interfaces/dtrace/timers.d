kdbplus$target:::timer-fire
{
        printf("%ld", arg0);
}

kdbplus$target:::restore-dotz
{
        printf("%s", copyinstr(arg0));
}

