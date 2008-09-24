namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ second value.
    /// </summary>
    public class Second
    {
        private int seconds;

        /// <summary>
        /// Constructs based on the given value.
        /// </summary>
        /// <param name="s">A value in seconds.</param>
        public Second(int s)
        {
            seconds = s;
        }

        /// <summary>
        /// Gets and sets the seconds value.
        /// </summary>
        public int TheSeconds
        {
            get { return seconds; }
            set { seconds = value; }
        }

        /// <summary>
        /// Converts to a string.
        /// </summary>
        /// <returns>The string representation of this value.</returns>
        public override string ToString()
        {
            return seconds == Type.NullInteger 
                ? "" 
                : new Minute(seconds/60).ToString() + ':' + Type.ToTwoDigitString(seconds%60);
        }
    }
}