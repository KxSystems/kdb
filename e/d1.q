\l daily
/t:select from t
d:first D:2000.01.01+til 10
m:first M:`mas$10+til 10
n:1000
\t do[n;select i from t where date=d]
\t do[n;select i from t where mas=m]
\t do[n;select i from t where date within(d;d+31)]
\t do[n;select i from t where date.month=2000.01m]
\t do[n;select i from t where mas.sym=`mjo]
\t do[n;select i from t where date in D]
\t do[n;select i from t where mas in M]




\

\t .[`:t;();,;update 1+date from select from t where date=last date]