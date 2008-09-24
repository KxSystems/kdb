package com.kx;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import static com.kx.Type.NullInteger;
import static com.kx.Type.NullFloat;
import static com.kx.Type.NullLong;
import static com.kx.Type.typeOf;
import static com.kx.Type.size;
import static com.kx.Type.stringLength;
import static com.kx.Type.objectSize;

/**
 * This class is a kdb+ connection.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class ConnectionImpl implements Connection {

	/**
	 * Connects to the kdb+ process at the given host and port. 
	 * This uses the user.name system property to log in.
	 * 
	 * @param host the remote kdb+ host
	 * @param port the port on which kdb+ is listening
	 * @throws KxException
	 * @throws IOException
	 */
	public ConnectionImpl(String host, int port) 
	throws KxException, IOException {
		this(host, port, System.getProperty("user.name"));
	}

	/**
	 * Connects to the kdb+ process at the given host and port and
	 * with the given credentials.
	 * 
	 * @param host the remote kdb+ host
	 * @param port the port on which kdb+ is listening
	 * @param credentials the username:password string to log in with
	 * @throws KxException
	 * @throws IOException
	 */
	public ConnectionImpl(String host, int port, String credentials) 
	throws KxException, IOException {
		io(new Socket(host, port));
		buffer = new byte[1 + stringLength(credentials)];
		J = 0;
		write(credentials);
		outputStream.write(buffer);
		if (1 != inputStream.read(buffer, 0, 1))
			throw new KxException("Access denied for " + credentials);
	}

	/**
	 * Creates a kdb+ connection listening on the give socket.
	 * 
	 * @param socket the socket on which to listen
	 * @throws IOException
	 */
	public ConnectionImpl(ServerSocket socket) throws IOException {
		io(socket.accept());
		inputStream.read(b = new byte[99]);
		outputStream.write(b, 0, 1);
	}

	/**
	 * Explicitly closes the current kdb+ connection. This leaves 
	 * us in an unusable state.
	 * 
	 * @see com.kx.Connection#close()
	 */
	public void close() 
	throws IOException {
		socket.close();
		inputStream.close();
		outputStream.close();
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#run(String)
	 */
	public void run(String s) 
	throws IOException {
		write(0, s.toCharArray());
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#run(String, Object)
	 */
	public void run(String s, Object x) 
	throws IOException {
		Object[] a = { s.toCharArray(), x };
		write(0, a);
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#run(String, Object, Object)
	 */
	public void run(String s, Object x, Object y) 
	throws IOException {
		Object[] a = { s.toCharArray(), x, y };
		write(0, a);
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#run(String, Object, Object, Object)
	 */
	public void run(String s, Object x, Object y, Object z) 
	throws IOException {
		Object[] a = { s.toCharArray(), x, y, z };
		write(0, a);
	}

	/**
	 * Listens for incoming messages.
	 * 
	 * @see com.kx.Connection#listen()
	 */
	public Object listen() 
	throws KxException, IOException {
		synchronized (inputStream) {
			inputStream.readFully(b = new byte[8]);
			async = b[0] == 1;
			j = 4;
			inputStream.readFully(b = new byte[readInt() - 8]);
			if (b[0] == -128) {
				j = 1;
				throw new KxException(readString());
			}
			j = 0;
			return read();
		}
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#query(String)
	 */
	public Object query(String s) 
	throws KxException, IOException {
		return executeQuery(s.toCharArray());
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#query(String, Object)
	 */
	public Object query(String s, Object x) 
	throws KxException, IOException {
		Object[] a = { s.toCharArray(), x };
		return executeQuery(a);
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#query(String, Object, Object)
	 */
	public Object query(String s, Object x, Object y) 
	throws KxException, IOException {
		Object[] a = { s.toCharArray(), x, y };
		return executeQuery(a);
	}

	/**
	 * Runs the given query.
	 * 
	 * @see com.kx.Connection#query(String, Object, Object, Object)
	 */
	public Object query(String s, Object x, Object y, Object z) 
	throws KxException, IOException {
		Object[] a = { s.toCharArray(), x, y, z };
		return executeQuery(a);
	}

	private synchronized Object executeQuery(Object x) 
	throws KxException, IOException {
		write(1, x);
		return listen();
	}
	
	private void write(byte x) {
		buffer[J++] = x;
	}

	private void write(boolean x) {
		write((byte) (x ? 1 : 0));
	}

	private void write(short h) {
		write((byte) (h >> 8));
		write((byte) h);
	}

	private void write(int i) {
		write((short) (i >> 16));
		write((short) i);
	}

	private void write(long j) {
		write((int) (j >> 32));
		write((int) j);
	}

	private void write(float e) {
		write(Float.floatToIntBits(e));
	}

	private void write(double f) {
		write(Double.doubleToLongBits(f));
	}

	private void write(char c) {
		write((byte) c);
	}

	private void write(String s) {
		int i = 0, n = stringLength(s);
		for (; i < n;)
			write(s.charAt(i++));
		buffer[J++] = 0;
	}

	private void write(Month m) {
		write(m.getMonth());
	}

	private void write(Minute u) {
		write(u.getMinute());
	}

	private void write(Second v) {
		write(v.getSeconds());
	}

	private void write(Date d) {
		long l = d.getTime();
		write(l == NullLong ? NullInteger : (int) ((lg(l) - k) / 86400000));
	}

	private void write(java.util.Date z) {
		long l = z.getTime();
		write(l == NullLong ? NullFloat : (lg(l) - k) / 8.64e7);
	}
	
	private void write(Time t) {
		long l = t.getTime();
		write(l == NullLong ? NullInteger : (int) (lg(l) % 86400000));
	}
	
	private void write(Object x) {
		int i = 0, n, t = typeOf(x);
		write((byte) t);
		if (t < 0)
			switch (t) {
			case -1:
				write(((Boolean) x).booleanValue());
				return;
			case -4:
				write(((Byte) x).byteValue());
				return;
			case -5:
				write(((Short) x).shortValue());
				return;
			case -6:
				write(((Integer) x).intValue());
				return;
			case -7:
				write(((Long) x).longValue());
				return;
			case -8:
				write(((Float) x).floatValue());
				return;
			case -9:
				write(((Double) x).doubleValue());
				return;
			case -10:
				write(((Character) x).charValue());
				return;
			case -11:
				write((String) x);
				return;
			case -13:
				write((Month) x);
				return;
			case -14:
				write((Date) x);
				return;
			case -15:
				write((java.util.Date) x);
				return;
			case -17:
				write((Minute) x);
				return;
			case -18:
				write((Second) x);
				return;
			case -19:
				write((Time) x);
				return;
			}
		if (t == 99) {
			Dict r = (Dict) x;
			write(r.getKeys());
			write(r.getValues());
			return;
		}
		buffer[J++] = 0;
		if (t == 98) {
			Flip r = (Flip) x;
			buffer[J++] = 99;
			write(r.getColumnNames());
			write(r.getColumnValues());
			return;
		}
		write(n = size(x));
		for (; i < n; ++i)
			if (t == 0)
				write(((Object[]) x)[i]);
			else if (t == 1)
				write(((boolean[]) x)[i]);
			else if (t == 4)
				write(((byte[]) x)[i]);
			else if (t == 5)
				write(((short[]) x)[i]);
			else if (t == 6)
				write(((int[]) x)[i]);
			else if (t == 7)
				write(((long[]) x)[i]);
			else if (t == 8)
				write(((float[]) x)[i]);
			else if (t == 9)
				write(((double[]) x)[i]);
			else if (t == 10)
				write(((char[]) x)[i]);
			else if (t == 11)
				write(((String[]) x)[i]);
			else if (t == 13)
				write(((Month[]) x)[i]);
			else if (t == 14)
				write(((Date[]) x)[i]);
			else if (t == 15)
				write(((java.util.Date[]) x)[i]);
			else if (t == 17)
				write(((Minute[]) x)[i]);
			else if (t == 18)
				write(((Second[]) x)[i]);
			else
				write(((Time[]) x)[i]);
	}

	private boolean readBoolean() {
		return 1 == b[j++];
	}

	private short readShort() {
		int x = b[j++], y = b[j++];
		return (short) (async ? x & 0xff | y << 8 : x << 8 | y & 0xff);
	}

	private int readInt() {
		int x = readShort(), y = readShort();
		return async ? x & 0xffff | y << 16 : x << 16 | y & 0xffff;
	}

	private long readLong() {
		int x = readInt(), y = readInt();
		return async ? x & 0xffffffffL | (long) y << 32 : (long) x << 32 | y
				& 0xffffffffL;
	}

	private float readReal() {
		return Float.intBitsToFloat(readInt());
	}

	private double readFloat() {
		return Double.longBitsToDouble(readLong());
	}

	private char readChar() {
		return (char) (b[j++] & 0xff);
	}

	private String readString() {
		int i = j;
		for (; b[j++] != 0;)
			;
		return new String(b, i, j - 1 - i);
	}

	private Month readMonth() {
		return new Month(readInt());
	}

	private Minute readMinute() {
		return new Minute(readInt());
	}

	private Second readSecond() {
		return new Second(readInt());
	}

	private Timestamp readTimestamp() {
		double f = readFloat();
		return new Timestamp(Double.isNaN(f) ? NullLong : gl(k + (long) (8.64e7 * f)));
	}

	private Time readTime() {
		int i = readInt();
		return new Time(i == NullInteger ? NullLong : gl(i));
	}

	private Date readDate() {
		int i = readInt();
		return new Date(i == NullInteger ? NullLong : gl(k + 86400000L * i));
	}
	
	private Object read() {
		int i = 0, n, t = b[j++];
		if (t < 0)
			switch (t) {
			case -1:
				return new Boolean(readBoolean());
			case -4:
				return new Byte(b[j++]);
			case -5:
				return new Short(readShort());
			case -6:
				return new Integer(readInt());
			case -7:
				return new Long(readLong());
			case -8:
				return new Float(readReal());
			case -9:
				return new Double(readFloat());
			case -10:
				return new Character(readChar());
			case -11:
				return readString();
			case -13:
				return readMonth();
			case -14:
				return readDate();
			case -15:
				return readTimestamp();
			case -17:
				return readMinute();
			case -18:
				return readSecond();
			case -19:
				return readTime();
			}
		if (t > 99) {
			if (t == 100) {
				readString();
				return read();
			}
			if (t < 104)
				return b[j++] == 0 && t == 101 ? null : "func";
			if (t > 105)
				read();
			else
				for (n = readInt(); i < n; i++)
					read();
			return "func";
		}
		if (t == 99)
			return new Dict(read(), read());
		j++;
		if (t == 98)
			return new Flip((Dict) read());
		n = readInt();
		switch (t) {
		case 0:
			Object[] L = new Object[n];
			for (; i < n; i++)
				L[i] = read();
			return t == 0 ? L : (Object) "func";
		case 1:
			boolean[] B = new boolean[n];
			for (; i < n; i++)
				B[i] = readBoolean();
			return B;
		case 4:
			byte[] G = new byte[n];
			for (; i < n; i++)
				G[i] = b[j++];
			return G;
		case 5:
			short[] H = new short[n];
			for (; i < n; i++)
				H[i] = readShort();
			return H;
		case 6:
			int[] I = new int[n];
			for (; i < n; i++)
				I[i] = readInt();
			return I;
		case 7:
			long[] J = new long[n];
			for (; i < n; i++)
				J[i] = readLong();
			return J;
		case 8:
			float[] E = new float[n];
			for (; i < n; i++)
				E[i] = readReal();
			return E;
		case 9:
			double[] F = new double[n];
			for (; i < n; i++)
				F[i] = readFloat();
			return F;
		case 10:
			char[] C = new char[n];
			for (; i < n; i++)
				C[i] = readChar();
			return C;
		case 11:
			String[] S = new String[n];
			for (; i < n; i++)
				S[i] = readString();
			return S;
		case 13:
			Month[] M = new Month[n];
			for (; i < n; i++)
				M[i] = readMonth();
			return M;
		case 14:
			Date[] D = new Date[n];
			for (; i < n; i++)
				D[i] = readDate();
			return D;
		case 17:
			Minute[] U = new Minute[n];
			for (; i < n; i++)
				U[i] = readMinute();
			return U;
		case 15:
			Timestamp[] Z = new Timestamp[n];
			for (; i < n; i++)
				Z[i] = readTimestamp();
			return Z;
		case 18:
			Second[] V = new Second[n];
			for (; i < n; i++)
				V[i] = readSecond();
			return V;
		case 19:
			Time[] T = new Time[n];
			for (; i < n; i++)
				T[i] = readTime();
			return T;
		}
		return null;
	}

	private void write(int i, Object x) 
	throws IOException {
		int n = objectSize(x) + 8;
		synchronized (outputStream) {
			buffer = new byte[n];
			buffer[0] = 0;
			buffer[1] = (byte) i;
			J = 4;
			write(n);
			write(x);
			outputStream.write(buffer);
		}
	}
	
	private long o(long x) {
		return timezone.getOffset(x);
	}

	private long lg(long x) {
		return x + o(x);
	}

	private long gl(long x) {
		return x - o(x - o(x));
	}

	private byte[] b, buffer;
	private int j, J;
	private boolean async;
	private final static long k = 86400000L * 10957;

	private Socket socket;	
	private DataInputStream inputStream;
	private OutputStream outputStream;

	private void io(Socket socket) 
	throws IOException {
		this.socket = socket;
		inputStream = new DataInputStream(socket.getInputStream());
		outputStream = socket.getOutputStream();
	}

}
