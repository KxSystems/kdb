using System;
using System.IO;
using System.Net.Sockets;

namespace Kdbplus
{
    /// <summary>
    /// This is an implementation of the kdb+ wire protocol and query execution
    /// methods against a kdb+ service.
    /// </summary>
    public class Connection : TcpClient, IConnection
    {
        /// <summary>
        /// Opens a connection to host:port using Environment.UserName for credentials.
        /// </summary>
        /// <param name="host">The host to which to connect.</param>
        /// <param name="port">The port on which to connect.</param>
        public Connection(string host, int port)
            : this(host, port, Environment.UserName)
        {
        }

        /// <summary>
        /// Open a connection to host:port using credentials to log in.
        /// </summary>
        /// <param name="host">The host to which to connect.</param>
        /// <param name="port">The port on which to connect.</param>
        /// <param name="credentials">The username:password string to use.</param>
        public Connection(string host, int port, string credentials)
            : base(host, port)
        {
            stream = GetStream();
            oBuffer = new byte[1 + credentials.Length];
            oBufferOffset = 0;
            write(credentials);
            stream.Write(oBuffer, 0, oBufferOffset);
            if (1 != stream.Read(oBuffer, 0, 1)) 
                throw new Exception("Access denied for credentials: " + credentials);
        }

        /// <summary>
        /// Waits for an incoming message from the kdb+ server.
        /// </summary>
        /// <returns>The message that was received.</returns>
        /// <see cref="IConnection.Listen()"/>
        public object Listen()
        {
            read(iBuffer = new byte[8]);
            oneway = iBuffer[0] == 1;
            iBufferOffset = 4;
            read(iBuffer = new byte[readInt() - 8]);
            if (iBuffer[0] == 128)
            {
                iBufferOffset = 1;
                throw new Exception(readString());
            }
            iBufferOffset = 0;
            return read();
        }

        /// <summary>
        /// Runs the given query string against the kdb+ server.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <returns>The result of the query.</returns>
        /// <see cref="IConnection.Query(string)"/>
        public object Query(string query)
        {
            return executeQuery(query.ToCharArray());
        }

        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameter x.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <returns>The result of the query.</returns>
        /// <see cref="IConnection.Query(string, object)"/>
        public object Query(string query, object x)
        {
            object[] message = {query.ToCharArray(), x};
            return executeQuery(message);
        }

        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameters x and y.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <returns>the result of the query.</returns>
        /// <see cref="IConnection.Query(string, object, object)"/>
        public object Query(string query, object x, object y)
        {
            object[] message = {query.ToCharArray(), x, y};
            return executeQuery(message);
        }

        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameters x, y, and z.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <param name="z">The parameter z.</param>
        /// <returns>The result of the query.</returns>
        /// <see cref="IConnection.Query(string, object, object, object)"/>
        public object Query(string query, object x, object y, object z)
        {
            object[] message = {query.ToCharArray(), x, y, z};
            return executeQuery(message);
        }

        /// <summary>
        /// Runs the given command string against the kdb+ server.
        /// </summary>
        /// <param name="command">The command string.</param>
        /// <see cref="IConnection.Run(string)"/>
        public void Run(string command)
        {
            write(0, command.ToCharArray());
        }

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameter x.
        /// </summary>
        /// <param name="command">The command string.</param>
        /// <param name="x">The parameter x.</param>
        /// <see cref="IConnection.Run(string, object)"/>
        public void Run(string command, object x)
        {
            object[] message = {command.ToCharArray(), x};
            write(0, message);
        }

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameters x, and y.
        /// </summary>
        /// <param name="command">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <see cref="IConnection.Run(string, object, object)"/>
        public void Run(string command, object x, object y)
        {
            object[] message = {command.ToCharArray(), x, y};
            write(0, message);
        }

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameters x, y, and z.
        /// </summary>
        /// <param name="command">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <param name="z">The parameter z.</param>
        /// <see cref="IConnection.Run(string, object, object, object)"/>
        public void Run(string command, object x, object y, object z)
        {
            object[] message = {command.ToCharArray(), x, y, z};
            write(0, message);
        }

        ///<summary>
        /// Closes the connection to the kdb+ service as part of the IDisposable pattern.
        ///</summary>
        ///<filterpriority>2</filterpriority>
        public void Dispose()
        {
            stream.Close();
        }

        private void write(bool x)
        {
            oBuffer[oBufferOffset++] = (byte) (x ? 1 : 0);
        }

        private void write(byte x)
        {
            oBuffer[oBufferOffset++] = x;
        }

        private void write(short h)
        {
            oBuffer[oBufferOffset++] = (byte) h;
            oBuffer[oBufferOffset++] = (byte) (h >> 8);
        }

        private void write(int i)
        {
            write((short) i);
            write((short) (i >> 16));
        }

        private void write(long j)
        {
            write((int) j);
            write((int) (j >> 32));
        }

