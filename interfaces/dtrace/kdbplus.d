provider kdbplus {

	/* Network handling. */
	probe port__open(int, char*, char*);  		/* .z.po (handle, client_ip, client_username) */                     
	probe port__close(int);				/* .z.pc (handle) */
	probe port__async__query(int, char*, int);	/* .z.ps (handle, query)*/
	probe port__sync__query(int, char*, int);	/* .z.pg (handle, query) */
	probe port__query__end(int);			/* (handle) */
	probe http__get(int, char*, int);		/* .z.ph (handle) */
	probe http__post(int, char*, int);		/* .z.pp (handle) */
	probe http__auth(char*);			/* .z.pw (userid-password) NB. password is in plain text. */
	probe restore__dotz(char*);            		/* (dotz-function-restored) */

	/* Timers. */
	probe timer__fire(long);			/* (time) */

	/* Memory. */
	probe memory__allocation(long long);		/* (size-allocated) */
	probe memory__deallocation(void*, int);		/* (pointer, size) */
	probe free__and__exit(int);             	/* (exit-status) */
	probe reference__inc(void*, int);	       	/* (pointer, new-reference-count) */
	probe reference__dec(void*, int);		/* (pointer, new-reference-count) */
	probe reference__free(void*);			/* (pointer) */

	/* Variables. */
	probe value__set(char*);			/* (name) */

	/* Database */
	probe load__database(char*);			/* (path) */
	probe log__replay(char*);			/* (file) */
	probe query__rollback(int, char*);		/* (handle, error) */

	/* OS Interaction and timing */
	probe os__command(char*);			/* (command) */
	probe redirect__stdout(char*);         		/* (new-path) */
	probe redirect__stderr(char*);         		/* (new-path) */
	probe create__thread(void*);			/* (function-pointer) */

	/* Errors */
	probe error__raised(char*);			/* (error-message) */

};

