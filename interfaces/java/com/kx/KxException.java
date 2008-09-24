package com.kx;

/**
 * This class is a kdb+ error.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class KxException extends Exception {
	static final long serialVersionUID = -4113680138561858696L;

	/**
	 * Constructs the error.
	 * 
	 * @param s the error description
	 */
	KxException(String s) {
		super(s);
	}
}
