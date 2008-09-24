using Console = System.Console;
using Kdbplus;

namespace Example
{
    class Program
    {
        public static void Main(string[] args)
        {
            IConnection connection = new Connection("localhost", 5001);
            using (connection)
            {
                connection.Run("\\l trade.q");
                var t = Type.ToFlip(connection.Query("select sum price by sym from trade"));
                Console.WriteLine("cols: " + Type.Length(t.TheColumnNames));
                Console.WriteLine("rows: " + Type.Length(t.TheColumnValues[0]));
                var s = Console.ReadLine();
            }
        }
    }
}

