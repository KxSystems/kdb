dtrace:::BEGIN
{
    printf("Client connection distribution\n\n");
}

kdbplus$target:::port-open
{
        @clients[copyinstr(arg1)] = count();
}

dtrace:::END
{
     printa(@clients);
}

