\cd daily
n:1000;d:2000.01.01
mas:([id:10+til n]sym:(neg n)?`3) / master table
t:([]date:d+til n)cross([]mas:`mas!til n)
t:update`s#date,`g#mas,price:2.3,size:4 from t

\t do[10000;select i from t where date=first date]
\t do[10000;select i from t where mas=first mas]
save`mas;rsave`t
\

tick data is partitioned by date and sorted by symbol.
daily data could be sorted by date and grouped by master.
the master column should be a foreign key into a master table.
[on 32bit O/S's the data could be partitioned by year if 
 more than 33 million rows. e.g. 13000 securities over 10 years]
the number of columns doesn't matter. there can be hundreds.
adjprice (splits and dividends) can be stored (rewrite data on update)
or calculated on the fly. (e.g. http://kx.com/q/taq/adj.q)

queries:  ... where mas=?, ... (for cross-section: mas in ?)
are .1 to 10 milliseconds per sym*field depending on mem/disk.
 
daily update, group and adjustment recalc is about 1GB/minute.


