using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Kdbplus
{
    /// <summary>
    /// This class is a dumping ground for static methods and values from 
    /// the legacy implementation.
    /// </summary>
    public class Type
    {
        /// <summary>
        /// This is the kdb+ null integer value.
        /// </summary>
        public static int NullInteger = Int32.MinValue;

        /// <summary>
        /// This is the kdb+ null long value.
        /// </summary>
        public static long NullLong = Int64.MinValue;

        /// <summary>
        /// This is the kdb+ null float value.
        /// </summary>
        public static double NullFloat = Double.NaN;

        /// <summary>
        ///  Gets the appropriate null value for the given type code.
        /// </summary>
        /// <param name="code">The kdb+ type code.</param>
        /// <returns>The appropriate null value.</returns>
        public static object GetNull(char code)
        {
            return nullValues[" b  xhijefcs mdz uvt".IndexOf(code)];
        }

        /// <summary>
        /// What is the kdb+ length of the string?
        /// </summary>
        /// <param name="s">The string to compute the length of.</param>
        /// <returns>The length of the string.</returns>
        public static int StringLength(string s)
        {
            var i = s.IndexOf('\0');
            return -1 < i ? i : s.Length;
        }

        /// <summary>
        /// Formats an integer to fit in a 2 digit string
        /// </summary>
        /// <param name="i">The integer to format.</param>
        /// <returns>The 2 digit formatted string.</returns>
        public static string ToTwoDigitString(int i)
        {
            return String.Format("{0:00}", i);
        }

        /// <summary>
        /// Check whether this is a null value.
        /// </summary>
        /// <param name="x">The object to check.</param>
        /// <returns>Whether this is null or not.</returns>
        public static bool IsNull(object x)
        {
            var type = -Type.TypeOf(x);
            return type > 4 && x.Equals(nullValues[type]);
        }

        /// <summary>
        /// Converts an object to a Flip.
        /// </summary>
        /// <param name="obj">The object from which to build the Flip.</param>
        /// <returns>The flipped object.</returns>
        public static Flip ToFlip(object obj)
        {
            if (TypeOf(obj) == 98) 
                return (Flip) obj;
            var d = (Dict) obj;
            Flip a = (Flip) d.Keys, b = (Flip) d.Values;
            var m = Type.Length(a.TheColumnNames);
            var n = Type.Length(b.TheColumnNames);
            var x = new string[m + n];
            Array.Copy(a.TheColumnNames, 0, x, 0, m);
            Array.Copy(b.TheColumnNames, 0, x, m, n);
            var y = new object[m + n];
            Array.Copy(a.TheColumnValues, 0, y, 0, m);
            Array.Copy(b.TheColumnValues, 0, y, m, n);
            return new Flip(new Dict(x, y));
        }

        /// <summary>
        /// Check the type of the given kdb+ value.
        /// </summary>
        /// <param name="obj">The object to type check.</param>
        /// <returns>The kdb+ type for the object.</returns>
        public static int TypeOf(object obj)
        {
            return obj is bool ? -1
                : obj is byte ? -4
                : obj is short ? -5
                : obj is int ? -6
                : obj is long ? -7
                : obj is float ? -8
                : obj is double ? -9
                : obj is char ? -10
                : obj is string ? -11
                : obj is Month ? -13
                : obj is Date ? -14
                : obj is DateTime ? -15
                : obj is Minute ? -17
                : obj is Second ? -18
                : obj is TimeSpan ? -19
                : obj is bool[] ? 1
                : obj is byte[] ? 4
                : obj is short[] ? 5
                : obj is int []? 6 
                : obj is long[] ? 7
                : obj is float[] ? 8
                : obj is double [] ? 9
                : obj is char[] ? 10
                : obj is DateTime[] ? 15
                : obj is TimeSpan[] ? 19
                : obj is Flip ? 98
                : obj is Dict ? 99
                : 0;
        }

        /// <summary>
        /// Compute the length of the given object.
        /// </summary>
        /// <param name="obj">The kdb+ object of which to calculate the length.</param>
        /// <returns>The length.</returns>
        public static int Length(object obj)
        {
            return obj is Dict ? Length(((Dict) obj).Keys) : obj is Flip ? Length(((Flip) obj).TheColumnValues[0]) : ((Array) obj).Length;
        }

        /// <summary>
        /// Computes the object Length.
        /// </summary>
        /// <param name="x">The object of which to compute the Length.</param>
        /// <returns>The Length of the object.</returns>
        public static int ObjectSize(object x)
        {
            var type = Type.TypeOf(x);
            if (type == 99) 
                return 1 + ObjectSize(((Dict) x).Keys) + ObjectSize(((Dict) x).Values);
            if (type == 98) 
                return 3 + ObjectSize(((Flip) x).TheColumnNames) + ObjectSize(((Flip) x).TheColumnValues);
            if (type < 0) 
                return type == -11 ? 2 + Type.StringLength((string) x) : 1 + basesize[-type];
            var j = 6;
            var length = Type.Length(x);
            if (type == 0) 
                for (var i = 0; i < length; ++i) 
                    j += ObjectSize(((object[]) x)[i]);
            else j += length*basesize[type];
            return j;
        }

        /// <summary>
        /// Get the i'th value in the given kdb+ value.
        /// </summary>
        /// <param name="x">Some kdb+ value.</param>
        /// <param name="i">The position At which to index.</param>
        /// <returns>The value At x[i]</returns>
        public static object At(object x, int i)
        {
            var obj = ((Array) x).GetValue(i);
            return IsNull(obj) ? null : obj;
        }

        /// <summary>
        /// User for date offset calculations in kdb+.
        /// </summary>
        public static long offset = (long) 8.64e11*730119;

        private static readonly object[] nullValues = 
        {
              null, false, null, null, (byte) 0, Int16.MinValue, NullInteger, NullLong, 
              (Single) NullFloat, NullFloat, ' ', "", null, new Month(NullInteger), new Date(NullInteger), 
              new DateTime(0), null, new Minute(NullInteger),new Second(NullInteger), 
              new TimeSpan(NullLong) 
        };

        private static readonly int[] basesize = { 0, 1, 0, 0, 1, 2, 4, 8, 4, 8, 1, 0, 0, 4, 4, 8, 4, 4, 4, 4 };
      
    }
}
