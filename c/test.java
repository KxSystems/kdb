// q -p 5001   use q/c/jdbc.jar
import java.sql.*;
public class test{public static void main(String args[]){
 try{Class.forName("jdbc");  //loads the driver 
  Connection h = DriverManager.getConnection("jdbc:q:localhost:5001","","");
  Statement e = h.createStatement();

  e.executeUpdate("create table t(x int,f float,s varchar(0),d date,t time,z timestamp)");
  //e.execute("insert into t values(9,2.3,'aaa',date'2000-01-02',time'12:34:56',timestamp'2000-01-02 12:34:56)");

  PreparedStatement p = h.prepareStatement("q){`t insert 0N!a::x}"); //insert into t values(?,?,?,?,?,?)");
  p.setInt(1,2);p.setDouble(2,2.3);p.setString(3,"qwe");
  p.setDate(4,Date.valueOf("2000-01-02"));p.setTime(5,Time.valueOf("12:34:56"));
  p.setTimestamp(6,Timestamp.valueOf("2000-01-02 12:34:56"));
  p.executeUpdate();

  ResultSet r = e.executeQuery("select * from t");
  ResultSetMetaData m=r.getMetaData();
  int n=m.getColumnCount(); //for(int i=0;i<n;)c.O(m.getColumnName(++i));
  while(r.next())for(int i=0;i<n;)c.O(r.getObject(++i));

  h.close();}
  catch(Exception e){System.out.println(e.getMessage());}
 
  } }
