q is a general purpose rdbms(kdb+) and programming language.

OLTP from 1 to 10 million records per second per cpu.
OLAP from 1 to 100 million records per second per cpu.

c	clients (c java .net)
d	documentation
e	examples

sample database scripts
sp.q	supplier/part
trade.q	trade

financial apps built with q
tick	tickerplant (1 million transactions per second)
taq	loader for 100+ billion us equity trades and quotes

o/s specific binaries
l64	64bit linux
s64	64bit solaris/sparc
v64	64bit solaris/amd
w64	64bit windows
m64	64bit macintosh

l32	32bit linux
s32	32bit solaris
w32	32bit windows

You are welcome to download and use this code according to the terms of the licence. 

Kx Systems recommends you do not link your application to this repository, 
which would expose your application to various risks:

- This is not a high-availability hosting service
- Updates to the repo may break your application 
- Code refactoring might return 404s to your application

Instead, download code and subject it to the version control and regression testing 
you use for your application.
