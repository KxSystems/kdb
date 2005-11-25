/>q tick/bb.q [host]:port[:usr:pwd]   (>q tick.k tba)
h:neg hopen`$":",first .z.x,enlist":5010"

/ callbacks
mon:{ids[x]:y}
stt:{0N!`state,x}
upd:{h(".u.upd";x;@[y;0;sym ids?])}

/ subscribe
sub:`bb 2:(`sub;1)
sub each sym:`$read0`:tick/bb.txt;ids:(count sym)#0