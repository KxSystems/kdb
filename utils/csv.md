# csvguess

two scripts for loading CSVs by guessing CSV loadstrings after inspecting the data. After tweaking the column definitions you can generate a loader script (csvguess.q) or simply manipulate the guessed types and load the data (csvutil.q) 

see: https://code.kx.com/q/ref/file-text/ for the vanilla CSV loading primitives.

### csvutil.q

a collection of utilities to load CSVs

.csv.colhdrs[file] - return a list of colhdrs from file

 .csv.info[file] - return a table of information about the file
 columns include:
 
* c - column name
* ci - column index 
* t - load type
* mw - max width
* dchar - distinct characters in values
* rules - rules that caught the type
* gr - granularity - a measure of the number of different values. A granularity of 0 means it’s all just one value, 100 means every value is different. A high granularity is an indicator that the column will compress well, and that it could be stored as an enumeration rather than strings.
* maybe - assigned type needs checking, 1812 for example _could_ be a date, or a time of day, or a short, or an int, or a long, a float or perhaps a symbol for the title of a loud lump of music.

.csv.infoonly[file;onlycols] - like .csv.info except that it only analyses <onlycols>

.csv.infolike[file;pattern] - like .csv.info except that it only analyses columns with a name matching pattern (case independent) 

 example:
 
```	
info:.csv.infoonly[file;`buy`sell`size]
info:.csv.infolike[file;"*price"]
show delete from info where t=" "
```

 .csv.data[file;info] - use the info from .csv.info to read the data

 .csv.data10[file;info] - like .csv.data but only returns the first 10 rows

 bulkload[file;info] - bulk loads file into table DATA (which must be already defined :: DATA:() )

 .csv.read[file]/read10[file] - for when you don't care about checking/tweaking the <info> before reading
 
### csvguess.q

a standalone script to generate a csv loader for a particular schema. 

```
usage: q csvguess.q CSVFILE [-basic] [-compress|co] [-noheader|nh] [-discardempty|de] [-semicolon|sc] [-tab|tb] [-zaphdrs|zh] [-savescript|ss] [-saveinfo|si] [-zeuro|z1] [-exit]
```

Command line options:
 
* -basic - load basic types only, treats 20200519 as an integer not a date for example
* -compress|co - compress low granularity (info.gr) columns with COMPRESSZD default (17;2;6)
* -noheader|nh - the csv file doesn't have headers, so create some (c00..)
* -discardempty|de - if a column is empty don't bother to load it
* -semicolon|sc - use semicolon as delimiter in place of the default comma
* -tab|tb - use tab as delimiter in place of default comma
* -zaphdrs|zh - by default junk characters are removed from column headers, so for example "Profit & Loss_2005" will become "ProfitLoss_2005". Use the zaphdrs flag to force the name to lowercase and to remove the underscores ("profitloss2005")
* -savescript|ss - save a standalone load script for the data. Do this manually (perhaps after adjusting <info>) by calling savescript[]
* -saveinfo|si - *append* the table information to a shared csv - potentially with information from other tables
* -zeur|zeuro|z1 - set \z 1 for european format dates dd/mm/yy (default \z 0 mm/dd/yy)
* -exit - exit on completion, only makes sense in conjunction with savescript or saveinfo

example:

```
for %1 in (import\*.csv) do q csvguess.q %1 -zh -ss -si -exit
```
