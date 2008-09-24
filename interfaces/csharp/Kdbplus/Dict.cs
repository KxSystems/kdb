namespace Kdbplus
{
    /// <summary>
    /// This is a kdb+ dict value.
    /// </summary>
    public class Dict
    {
        private object keys;
        private object values;

        /// <summary>
        /// Constructs based on the given keys and values.
        /// </summary>
        /// <param name="keys">The keys for this dict.</param>
        /// <param name="values">The values for this dict.</param>
        public Dict(object keys, object values)
        {
            this.keys = keys;
            this.values = values;
        }

        /// <summary>
        /// Gets and sets the keys.
        /// </summary>
        public object Keys
        {
            get { return keys; }
            set { keys = value; }
        }

        /// <summary>
        /// Gets and sets the values.
        /// </summary>
        public object Values
        {
            get { return values; }
            set { values = value; }
        }
    }
}