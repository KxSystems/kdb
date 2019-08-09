dbmaint.q
=========

The script [dbmaint.q](dbmaint.q) contains utility functions for maintenance of partitioned database tables in kdb+. It should not be used for splayed tables which are not partitioned, tables stored as single files or in memory tables.

You should always check the effect of using these functions on a test database first. To test you can create a sample taq database with <https://github.com/KxSystems/kdb/blob/master/tq.q>, but note that you should test on a sample of your own database before attempting to use any of these functions in production.

A few of the functions either do not support nested columns or can only be used for certain nested types, these are noted below.

If you are making changes to current database you need to reload (`\l .`) to make modifications visible.

If the database you’ve been modifying is a tick database, remember to adjust the schema (tick/???.q) to reflect your changes to the data.

In the following: 

`dbdir`
: a file symbol for the database folder

`table`
: the symbol naming a table

`col`
: the symbol name of a column


## addcol

`addcol[dbdir;table;col;defaultvalue]`

Adds new column `col` to `table` with value `defaultvalue` in each row.

e.g.
```q
addcol[`:/data/taq;`trade;`noo;0h]
```


## castcol

`castcol[dbdir;table;col;newtype]`

Cast the values in the column to the `newtype` and save. `newtype` can be specified in short or long form, e.g. `"f"` or `` `float `` for a cast to float. This can be used to cast nested types as well, but to cast a nested character column to symbol use `fncol` instead.

e.g.
```q
castcol[`:/data/taq;`trade;`size;`short]
```


## clearattrcol

`clearattrcol[dbdir;table;col]`

Remove any attributes from column `col`.

e.g.
```q
clearattr[`:/data/taq;`trade;`sym]
```


## copycol

`copycol[dbdir;table;oldcol;newcol]`

Copy the values from `oldcol` into a new column named `newcol`, undefined in the table. This does not support nested columns.

e.g.
```q
copycol[`:/data/taq;`trade;`size;`size2]
```


## deletecol

`deletecol[dbdir;table;col]`

Delete column `col` from `table`. 

This doesn’t delete the col# files for nested columns (the files containing the actual values) – you will need to delete these manually.

e.g.
```q
deletecol[`:/data/taq/;`trade;`size2]
```


## findcol

`findcol[dbdir;table;col]`

Print a list of the partition directories where `col` exists and its type in each, and a `*NOT*FOUND*` message for partition directories where `col` is missing.

e.g.
```q
findcol[`:/data/taq;`trade;`iz]
```


## fixtable

`fixtable[dbdir;table;goodpartition]`

Adds missing columns to to all partitions of a table, given the location of a good partition. This _doesn’t_ delete extra columns – do that manually. Also this does not add tables to partitions in which they are missing, use [`.Q.chk`](https://code.kx.com/v2/ref/dotq/#qchk-fill-hdb) for that.

e.g.
```q
fixtable[`:/data/taq;`trade;`:/data/taq/2005.02.19/trade]
```


## fncol

`fncol[dbdir;table;col;fn]`

Apply a function to the list of values in `col` and save the results as its values.

e.g.
```q
fncol[`:/data/taq;`trade;`price;2*]
```
Casting from a nested character column to a symbol column, we need to enumerate the symbol column after we cast it and before we save it.
```q
fncol[`:/data/taq;`trade;`nestedcharcol;{(` sv x,`sym)?`$y}`:/data/taq]
```


## listcols

`listcols[dbdir;table]`

List the columns of `table` (relies on the first partition).

e.g.
```q
listcols[`:/data/taq;`trade]
```


## renamecol

`renamecol[dbdir;table;oldname;newname]`

Rename column `oldname` to `newname`, which must be undefined in the table. This does not support nested columns.

e.g.
```q
renamecol[`:/data/taq;`trade;`woz;`iz]
```


## reordercols

`reordercols[dbdir;table;neworder]`

Reorder the columns of `table`. `neworder` is a full list of the column names as they appear in the updated table.

e.g.
```q
reordercols[`:/data/taq;`trade;reverse cols trade]
```


## setattrcol

`setattrcol[dbdir;table;col;newattr]`

Apply an attribute to `col`. The data in the column must be valid for that attribute. No sorting occurs.

e.g.
```q
setattrcol[`:/data/taq;`trade;`sym;`g]
```


## addtable

`addtable[dbdir;tablename;table]`

Add a table called `tablename` with an empty table with the same schema as `table` created in each partition of the new table.

e.g.
```q
addtable[`:/data/taq;`trade1;.Q.en[`:.]([]time:0#0Nt;sym:0#`;price:0#0n;size:0#0)]
```


## rentable

`rentable[dbdir;old;new]`

Rename table `old` to `new`.

e.g.
```q
rentable[`:/data/taq;`trade;`transactions]
```


See also
--------

-   [`.Q.chk`](https://code.kx.com/v2/ref/dotq/#qchk-fill-hdb)
-   [`.Q.en`](https://code.kx.com/v2/ref/dotq/#qen-enumerate-varchar-cols)

