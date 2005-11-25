/ kdb+taq(taq.q) is much faster than kdb/taq

load'taq'
D:2 take date
S:('A','AA')
s:first S

n:100
\\t .d.r"select count$by date from trade where date in D"
/1000 to 1

\\t .d.r"select count distinct sym by date from trade where date in D"
/1000 to 1

\\t 2;.d.r"select mid:.5*(last bid)+last ask by date,time.hhmm from quote where date in D,sym=s"
/150 to 1

\\t do[n;.d.r"select count$ from trade where date in D"]
/3400 to 1

\\t do[n;.d.r"select last price, sumf size by sym from trade where date in D,sym in S"]
/700 to 300

\\t do[n;.d.r"select last price, sumf size by date from trade where date in D,sym=s"]
/600 to 170

\\t do[n;.d.r"select last price by date,sym from trade where date in D,sym in S"]
/700 to 200

\\t .d.r"select sumf size from trade where date in D"
/400 to 100

\\t .d.r"select sumf size by sym from trade where date in D"
/600 to 400

\\t .d.r"select sumf size by date,sym from trade where date in D"
/1500 to 400

\

	kdb/taq	kdb+taq

code	3200	1600
load	500MB	1000MB/minute
over	1.5	.5millisecond
