package com.kx;

import static com.kx.Type.NullInteger;
import static com.kx.Type.toTwoDigitString;

/**
 * This class is a kdb+ second.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a>
 * @author tech@kx.com
 */
public class Second {
	
	private int seconds;

	/**
	 * Constructs a kdb+ seconds value.
	 * 
	 * @param seconds
	 */
	public Second(int seconds) {
		this.seconds = seconds;
	}

	/**
	 * Converts to a string.
	 *
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		if (seconds == NullInteger) 
				return "";
		else
				return new Minute(seconds / 60).toString() 
							+ ':' 
							+ toTwoDigitString(seconds % 60);
	}

	/**
	 * Checks for equality.
	 *
	 * @see java.lang.Object#equals(Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Second) 
			return (seconds == ((Second)obj).seconds);
		else 
			return false;
	}

	/**
	 * Gets the hashcode.
	 *
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		return seconds;
	}

	/**
	 * Gets the seconds.
	 * 
	 * @return the seconds
	 */
	public int getSeconds() {
		return seconds;
	}

	/**
	 * Sets the seconds.
	 * 
	 * @param seconds the new value
	 */
	public void setSeconds(int seconds) {
		this.seconds = seconds;
	}
	
}
