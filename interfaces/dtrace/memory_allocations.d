dtrace:::BEGIN
{
    printf("Memory allocation size distribution\n\n");
}

kdbplus$target:::memory-allocation
{ 
     @memory_distribution[pid] = quantize(arg0);
}

kdbplus$target:::memory-deallocation
{
	printf("Deallocation of %p from bucket %d", arg0, arg1);
}

kdbplus$target:::free-and-exit
{
	printf("We're done: exit %d", arg0);
}

kdbplus$target:::reference-inc
{
        printf("Reference increment: %p %d", arg0, arg1);
}

kdbplus$target:::reference-dec
{
        printf("Reference decrement: %p %d", arg0, arg1);
}

kdbplus$target:::reference-free
{
        printf("Recycling object: %p", arg0);
}

dtrace:::END
{
     printa(@memory_distribution);
}

