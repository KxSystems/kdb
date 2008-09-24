namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ month value.
    /// </summary>
    public class Month
    {
        private int theMonth;

        /// <summary>
        /// Constructs based on the given int value.
        /// </summary>
        /// <param name="m"></param>
        public Month(int m)
        {
            theMonth = m;
        }

        /// <summary>
        /// Gets and sets the month value.
        /// </summary>
        public int TheMonth
        {
            get { return theMonth; }
            set { theMonth = value; }
        }

        /// <summary>
        /// Converts to a string.
        /// </summary>
        /// <returns>The string representation of this value.</returns>
        public override string ToString()
        {
            int m = 24000 + theMonth, y = m/12;
            return theMonth == Type.NullInteger ? "" : Type.ToTwoDigitString(y/100) + Type.ToTwoDigitString(y%100) + "-" + Type.ToTwoDigitString(1 + m%12);
        }
    }
}