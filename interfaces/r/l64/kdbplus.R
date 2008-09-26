dyn.load(file.path(Sys.getenv("QHOME"),"l64","kx_r_interface.so"))

open_connection <- function(host="localhost", port=5000, user=NULL) {
         parameters <- list(host, as.integer(port), user)
         .Call("kx_open_connection", parameters)
}

close_connection <- function(connection) {
	.Call("kx_close_connection", as.integer(connection))
}

execute <- function(connection, query) {
	.Call("kx_execute", as.integer(connection), query)
}
