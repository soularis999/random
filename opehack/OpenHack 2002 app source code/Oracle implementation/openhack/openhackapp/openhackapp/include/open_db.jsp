<%@ page import="oracle.sql.*"  %> 
<%@ page import="oracle.jdbc.driver.*"  %> 
<%@ page import="oracle.jdbc.OracleConnection"  %> 
<%@ page import="javax.sql.*"  %> 
<%@ page import="java.sql.*"  %> 
<%@ page import="javax.naming.*"  %> 

<%
  
	// declare database variables
	Driver driver = null;
//	Connection conn = null;
	java.sql.Statement stmt = null;
	ResultSet rs = null;
	String query;
	boolean recordfound;
	
  InitialContext context = null;
  DataSource jdbcURL = null;
  OracleConnection conn = null;	

  // initialize variables
  ServletContext sc = session.getServletContext(); 
  String dbDriver = sc.getInitParameter("dbDriver");
  String dbServer = sc.getInitParameter("dbServer");
  String dbLogin = sc.getInitParameter("dbLogin");
  String dbPassword = sc.getInitParameter("dbPassword");
  
  //System.out.println("dbDriver: " + dbDriver);
  //System.out.println("dbServer: " + dbServer);
  //System.out.println("dbLogin: " + dbLogin);
  //System.out.println("dbPassword: " + dbPassword);

  //driver = (Driver)Class.forName(dbDriver).newInstance();
  //conn = DriverManager.getConnection(dbServer, dbLogin, dbPassword);
  //conn.setTransactionIsolation (Connection.TRANSACTION_READ_COMMITTED);
  //conn.setAutoCommit (false);
  //stmt = conn.createStatement();	

      context = new InitialContext();        
      jdbcURL = (DataSource)context.lookup("jdbc/OpenHackDS");    
      conn = (OracleConnection)jdbcURL.getConnection(dbLogin, dbPassword);
      stmt = conn.createStatement();

    
%>
