package com.kx;

import java.util.Arrays;

/**
 * This class is a kdb+ flip.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class Flip {

	private String[] columnNames;
	private Object[] columnValues;

	/**
	 * Constructs the flip from the given dictionary.
	 * 
	 * @param dict the underlying dict
	 */
	public Flip(Dict dict) {
		columnNames = (String[]) dict.getKeys();
		columnValues = (Object[]) dict.getValues();
	}
	
	/**
	 * Gets the column for the given string.
	 * 
	 * @param s the name
	 * @return the column
	 */
	public Object at(String s) {
		int i = 0;
		for (; i < columnNames.length && !columnNames[i].equals(s);)
			++i;
		return columnValues[i];
	}

	/**
	 * Checks for equality.
	 *
	 * @see java.lang.Object#equals(Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final Flip other = (Flip) obj;
		if (!Arrays.equals(columnNames, other.columnNames))
			return false;
		if (!Arrays.equals(columnValues, other.columnValues))
			return false;
		return true;
	}
	
	private static int hashCode(Object[] array) {
		final int PRIME = 31;
		if (array == null)
			return 0;
		int result = 1;
		for (int index = 0; index < array.length; index++) {
			result = PRIME * result + (array[index] == null ? 0 : array[index].hashCode());
		}
		return result;
	}

	/**
	 * Gets the hashcode.
	 *
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int PRIME = 31;
		int result = 1;
		result = PRIME * result + Flip.hashCode(columnNames);
		result = PRIME * result + Flip.hashCode(columnValues);
		return result;
	}

	/**
	 * Gets the column names.
	 * 
	 * @return the names
	 */
	public String[] getColumnNames() {
		return columnNames;
	}

	/**
	 * Sets the column names.
	 * 
	 * @param columnNames
	 */
	public void setColumnNames(String[] columnNames) {
		this.columnNames = columnNames;
	}

	/**
	 * Gets the column values.
	 * 
	 * @return the values
	 */
	public Object[] getColumnValues() {
		return columnValues;
	}

	/**
	 * Sets the column values.
	 * 
	 * @param columnValues
	 */
	public void setColumnValues(Object[] columnValues) {
		this.columnValues = columnValues;
	}
	
}
