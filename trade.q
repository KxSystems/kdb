trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())

`trade insert(09:30:00.000;`a;10.75;100)

select sum size by sym from trade
