package com.kx;

import static com.kx.Type.NullInteger;
import static com.kx.Type.toTwoDigitString;

/**
 * This class is a kdb+ minute.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class Minute {
	
	private int minute;

	/**
	 * Constructs the minute.
	 * 
	 * @param minute
	 */
	public Minute(int minute) {
		this.minute = minute;
	}

	/**
 	 * Converts to a string.
 	 *
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		if (minute == NullInteger)
			return "";
		else
			return toTwoDigitString(minute / 60) 
					+ ":" 
					+ toTwoDigitString(minute % 60);
	}

	/**
         * Checks for equality.
         *
	 * @see java.lang.Object#equals(Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Minute) 
			return (minute == ((Minute)obj).minute);
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
		return minute;
	}

	/**
	 * Gets the minute.
	 * 
	 * @return the minute
	 */
	public int getMinute() {
		return minute;
	}

	/**
	 * Sets the minute.
	 * 
	 * @param minute the new value
	 */
	public void setMinute(int minute) {
		this.minute = minute;
	}
}
