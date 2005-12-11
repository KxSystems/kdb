/ suppliers-and-parts, cf. A Guide to the SQL Standard

create table s(
 s varchar(5) primary key,
 name varchar(20),
 status int,
 city varchar(15))

create table p(
 p varchar(6) primary key,
 name varchar(20),
 color varchar(6),
 weight int,
 city varchar(15))

create table sp(
 s varchar(5) references s,
 p varchar(6) references p,
 qty int)

insert into s values('s1','smith',20,'london');
insert into s values('s2','jones',10,'paris');
insert into s values('s3','blake',30,'paris');
insert into s values('s4','clark',20,'london');
insert into s values('s5','adams',30,'athens');
insert into p values('p1','nut','red',12,'london');
insert into p values('p2','bolt','green',17,'paris');
insert into p values('p3','screw','blue',17,'rome');
insert into p values('p4','screw','red',14,'london');
insert into p values('p5','cam','blue',12,'paris');
insert into p values('p6','cog','red',19,'london');
insert into sp values('s1','p1',300);
insert into sp values('s1','p2',200);
insert into sp values('s1','p3',400);
insert into sp values('s1','p4',200);
insert into sp values('s4','p5',100);
insert into sp values('s1','p6',100);
insert into sp values('s2','p1',300);
insert into sp values('s2','p2',400);
insert into sp values('s3','p2',200);
insert into sp values('s4','p2',200);
insert into sp values('s4','p4',300);
insert into sp values('s1','p5',400);


select distinct sp.p,s.city from sp,s where sp.s=s.s
select p.color,sum(sp.qty) from sp,p where sp.p=p.p group by p.color order by color
select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s and sp.p=p.p and p.city=s.city
