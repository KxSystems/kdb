using System;

namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ date value.
    /// </summary>
    public class Date
    {
        private int date;

        /// <summary>
        /// Constructs based on the given int value.
        /// </summary>
        /// <param name="d">The date.</param>
        public Date(int d)
        {
            date = d;
        }

        /// <summary>
        /// Constructs based on the given long value. Essentially,
        /// 0L is an Null date, otherwise we build based on
        /// l/8.64e11 - 730119.
        /// </summary>
        /// <param name="l">The long to base this value on.</param>
        public Date(long l)
        {
            date = l == 0L ? Type.NullInteger : (int) (l/(long) 8.64e11) - 730119;
        }

        /// <summary>
        /// Constructs based on the given datetime.
        /// </summary>
        /// <param name="z">The datetime to base this value on.</param>
        public Date(DateTime z) : this(z.Ticks)
        {
        }

        /// <summary>
        /// Gets and sets the date value.
        /// </summary>
        public int TheDate
        {
            get { return date; }
            set { date = value; }
        }

        /// <summary>
        /// Converts to a string.
        /// </summary>
        /// <returns>The string representation of this value.</returns>
        public override string ToString()
        {
            var d = new DateTime(date == Type.NullInteger ? 0L : (long) 8.64e11*date + Type.offset);
            return date == Type.NullInteger ? "" : d.ToString("d");
        }
    }
}