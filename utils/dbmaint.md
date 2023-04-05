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

**Examples:**

The examples in this document use a `trade` dir generated with the following sample data.

```q
n:100; trade:([]time:.z.t;sym:n?`3;price:n?10000f;size:n?10000);
.Q.dpft[`:data/taq;2023.01.01;`sym;`trade];
```

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```

_meta_

```txt
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
size | j  
```

## addcol

`addcol[dbdir;table;col;defaultvalue]`

Adds new column `col` to `table` with value `defaultvalue` in each row.

**Example:**

```q
addcol[`:data/taq;`trade;`noo;0h]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── noo
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```

_meta_
```txt
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
size | j    
noo  | h    
```

## castcol

`castcol[dbdir;table;col;newtype]`

Cast the values in the column to the `newtype` and save. `newtype` can be specified in short or long form, e.g. `"f"` or `` `float `` for a cast to float. This can be used to cast nested types as well, but to cast a nested character column to symbol use `fncol` instead.

**Example:**

```q
castcol[`:data/taq;`trade;`size;`short]
```

**Changes:**

_meta_
```txt
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
size | h  
```

## clearattrcol

`clearattrcol[dbdir;table;col]`

Remove any attributes from column `col`.

**Example:**

```q
clearattrcol[`:data/taq;`trade;`sym]
```

**Changes:**

_meta_

```txt
c    | t f a
-----| -----
date | d    
sym  | s   
time | t    
price| f    
size | j    
```

## copycol

`copycol[dbdir;table;oldcol;newcol]`

Copy the values from `oldcol` into a new column named `newcol`, undefined in the table. This does not support nested columns.

**Example:**

```q
copycol[`:data/taq;`trade;`size;`size2]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── price
│       ├── size
│       ├── size2
│       ├── sym
│       └── time
└── sym
```

_meta_

```txt
meta
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
size | j    
size2| j   
```

## deletecol

`deletecol[dbdir;table;col]`

Delete column `col` from `table`. 

This doesn’t delete the col# files for nested columns (the files containing the actual values) – you will need to delete these manually.

**Example:**.
```q
deletecol[`:data/taq/;`trade;`size]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── price
│       ├── sym
│       └── time
└── sym
```

_meta_
```txt
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
```


## findcol

`findcol[dbdir;table;col]`

Print a list of the partition directories where `col` exists and its type in each, and a `*NOT*FOUND*` message for partition directories where `col` is missing.

**Example:**
```q
findcol[`:data/taq;`trade;`iz]
```

**Output:**

```txt
2023.02.17 10:23:09 column iz *NOT*FOUND* in `:data/taq/2023.01.01/trade
```

## fixtable

`fixtable[dbdir;table;goodpartition]`

Adds missing columns to to all partitions of a table, given the location of a good partition. This _doesn’t_ delete extra columns – do that manually. Also this does not add tables to partitions in which they are missing, use [`.Q.chk`](https://code.kx.com/q/ref/dotq/#qchk-fill-hdb) for that.

**Example:**

```q
`:data/taq/2023.01.02/trade/ set .Q.en[`:data/taq] delete size from trade;
fixtable[`:data/taq;`trade;`:data/taq/2023.01.01/trade]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── price
│       ├── size
│       ├── sym
│       └── time
├── 2023.01.02
│   └── trade
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```


## fncol

`fncol[dbdir;table;col;fn]`

Apply a function to the list of values in `col` and save the results as its values.

**Example:**

```q
fncol[`:data/taq;`trade;`price;2*]
```

**Changes:**

_before_
```txt
q)select price from trade
price   
--------
4812.041
1399.557
9491.982
5034.046
4882.605
...
```

_after_

```txt
q)select price from trade
price   
--------
9624.081
2799.113
18983.96
10068.09
9765.209
...
```


## listcols

`listcols[dbdir;table]`

List the columns of `table` (relies on the first partition).

**Example:**
```q
listcols[`:data/taq;`trade]
```

**Output:**

```txt
`sym`time`price`size
```

## renamecol

`renamecol[dbdir;table;oldname;newname]`

Rename column `oldname` to `newname`, which must be undefined in the table. This does not support nested columns.

**Example:**
```q
renamecol[`:data/taq;`trade;`woz;`iz]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── trade
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```

_meta_
```txt
c    | t f a
-----| -----
date | d    
sym  | s   p
time | t    
price| f    
size | j    
```

## reordercols

`reordercols[dbdir;table;neworder]`

Reorder the columns of `table`. `neworder` is a full list of the column names as they appear in the updated table.

**Example:**
```q
reordercols[`:data/taq;`trade;reverse cols trade]
```
**Changes:**

_meta_
```txt
c    | t f a
-----| -----
date | d    
size | j    
price| f    
sym  | s   p
time | t    
```


## setattrcol

`setattrcol[dbdir;table;col;newattr]`

Apply an attribute to `col`. The data in the column must be valid for that attribute. No sorting occurs.

**Example:**
```q
setattrcol[`:data/taq;`trade;`sym;`g]
```

**Changes:**

_meta_
```txt
c    | t f a
-----| -----
date | d    
sym  | s   g
time | t    
price| f    
size | j    
```

## addtable

`addtable[dbdir;tablename;table]`

Add a table called `tablename` with an empty table with the same schema as `table` created in each partition of the new table.

**Example:**
```q
addtable[`:data/taq;`trade1;.Q.en[`:data/taq]([]time:0#0Nt;sym:0#`;price:0#0n;size:0#0)]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   ├── trade
│   │   ├── price
│   │   ├── size
│   │   ├── sym
│   │   └── time
│   └── trade1
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```

## rentable

`rentable[dbdir;old;new]`

Rename table `old` to `new`.

**Example:**
```q
rentable[`:data/taq;`trade;`transactions]
```

**Changes:**

_on disk_
```txt
data/taq
├── 2023.01.01
│   └── transactions
│       ├── price
│       ├── size
│       ├── sym
│       └── time
└── sym
```


See also
--------

-   [`.Q.chk`](https://code.kx.com/q/ref/dotq/#qchk-fill-hdb)
-   [`.Q.en`](https://code.kx.com/q/ref/dotq/#qen-enumerate-varchar-cols)

