s:([s:`s1`s2`s3`s4`s5]
 name:`smith`jones`blake`clark`adams;
 status:20 10 30 20 30;
 city:`london`paris`paris`london`athens)

p:([p:`p1`p2`p3`p4`p5`p6]
 name:`nut`bolt`screw`screw`cam`cog;
 color:`red`green`blue`red`blue`red;
 weight:12 17 17 14 12 19;
 city:`london`paris`rome`london`paris`london)

sp:([]
 s:`s$`s1`s1`s1`s1`s4`s1`s2`s2`s3`s4`s4`s4;	/ fkey
 p:`p$`p1`p2`p3`p4`p5`p6`p1`p2`p2`p2`p4`p5;	/ fkey
 qty:300 200 400 200 100 100 300 400 200 200 300 400)

view::select from sp where qty>200

\
select distinct p,s.city from sp
/s)select distinct sp.p,s.city from sp,s where sp.s=s.s

select sum qty by p.color from sp
/s)select p.color,sum(sp.qty) from sp,p where sp.p=p.p group by p.color order by color

select from sp where s.city=p.city
/s)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s and sp.p=p.p and p.city=s.city
