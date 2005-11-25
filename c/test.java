// q -p 5001   use q/c/jdbc.jar
import java.sql.*;
public class test{public static void main(String args[]){
 java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("GMT"));
 try{Class.forName("jdbc");  //loads the driver 
  Connection c = DriverManager.getConnection("jdbc:q:localhost:5001","","");
  Statement e = c.createStatement();
  e.execute("q)t:([]x:();f:();s:();d:();t:())"); //create table t(x int,f float,s varchar,d date,t time,z timestamp)");
  e.execute("q)`t insert(2;2.3;`qwe;2000.01.01;12:34:56.789)");
  PreparedStatement p = c.prepareStatement("q){`t insert x}"); //insert into t values(?,?,?,?,?,?)");
  p.setInt(1,2);p.setDouble(2,2.3);p.setString(3,"asd");
  p.setDate(4,Date.valueOf("2000-01-01"));p.setTime(5,Time.valueOf("12:34:56"));
  p.execute();
  ResultSet r = e.executeQuery("q)t"); // select * from t
  ResultSetMetaData m= r.getMetaData();int n=m.getColumnCount();
  for(int i=0;i<n;)System.out.println(m.getColumnName(++i));
 // while(r.next())for(int i=0;i<n;)System.out.println(r.getObject(++i));
  c.close();}catch(Exception e){System.out.println(e.getMessage());}}}