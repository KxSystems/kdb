if possible don't use odbc. (slow)


vb r=new adodb.recordset;r.Open "q)t", "DRIVER=kdb+;DBQ=localhost:5001"
excel SQL.REQUEST("DRIVER=kdb+;DBQ=localhost:5001;",,,"q)t")
