select v, u, sum(q)as sum_q, sum(x)as sum_x, sum(x*(1-xd))as rev, sum(x*(1-xd)*(1+xt))as tax, avg(q)as avg_q, avg(xd)as avg_xd, count(*)as count_o
 from l where ds<=1998.12.01-90 group by v, u order by v, u

select s.x, s.name, n.name, p.p, p.cm, s.ca, s.cp, s.cz from p, s, ps, n, r
 where p.p = ps.p and s.s = ps.s and p.z = 15 and p.t like '*BRASS' and s.n = n.n and n.r = r.r and r.name = 'EUROPE' and ps.x =
  (select min(ps.x) from ps, s, n, r where p.p = ps.p and s.s = ps.s and s.n = n.n and n.r = r.r and r.name = 'EUROPE')
 order by s.x desc rows 100

select l.o, o.d, o.f, sum(l.x*(1-l.xd))as rev from c, o, l
 where c.m = 'BUILDING' and c.c = o.c and l.o = o.o and o.d < 1995.03.15 and l.ds > 1995.03.15
 group by l.o, o.d, o.f order by rev desc rows 10

select j, count(*)as count_o from o where d>=1993.07.01 and d<1993.07.01+3m and
  exists(select * from l where o=o.o and dc<dr)
 group by j order by j

select n.name, sum(l.x*(1-l.xd))as rev from c,o,l,s,n,r
 where c.c=o.c and o.o=l.o and l.s=s.s and c.n=s.n and s.n=n.n and n.r=r.r
  and r.name='ASIA' and o.d>=1994.01.01 and o.d<1994.01.01+12m
 group by n.name order by rev desc

select sum(x*xd)as sum_x from l where ds>=1994.01.01 and ds<1994.01.01+12m and xd between .05 and .07 and q<24

select sna,cna,year,sum(rev)as sum_rev from(
 select n1.name as sna, n2.name as cna, extract(year from l.ds) as year, l.x*(1-l.xd) as rev
 from s,l,o,c,n n1,n n2
 where s.s=l.s and o.o=l.o and c.c=o.c and s.n=n1.n and c.n=n2.n and
  ((n1.name='FRANCE' and n2.name='GERMANY')or(n1.name='GERMANY' and n2.name='FRANCE'))
  and l.ds between 1995.01.01 and 1996.12.31)t
 group by sna,cna,year
 order by sna,cna,year

select year,sum(case when name='BRAZIL' then rev else 0 end)/sum(rev)as share from(
  select extract(year from o.d)as year,l.x*(1-l.xd) as rev,n2.name
  from p,s,l,o,c,n n1,n n2,r
  where p.p=l.p and s.s=l.s and l.o=o.o and o.c=c.c and c.n=n1.n and n1.r=r.r and r.name='AMERICA'
   and s.n=n2.n and o.d between 1995.01.01 and 1996.12.31 and p.t='ECONOMY ANODIZED STEEL')t
 group by year order by year

select name,year,sum(amount)as sum_amount from(
  select n.name,extract(year from o.d)as year,l.x*(1-l.xd)-ps.x*l.q as amount from p,s,l,ps,o,n
  where s.s=l.s and ps.s=l.s and ps.p=l.p and p.p=l.p and o.o=l.o and s.n=n.n 
   and p.name like '*green*')t
 group by name,year order by name,year

select c.c,c.name,c.x,n.name,c.ca,c.cp,c.cz,sum(l.x*(1-l.xd))as rev
 from c,o,l,n
 where c.c=o.c and l.o=o.o and o.d>=1993.10.01 and o.d<1993.10.01+3m and l.v='R' and c.n=n.n
 group by c.c,c.name,c.x,n.name,c.ca,c.cp,c.cz
 order by rev desc rows 20

select ps.p, sum(ps.x*ps.q) as value from ps,s,n 
 where ps.s=s.s and s.n=n.n and n.name='GERMANY'
 group by ps.p 
 having sum(ps.x*ps.q)>(
  select sum(ps.x*ps.q)/(select count(*) from s)
  from ps,s,n where s.s=ps.s and s.n=n.n and n.name='GERMANY')
 order by value desc

select l.h,sum(case when o.j='1-URGENT' or o.j='2-HIGH' then 1 else 0 end)as high,
               sum(case when o.j<>'1-URGENT' and o.j<>'2-HIGH' then 1 else 0 end)as low
 from o,l where o.o=l.o and l.h in('MAIL','SHIP') and l.dc<l.dr and l.ds<l.dc 
  and l.dr>=1994.01.01 and l.dr<1994.01.01+12m group by l.h order by l.h

select year,sum(rev)as sum_rev from(select extract(year from o.d)as year,l.x*(1-l.xd) as rev from l,o
  where o.o=l.o and o.k='Clerk#000000088' and l.v='R')t
 group by year order by year

select 100.00*sum(case when p.t like'PROMO*'then l.x*(1-l.xd) else 0 end)/sum(l.x*(1-l.xd))
 from l,p where l.p=p.p and l.ds>=1995.09.01 and l.ds<1995.09.01+1m

select t.s,s.name,s.ca,s.cp,t.rev from s,(
  select s,sum(x*(1-xd))as rev from l where ds>=1996.01.01 and ds<1996.01.01+3m group by s)t
 where s.s=t.s and t.rev=(select max(rev) from t)order by t.s

select p.b,p.t,p.z,count(distinct ps.s) as count_s
 from ps,p where p.p=ps.p and p.b<>'Brand#45' and p.t not like'MEDIUM POLISHED*'
  and p.z in(49,14,23,45,19,3,36,9) and ps.s not in(
   select s from s where cz like'*Better Business Bureau*Complaints*')
 group by p.b,p.t,p.z
 order by count_s desc,p.b,p.t,p.z

select sum(l.x)/7 from l,p where p.p=l.p and p.b='Brand#23'and p.e='MED BOX'
 and l.q<(select 0.2*avg(q)from l where p=p.p)