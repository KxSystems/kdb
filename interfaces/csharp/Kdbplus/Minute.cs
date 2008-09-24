namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ minute value.
    /// </summary>
    public class Minute
    {
        private int theMinute;

        /// <summary>
        /// Constructs based on the given int value.
        /// </summary>
        /// <param name="m">The months.</param>
        public Minute(int m)
        {
            theMinute = m;
        }

        /// <summary>
        /// Gets and sets the minute value.
        /// </summary>
        public int TheMinute
        {
            get { return theMinute; }
            set { theMinute = value; }
        }

        /// <summary>
        /// Converts to a string.
        /// </summary>
        /// <returns>The string representation of this value.</returns>
        public override string ToString()
        {
            return theMinute == Type.NullInteger ? "" : Type.ToTwoDigitString(theMinute/60) + ":" + Type.ToTwoDigitString(theMinute%60);
        }
    }
}