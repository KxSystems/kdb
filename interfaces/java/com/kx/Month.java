package com.kx;

import static com.kx.Type.NullInteger;
import static com.kx.Type.toTwoDigitString;

/**
 * This class is a kdb+ month.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class Month {
	
	private int month;

	/**
	 * Constructs a kdb+ month.
	 * 
	 * @param month
	 */
	public Month(int month) {
		this.month = month;
	}

	/**
	 * Converts to a string.
	 *
	 * @see java.lang.Object#toString()
	 */
	@Override	
	public String toString() {
		int m = month + 24000, y = m / 12;
		if (month == NullInteger) 
			return "";
		else 
			return toTwoDigitString(y / 100) + toTwoDigitString(y % 100) 
				+ "-"
				+ toTwoDigitString(1 + m % 12);
	}

	/**
	 * Checks for equality.
	 *
	 * @see java.lang.Object#equals(Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Month) 
			return (month == ((Month)obj).month);
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
		return month;
	}

	/**
	 * Gets the month.
	 * 
	 * @return the month
	 */
	public int getMonth() {
		return month;
	}

	/**
	 * Sets the month.
	 * 
	 * @param month
	 */
	public void setMonth(int month) {
		this.month = month;
	}
	
}
