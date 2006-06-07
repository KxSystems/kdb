[we can use odbc.k to load other databases into kdb+.]

this file is about the kdb+ odbc driver. odbc is deprecated. 
if you can use http://kx.com/q/c/readme.txt e.g.
from java use c.java
from .net use c.cs

we might still use odbc to get data into old excel/vb's.
1. http://kx.com/q/c/odbc/odbc.exe //install qodbc.dll
2. use connect STRING "DRIVER=kdb+;DBQ=host:port;UID=usr;PWD=pwd;"
e.g. >q sp.q -p 5001

the default language for odbc is sql. to use q we execute("q)..");

from excel:
=SQL.REQUEST("DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;",,,"q)sp")

from vb:
r=new adodb.recordset
r.Open "q)sp","DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;"

or
connQ.Open"Provider=MSDASQL.1;DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;"



to use msqry32 we need SQL

we must install http://kx.com/q/e/s.k in ~/q
