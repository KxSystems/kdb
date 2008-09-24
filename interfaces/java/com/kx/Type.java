package com.kx;

import java.lang.reflect.Array;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DecimalFormat;

/**
 * This class is a dumping ground for static methods and values from 
 * the legacy implementation.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a>
 * @author tech@kx.com
 */
public final class Type {

	/* No one is allowed instantiate this. */	
	private Type(){}

	/**
	 * This is the kdb+ null integer value.
	 */
	public final static int NullInteger = Integer.MIN_VALUE;

	/**
	 * This is the kdb+ null long value.
	 */
	public final static long NullLong = Long.MIN_VALUE;

	/**
	 * This is the kdb+ null float value.
	 */
	public final static double NullFloat = Double.NaN;

	/**
	 * Gets the appropriate null value for the given type code.
	 * 
	 * @param c the type identifier
	 * @return the null value
	 */
	public static Object getNull(char c) {
		return NULLVALUES[" b  xhijefcs mdz uvt".indexOf(c)];
	}

	/**
	 * Formats an integer to fit in a 2 digit string.
	 * 
	 * @param i the integer to format
	 * @return the 2 digit formatted string
	 */
	public static String toTwoDigitString(int i) {
		return new DecimalFormat("00").format(i);
	}

	/**
	 * Given an object, what is the appropriate kdb+ type tag?
	 * The kdb+ connection is that negative type tags are scalar values
	 * while positive ones are vectors. There are a number of special 
	 * cases. Notably, Flips, Dicts, and general lists.
	 *  
	 * @param x some object
	 * @return the appropriate kdb+ type tag
	 */
	public static int typeOf(Object x) {
		return x instanceof Boolean ? -1 : x instanceof Byte ? -4
			: x instanceof Short ? -5 : x instanceof Integer ? -6
			: x instanceof Long ? -7 : x instanceof Float ? -8
			: x instanceof Double ? -9 : x instanceof Character ? -10
			: x instanceof String ? -11 : x instanceof Month ? -13
			: x instanceof Time ? -19 : x instanceof Date ? -14
			: x instanceof java.util.Date ? -15 : x instanceof Minute ? -17
			: x instanceof Second ? -18 : x instanceof boolean[] ? 1
			: x instanceof byte[] ? 4 : x instanceof short[] ? 5
			: x instanceof int[] ? 6 : x instanceof long[] ? 7
			: x instanceof float[] ? 8 : x instanceof double[] ? 9
			: x instanceof char[] ? 10 : x instanceof String[] ? 11
			: x instanceof Month[] ? 13 : x instanceof Time[] ? 19
			: x instanceof Date[] ? 14 : x instanceof java.util.Date[] ? 15
			: x instanceof Minute[] ? 17 : x instanceof Second[] ? 18
			: x instanceof Flip ? 98 : x instanceof Dict ? 99
			: 0;
	}

	/**
	 * What is the length of the kdb+ object?
	 * 
	 * @param x some kdb+ value
	 * @return the size
	 */
	public static int size(Object x) {
		return x instanceof Dict ? size(((Dict) x).getKeys())
			: x instanceof Flip ? size(((Flip) x).getColumnValues()[0]) : Array.getLength(x);
	}

	/**
	 * Converts an object to a Flip.
	 * 
	 * @param object
	 * @return the flip
	 */
	public static Flip toFlip(Object object) {
		if (typeOf(object) == 98)
			return (Flip) object;
		Dict d = (Dict) object;
		Flip a = (Flip) d.getKeys(), b = (Flip) d.getValues();
		int m = size(a.getColumnNames()), n = size(b.getColumnNames());
		String[] names = new String[m + n];
		System.arraycopy(a.getColumnNames(), 0, names, 0, m);
		System.arraycopy(b.getColumnNames(), 0, names, m, n);
		Object[] values = new Object[m + n];
		System.arraycopy(a.getColumnValues(), 0, values, 0, m);
		System.arraycopy(b.getColumnValues(), 0, values, m, n);
		return new Flip(new Dict(names, values));
	}

	/**
	 * What is the kdb+ length of this string?
	 * 
	 * @param string
	 * @return the length
	 */
	static int stringLength(String string) {
		int i;
		return string == null 
					? 0 
					: -1 < (i = string.indexOf('\000')) ? i : string.length();
	}

	/**
	 * Get the i'th value in the given kdb+ value.
	 * 
	 * @param x some kdb+ object
	 * @param i the index
	 * @return the value at the given index
	 */
	public static Object at(Object x, int i) {
		Object target = Array.get(x, i);
		int t = -typeOf(target);
		boolean isNull = t > 4 && target.equals(NULLVALUES[t]);
		return isNull ? null : target;
	}

	/**
	 * Sets x[i] to y.
	 * 
	 * @param x the collection
	 * @param i the index
	 * @param y the new value
	 */
	public static void set(Object x, int i, Object y) {
		Array.set(x, i, null == y ? NULLVALUES[typeOf(x)] : y);
	}

	/**
	 * Computes the object size.
	 * 
	 * @param o some kdb+ value
	 * @return the size
	 */
	public static int objectSize(Object o) {
		int i = 0, n, t = typeOf(o), j;
		if (t == 99)
			return 1 + objectSize(((Dict) o).getKeys()) + objectSize(((Dict) o).getValues());
		if (t == 98)
			return 3 + objectSize(((Flip) o).getColumnNames()) + objectSize(((Flip) o).getColumnValues());
		if (t < 0)
			return t == -11 ? 2 + stringLength((String) o) : 1 + basesize[-t];
		j = 6;
		n = size(o);
		if (t == 0 || t == 11)
			for (; i < n; ++i)
				j += t == 0 ? objectSize(((Object[]) o)[i]) : 1 + stringLength(((String[]) o)[i]);
		else
			j += n * basesize[t];
		return j;
	}

	private static int[] basesize = 
		{0, 1, 0, 0, 1, 2, 4, 8, 4, 8, 1, 0, 0, 4, 4, 8, 0, 4, 4, 4 };

	private static Object[] NULLVALUES = { 
			null, 
			new Boolean(false), 
			null, 
			null,
			new Byte((byte) 0), 
			new Short(Short.MIN_VALUE), 
			new Integer(NullInteger),
			new Long(NullLong), 
			new Float(NullFloat), 
			new Double(NullFloat), 
			new Character(' '),
			"", 
			null, 
			new Month(NullInteger), 
			new Date(NullLong), 
			new Timestamp(NullLong), 
			null,
			new Minute(NullInteger), 
			new Second(NullInteger), 
			new Time(NullLong) 
	};

}
