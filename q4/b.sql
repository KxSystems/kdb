drop table if exists S;create table S(sym char(4));
insert into S select sym from trade group by sym order by count(*) desc fetch first 100 rows only;

\timing on
explain(analyze)select sym,last(bid) from quote natural join S group by sym;
explain(analyze)select sym,ex,max(price) from trade natural join S group by sym,ex;
explain(analyze)select sym,extract(hour from time),avg(size) from trade natural join S group by sym,extract(hour from time);

\q

--ETL
drop table if exists trade;create table trade(sym char(4),time time,ex char(1),cond char(1),size int,price float);
drop table if exists quote;create table quote(sym char(4),time time,ex char(1),bid float,bsize int,ask float,asize int,mode char(1));

\timing on
copy trade from 't.csv' delimiter ',' csv;create index ts on trade(sym);
copy quote from 'q.csv' delimiter ',' csv;create index qs on quote(sym);
analyze;

CREATE OR REPLACE FUNCTION public.first_agg(anyelement,anyelement)RETURNS anyelement LANGUAGE sql IMMUTABLE STRICT AS $$ SELECT $1; $$;
CREATE AGGREGATE public.first (sfunc = public.first_agg,basetype = anyelement,stype = anyelement);
CREATE OR REPLACE FUNCTION public.last_agg (anyelement,anyelement)RETURNS anyelement LANGUAGE sql IMMUTABLE STRICT AS $$ SELECT $2; $$;
CREATE AGGREGATE public.last  (sfunc = public.last_agg ,basetype = anyelement,stype = anyelement);
\q

/etc/postgresql/9.4/main/postgres.conf(work_mem 2GB shared_buffers 2GB)
sudo /etc/init.d/postgresql restart;psql taq -f q.sql

explain(analyze) select sym,last(bid order by time) from quote where sym in(select sym from S)group by sym;
explain(analyze) select distinct on(sym)sym,time,last_value(bid) over(partition by sym order by time)from quote where sym in(select sym from S);
explain(analyze) select sym,bid from(select sym,bid,row_number()over(partition by sym order by time desc)as row from quote where sym in(select sym from S))q where row=1;