        private void write(float e)
        {
            byte[] b = BitConverter.GetBytes(e);
            foreach (byte i in b) write(i);
        }

        private void write(double f)
        {
            write(BitConverter.DoubleToInt64Bits(f));
        }

        private void write(char c)
        {
            write((byte) c);
        }

        private void write(string s)
        {
            foreach (char i in s) write(i);
            oBuffer[oBufferOffset++] = 0;
        }

        private void write(Date d)
        {
            write(d.TheDate);
        }

        private void write(Minute u)
        {
            write(u.TheMinute);
        }

        private void write(Month m)
        {
            write(m.TheMonth);
        }

        private void write(Second v)
        {
            write(v.TheSeconds);
        }

        private void write(TimeSpan t)
        {
            write(Type.IsNull(t) ? Type.NullInteger : (int) (t.Ticks/10000));
        }

        private void write(DateTime z)
        {
            write(Type.IsNull(z) ? Type.NullFloat : (z.Ticks - Type.offset)/8.64e11);
        }

        private void write(object x)
        {
            int i = 0, messageLength, messageType = Type.TypeOf(x);
            write((byte)messageType);
            if (messageType < 0)
                switch (messageType)
                {
                    case -1:
                        write((bool)x);
                        return;
                    case -4:
                        write((byte)x);
                        return;
                    case -5:
                        write((short)x);
                        return;
                    case -6:
                        write((int)x);
                        return;
                    case -7:
                        write((long)x);
                        return;
                    case -8:
                        write((float)x);
                        return;
                    case -9:
                        write((double)x);
                        return;
                    case -10:
                        write((char)x);
                        return;
                    case -11:
                        write((string)x);
                        return;
                    case -13:
                        write((Month)x);
                        return;
                    case -17:
                        write((Minute)x);
                        return;
                    case -18:
                        write((Second)x);
                        return;
                    case -14:
                        write((Date)x);
                        return;
                    case -15:
                        write((DateTime)x);
                        return;
                    case -19:
                        write((TimeSpan)x);
                        return;
                }
            if (messageType == 99)
            {
                var r = (Dict)x;
                write(r.Keys);
                write(r.Values);
                return;
            }
            oBuffer[oBufferOffset++] = 0;
            if (messageType == 98)
            {
                var r = (Flip)x;
                oBuffer[oBufferOffset++] = 99;
                write(r.TheColumnNames);
                write(r.TheColumnValues);
                return;
            }
            write(messageLength = Type.Length(x));
            for (; i < messageLength; ++i)
                if (messageType == 0) write(((object[])x)[i]);
                else if (messageType == 1) write(((bool[])x)[i]);
                else if (messageType == 4) write(((byte[])x)[i]);
                else if (messageType == 5) write(((short[])x)[i]);
                else if (messageType == 6) write(((int[])x)[i]);
                else if (messageType == 7) write(((long[])x)[i]);
                else if (messageType == 8) write(((float[])x)[i]);
                else if (messageType == 9) write(((double[])x)[i]);
                else if (messageType == 10) write(((char[])x)[i]);
                else if (messageType == 15) write(((DateTime[])x)[i]);
                else if (messageType == 19) write(((TimeSpan[])x)[i]);
        }
        
        private void write(int i, object x)
        {
            int n = Type.ObjectSize(x) + 8;
            oBuffer = new byte[n];
            oBuffer[0] = 1;
            oBuffer[1] = (byte)i;
            oBufferOffset = 4;
            write(n);
            write(x);
            stream.Write(oBuffer, 0, n);
        }

        private bool readBool()
        {
            return 1 == iBuffer[iBufferOffset++];
        }

        private byte readByte()
        {
            return iBuffer[iBufferOffset++];
        }

        private short readShort()
        {
            int x = iBuffer[iBufferOffset++], y = iBuffer[iBufferOffset++];
            return (short)(oneway ? x & 0xff | y << 8 : x << 8 | y & 0xff);
        }

        private int readInt()
        {
            int x = readShort(), y = readShort();
            return oneway ? x & 0xffff | y << 16 : x << 16 | y & 0xffff;
        }

        private long readLong()
        {
            int x = readInt(), y = readInt();
            return oneway ? x & 0xffffffffL | (long)y << 32 : (long)x << 32 | y & 0xffffffffL;
        }

        private float readReal()
        {
            byte c;
            float e;
            if (!oneway)
            {
                c = iBuffer[iBufferOffset];
                iBuffer[iBufferOffset] = iBuffer[iBufferOffset + 3];
                iBuffer[iBufferOffset + 3] = c;
                c = iBuffer[iBufferOffset + 1];
                iBuffer[iBufferOffset + 1] = iBuffer[iBufferOffset + 2];
                iBuffer[iBufferOffset + 2] = c;
            }
            e = BitConverter.ToSingle(iBuffer, iBufferOffset);
            iBufferOffset += 4;
            return e;
        }

