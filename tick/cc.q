/ cancel correct
f:{(select`s#time,sym,price,size from trade)?x}
corr:{trade[f -2_x;`price`size]:x`price1`size1}
canc:{trade[f x;`price`size]:(0f;0);}


/ example from taq
cc:update price:price%1e8 from value`:tick/cc
cc[i+1;`time]:cc[i:2*til floor .5*count cc;`time]
r:select price1:price,size1:size from cc where corr=1h /new
r:(select time,sym,price,size from cc where corr=12h),'r /old
n:select time,sym,price,size from cc where corr in 7 8h /cancel
trade:select from cc where corr in 7 8 12h /original

canc each n;
corr each r;

/propagate changes, e.g. vwap

canc:{vwap-:select size wsum price,sum size by sym from x}
corr:{vwap-:select(size wsum price)-size1 wsum price1,(sum size)-sum size1 by sym from x}

canc n;
corr r;


\
end-of-day. don't save 0 sizes.

in 10000 trades there are 7 cancels and 3 corrections.
lookup by seq number or [time,sym,price,size].
processing a cancel/correct is about 10 microseconds.
doesn't matter how big the table is.

the key is to have exchange sequence number or 
exchangetime(probably seconds) in ascending order.