package com.kx;

/**
 * This class is a kdb+ dictionary. 
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class Dict {
	
	private Object keys;
	private Object values;

	/**
	 * Constructs a dict from the given keys and values.
	 *  
	 * @param keys
	 * @param values
	 */
	public Dict(Object keys, Object values) {
		this.keys = keys;
		this.values = values;
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
		final Dict other = (Dict) obj;
		if (keys == null) {
			if (other.keys != null)
				return false;
		} else if (!keys.equals(other.keys))
			return false;
		if (values == null) {
			if (other.values != null)
				return false;
		} else if (!values.equals(other.values))
			return false;
		return true;
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
		result = PRIME * result + ((keys == null) ? 0 : keys.hashCode());
		result = PRIME * result + ((values == null) ? 0 : values.hashCode());
		return result;
	}

	/**
	 * Gets the keys.
	 * 
	 * @return the keys
	 */
	public Object getKeys() {
		return keys;
	}

	/**
	 * Sets the keys.
	 * 
	 * @param keys
	 */
	public void setKeys(Object keys) {
		this.keys = keys;
	}

	/**
	 * Gets the values.
	 * 
	 * @return the values
	 */
	public Object getValues() {
		return values;
	}

	/**
	 * Sets the values.
	 * 
	 * @param values
	 */
	public void setValues(Object values) {
		this.values = values;
	}	

}