        private double readFloat()
        {
            return BitConverter.Int64BitsToDouble(readLong());
        }

        private char readChar()
        {
            return (char)(iBuffer[iBufferOffset++] & 0xff);
        }

        private string readString()
        {
            int i = 0, k = iBufferOffset;
            for (; iBuffer[k] != 0; ) ++k;
            var s = new char[k - iBufferOffset];
            for (; iBufferOffset < k; ) s[i++] = (char)(0xFF & iBuffer[iBufferOffset++]);
            ++iBufferOffset;
            return new string(s);
        }

        private Date readDate()
        {
            return new Date(readInt());
        }

        private Minute readMinute()
        {
            return new Minute(readInt());
        }

        private Month readMonth()
        {
            return new Month(readInt());
        }

        private Second readSecond()
        {
            return new Second(readInt());
        }

        private TimeSpan readTimeSpan()
        {
            int i = readInt();
            return new TimeSpan(Type.IsNull(i) ? Type.NullLong : 10000L * i);
        }

        private DateTime readDateTime()
        {
            double f = readFloat();
            return new DateTime(Type.IsNull(f) ? 0 : 10000*(long) (.5 + 8.64e7*f) + Type.offset);
        }

        private object read()
        {
            int i = 0, messageLength, messageType = (sbyte) iBuffer[iBufferOffset++];
            if (messageType < 0)
                switch (messageType)
                {
                    case -1:
                        return readBool();
                    case -4:
                        return iBuffer[iBufferOffset++];
                    case -5:
                        return readShort();
                    case -6:
                        return readInt();
                    case -7:
                        return readLong();
                    case -8:
                        return readReal();
                    case -9:
                        return readFloat();
                    case -10:
                        return readChar();
                    case -11:
                        return readString();
                    case -13:
                        return readMonth();
                    case -14:
                        return readDate();
                    case -15:
                        return readDateTime();
                    case -17:
                        return readMinute();
                    case -18:
                        return readSecond();
                    case -19:
                        return readTimeSpan();
                }
            if (messageType > 99)
            {
                if (messageType == 101 && iBuffer[iBufferOffset++] == 0) return null;
                throw new Exception("func");
            }
            if (messageType == 99) 
                return new Dict(read(), read());
            iBufferOffset++;
            if (messageType == 98) 
                return new Flip((Dict) read());
            messageLength = readInt();
            switch (messageType)
            {
                case 0:
                    var L = new object[messageLength];
                    for (; i < messageLength; i++) L[i] = read();
                    return L;
                case 1:
                    var B = new bool[messageLength];
                    for (; i < messageLength; i++) B[i] = readBool();
                    return B;
                case 4:
                    var G = new byte[messageLength];
                    for (; i < messageLength; i++) G[i] = readByte();
                    return G;
                case 5:
                    var H = new short[messageLength];
                    for (; i < messageLength; i++) H[i] = readShort();
                    return H;
                case 6:
                    var I = new int[messageLength];
                    for (; i < messageLength; i++) I[i] = readInt();
                    return I;
                case 7:
                    var J = new long[messageLength];
                    for (; i < messageLength; i++) J[i] = readLong();
                    return J;
                case 8:
                    var E = new float[messageLength];
                    for (; i < messageLength; i++) E[i] = readReal();
                    return E;
                case 9:
                    var F = new double[messageLength];
                    for (; i < messageLength; i++) F[i] = readFloat();
                    return F;
                case 10:
                    var C = new char[messageLength];
                    for (; i < messageLength; i++) C[i] = readChar();
                    return C;
                case 11:
                    var S = new String[messageLength];
                    for (; i < messageLength; i++) S[i] = readString();
                    return S;
                case 13:
                    var M = new Month[messageLength];
                    for (; i < messageLength; i++) M[i] = readMonth();
                    return M;
                case 14:
                    var D = new Date[messageLength];
                    for (; i < messageLength; i++) D[i] = readDate();
                    return D;
                case 17:
                    var U = new Minute[messageLength];
                    for (; i < messageLength; i++) U[i] = readMinute();
                    return U;
                case 15:
                    var Z = new DateTime[messageLength];
                    for (; i < messageLength; i++) Z[i] = readDateTime();
                    return Z;
                case 18:
                    var V = new Second[messageLength];
                    for (; i < messageLength; i++) V[i] = readSecond();
                    return V;
                case 19:
                    var T = new TimeSpan[messageLength];
                    for (; i < messageLength; i++) T[i] = readTimeSpan();
                    return T;
            }
            return null;
        }

        private void read(byte[] b)
        {
            int i = 0, n = b.Length;
            for (; i < n;) i += stream.Read(b, i, n - i);
        }

        private object executeQuery(object x)
        {
            write(1, x);
            return Listen();
        }

        private byte[] iBuffer, oBuffer;
        private int iBufferOffset, oBufferOffset;
        private bool oneway;
        private readonly Stream stream;
    }
}
