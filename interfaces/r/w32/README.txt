This is a 32-bit Windows version of the R interface suitable for use
with R 2.7.0 or higher. I suggest you create c:\r and put the files in 
there. I also recommend not using the Microsoft compilers but instead
using gcc to compile this. The included R.dll is from R 2.7.2 but you 
should be able to substitute your own if preferred.

Personally, I compiled kdbplus.c using gcc-4.2.1 like this:

C:\r>gcc -c kdbplus.c -I. -I "\Program Files\R\R-2.7.2\include"
C:\r>gcc -Wl,--export-all-symbols -shared -o kdbplus.dll c.o kdbplus.o R.dll -lws2_32

Then in R, assuming a q instance listening on port 5000 with a table t defined, I can do this:

> source("C:\\r\\kdbplus.R")
> c <- open_connection()
> t <- execute(c, "select from t")
> close_connection(c)

Note that open_connection actually takes 3 arguments with defaults of "localhost" for the
host to connect to, 5000 for the port and none for the user/password credentials.

The file kdbplus.R can be changed to suit your installation and preferred function names
for open_connection, execute and close_connection.

Modify this line with the path to kdbplus.dll:
dyn.load(file.path("c:\\r\\","kdbplus.dll"))

