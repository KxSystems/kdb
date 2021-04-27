# csvguess

the two csv scripts in this repository simplify the loading of CSV files by analysing the contents of a reasonable subset of the records, and guessing the most likely datatypes to use to load the data into a q table. 

Both of them use a generated table /info/ which contains information about the CSV columns:

* c - column name.
* ci - column index. 
* t - proposed q datatype.
* maybe - true if the assigned datatype needs further checking, 1812 for example _could_ be a date, or a time of day, or a short, or an int, or a long, a float or perhaps a symbol for the title of a loud lump of music.
* empty - true if the column seems to be empty, ie no datatype can be suggested (there's a command line flag for csvguess.q to discard such columns).
* res - true if the column name is a q reserved word, ie should be fixed before loading.
* j10, j12 - true if the column values could be encoded using .Q.x10/j10/x12/j12 rather than storing them as symbols or strings.
* ipa - true if the column could be loaded as ip-addresses.
* mw - max width seen.
* dot - maximum number of dots/points - for an int this would have to be 0, for a float 1 or 0.
* rules - the rule numbers which were used to decide on the proposed datatype (see the code for exactly what's being checked)
* gr - granularity - a measure of the number of different values. A granularity of 0 means it’s all just one value, 100 means every value is different. A high granularity is an indicator that the column will compress well, and that it could be stored as an enumeration rather than strings.
* nov - number of default values. The exact count as used to calculate /gr/ above
* dchar - distinct characters in values.

The **csvguess.q** script loads the file given on the command line, creates the /info/ table and can then either load the data (use functions LOAD or LOAD10 to check that the definition in /info/ generates the data you want to see) or can use the definition of /info/ to save out a bulk loader script to bulk load to memory, or bulk save to disk.

**csvutil.q** is more a toolkit for loading CSVs, and can be embedded in other applications. It contains functions to create the /info/ table from a CSV file, and functions to load data into memory based on a previously defined /info/ table.

see: https://code.kx.com/q/ref/file-text/ for the vanilla CSV loading primitives, and https://code.kx.com/q/ref/tok/ for the list of possible  datatypes.

## csvutil.q

a collection of functions to load CSVs:

.csv.colhdrs[file] - return a list of colhdrs from file

 .csv.info[file] - return a table of information about the file (see above for the column list)
 
.csv.infoonly[file;onlycols] - like .csv.info except that it restricts analysis to /onlycols/

.csv.infolike[file;pattern] - like .csv.info except that it only analyses columns with a name matching *pattern* (case independent) 

 examples:
 
```	
info:.csv.infoonly[file;`buy`sell`size]
info:.csv.infolike[file;"*price"]
show delete from info where t=" "
```

 .csv.data[file;info] - use a previously generated info from .csv.info to read the data

 .csv.data10[file;info] - like .csv.data but only returns the first 10 rows

 bulkload[file;info] - bulk loads file into table DATA (which must be already defined, set DATA:() if no previous version exists)

 .csv.read[file]/read10[file] - for when you don't care about checking/tweaking the definition in /info/ before reading - they're convenience functions for .csv.data[file;.csv.info file]/.csv.data10[file;.csv.info file]
 
## csvguess.q

a standalone script to load a CSV file or generate a loader script for a particular schema (defined in table /info/ - generated at load time).

The behaviour of this script can be steered by command line flags:

```
usage: q csvguess.q CSVFILE [-basic] [-compress|co] [-noheader|nh] [-discardempty|de] [-semicolon|sc] [-tab|tb] [-zaphdrs|zh] [-savescript|ss] [-saveinfo|si] [-zeuro|z1] [-exit]
```

Command line options:
 
* -basic - load basic types only, treats 20200519 as an integer not a date for example.
* -compress|co - compress low granularity (info.gr) columns with COMPRESSZD default (17;2;6).
* -help - provide a list of the command line options.
* -noheader|nh - the csv file doesn't have headers, so create some (c00..).
* -discardempty|de - if a column is empty don't bother to load it.
* -semicolon|sc - use semicolon as delimiter in place of the default comma.
* -tab|tb - use tab as delimiter in place of default comma.
* -zaphdrs|zh - by default junk characters are removed from column headers, so for example "Profit & Loss_2005" will become "ProfitLoss_2005". Use the zaphdrs flag to force the name to lowercase and to remove the underscores ("profitloss2005").
* -savescript|ss - save a standalone load script for the data. Do this manually (perhaps after adjusting /info/) by calling savescript[].
* -saveinfo|si - *append* the table information to a shared csv - potentially with information from other tables.
* -zeur|zeuro|z1 - set \z 1 for european format dates dd/mm/yy (default \z 0 mm/dd/yy).
* -exit - exit on completion, only makes sense in conjunction with savescript or save-info.

example:

```
for %1 in (import\*.csv) do q csvguess.q %1 -zh -ss -si -exit
```

within the csvguess session the following globals can be set, and will control the load:

* COMPRESS - if the data should be compressed. 
* COMPRESSZD - value of .z.zd to be used if COMPRESS is set.
* DELIM - the CSV delimiter, the default is comma, but this allows setting semi-colon, tab, |, or whatever bizarre choice your provider made.

particularly useful are the following functions which allow cleaning up the data as it’s loaded or saved. The argument to all of them is the complete data if a ...ALL function , or the latest chunk loaded if an ...EACH function

* POSTLOADALL - run after loading all the data, for example {`time xasc x}
* POSTLOADEACH - run after each incremental load (if using .Q.fs to avoid having to load all in one go) 
* POSTSAVEALL - run after saving to disk, for example to run a disk sort over the table.
* PRESAVEEACH - the last minute fixups before writing to disk.

there are other options, but they're better set using the command line options described above.

### custom bulk load/save script CSVFILE.load.q

if a loader script is generated - either by using the -savescript command line option, or by calling the savescript[] function from within the csvguess session (perhaps after tweaking the definition of the default <info> table) - that loader script will have the name CSVFILE.load.q. The value of CSVFILE being taken from the csvguess.q command line. All the customisations like the POSTLOADALL etc functions will be included in the custom loader file. 

Custom charges can be forced by putting the values in the custom.csvguess.q file. The most common use for this is to set the delimiter if you live in a country which doesn't use comma, for example DELIM:";".

That generated loader in turn has the following command line options to control how and where it loads/saves data:

* FILE - the file to be loaded, if it’s elided the script will try to use the file used at generation time.
* -help - to get a list of the command line options.
* -bl|bulkload - bulk load data from FILE. 
* -bs|bulksave - bulk save data from FILE to disk, loading and writing incrementally if required.
* -js|justsym - do a quick run through only loading the columns of type symbol. This is useful if you're loading a LOT of data, it allows you to make a quick pass through the CSV files and update the master sym file. Then you can safely load all the CSVs in parallel as there'll be no contention for the sym file to slow you down.
* -savedb - the top level database name, for example TAQ.  
* -saveptn - the partition where the data should be saved, for example a date if you're loading data split by date files.
* -savename - the individual table name, for example trade.
* -chunksize - the amount of data (in MB) to be loaded in one go. The load statistics displayed will help to tune this.

