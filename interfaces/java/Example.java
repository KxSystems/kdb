import com.kx.Connection;
import com.kx.ConnectionImpl;
import com.kx.Flip;
import static com.kx.Type.toFlip;

/**
 * Connect to a kdb+ process at localhost:5001.
 * Load the trade.q file and query it.
 * 
 * @see <a href="https://code.kx.com/trac/wiki/Cookbook/InterfacingWithJava">Interfacing With Java at code.kx</a> 
 * @author tech@kx.com
 */
public class Example {
	public static void main(String[] args) {
		try { 
			Connection server = new ConnectionImpl("", 5001);
			server.run("\\l trade.q");
			Flip t = toFlip(server.query("select sum size by sym from trade"));
			
			System.out.println("Columns are:");
			for (String column : t.getColumnNames())
				System.out.print(column + " ");
			System.out.println("\n");
			
			System.out.println("Rows are:");
			Object[] columns = t.getColumnValues();
			int rows = ((Object[]) columns[0]).length;
			for (int i = 0; i < rows; ++i) 
					System.out.println(((Object[])columns[0])[i] + "  " + ((int[])columns[1])[i]);
			
			server.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
