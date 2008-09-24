namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ flip value.
    /// </summary>
    public class Flip
    {
        private string[] theColumnNames;
        private object[] theColumnValues;

        /// <summary>
        /// Constructs based on the given dict value.
        /// </summary>
        /// <param name="dict"></param>
        public Flip(Dict dict)
        {
            theColumnNames = (string[]) dict.Keys;
            theColumnValues = (object[]) dict.Values;
        }

        /// <summary>
        /// Gets and sets the column names.
        /// </summary>
        public string[] TheColumnNames
        {
            get { return theColumnNames; }
            set { theColumnNames = value; }
        }

        /// <summary>
        /// Gets and sets the column values.
        /// </summary>
        public object[] TheColumnValues
        {
            get { return theColumnValues; }
            set { theColumnValues = value; }
        }

        /// <summary>
        /// Gets the column for the given string key.
        /// </summary>
        /// <param name="s">The column name.</param>
        /// <returns>The column values.</returns>
        public object At(string s)
        {
            int i;
            for (i = 0; i < theColumnNames.Length && !theColumnNames[i].Equals(s); ) 
                ++i;
            return theColumnValues[i];
        }
    }
}