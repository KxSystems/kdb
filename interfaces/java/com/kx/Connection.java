package com.kx;

import java.io.IOException;

/**
 * This interface represents a connection to a kdb+ server.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a>
 * @author tech@kx.com
 */
public interface Connection {

	public java.util.TimeZone timezone = java.util.TimeZone.getDefault();
	
	/**
	 * Explicitly closes the connection to kdb+. This may put the connection in
	 * an unusable state.
	 * 
	 * @throws IOException
	 */
	public abstract void close() 
	throws IOException;

	/**
	 * Runs the given command string against the kdb+ server.
	 * 
	 * @param s the string to execute
	 * @throws IOException
	 */
	public abstract void run(String s) 
	throws IOException;

	/**
	 * Runs the given command string against the kdb+ server 
	 * passing the given object argument.
	 * 
	 * @param s the string to execute
	 * @param x the argument
	 * @throws IOException
	 */
	public abstract void run(String s, Object x) 
	throws IOException;

	/**
	 * Runs the given query string against the kdb+ server 
	 * passing the given object arguments.
	 * 
	 * @param s the string to execute
	 * @param x an argument
	 * @param y an argument
	 * @throws IOException
	 */
	public abstract void run(String s, Object x, Object y) 
	throws IOException;

	/**
	 * Runs the given command string against the kdb+ server 
	 * passing the given object arguments.
	 * 
	 * @param s the string to execute
	 * @param x an argument
	 * @param y an argument
	 * @param z an argument
	 * @throws IOException
	 */
	public abstract void run(String s, Object x, Object y, Object z) 
	throws IOException;

	/**
	 * Waits for an incoming message from the kdb+ server.
	 *  
	 * @return the message value
	 * @throws KxException
	 * @throws IOException
	 */
	public abstract Object listen() 
	throws KxException, IOException;

	/**
	 * Runs the given query string against the kdb+ server.
	 * 
	 * @param s the query to execute
	 * @return the result of the query as a kdb+ value
	 * @throws KxException
	 * @throws IOException
	 */
	public abstract Object query(String s) 
	throws KxException, IOException;

	/**
	 * Runs the given query string against the kdb+ server 
	 * passing the given object arguments.
	 * 
	 * @param s the query to execute
	 * @return the result of the query as a kdb+ value
	 * @throws KxException
	 * @throws IOException
	 */
	public abstract Object query(String s, Object x) 
	throws KxException, IOException;

	/**
	 * Runs the given query string against the kdb+ server 
	 * passing the given object arguments.
	 * 
	 * @param s the query to execute
	 * @param x an argument
	 * @param y an argument
	 * @return the result of the query as a kdb+ value
	 * @throws KxException
	 * @throws IOException
	 */
	public abstract Object query(String s, Object x, Object y) 
	throws KxException, IOException;

	/**
	 * Runs the given query string against the kdb+ server 
	 * passing the given object arguments.
	 * 
	 * @param s the query to execute
	 * @param x an argument
	 * @param y an argument
	 * @param z an argument
	 * @return the result of the query as a kdb+ value
	 * @throws KxException
	 * @throws IOException
	 */
	public abstract Object query(String s, Object x, Object y, Object z)
	throws KxException, IOException;

}
