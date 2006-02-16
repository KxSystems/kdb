n:100000
\l sp.q
\t do[n;s[`s1;`city]]
\t do[n;select city from s where s=`s1]

\t do[n;s[`s1;`city]:`a]
\t do[n;update city:`a from`s where s=`s1]

y:value first sp
\t do[n;sp,:y]
\t do[n;`sp insert y]

\

t:([]time:();sym:();price:();size:())
\t do[n;`t insert(09:30:01.234;`xx;59.25;1900)]
