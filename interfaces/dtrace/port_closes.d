dtrace:::BEGIN
{
    printf("Port close handle distribution\n\n");
}

kdbplus$target:::port-close
{ 
     @handle_distribution[pid] = quantize(arg0);
}

dtrace:::END
{
     printa(@handle_distribution);
}

