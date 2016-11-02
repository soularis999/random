<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>

<%
	// declare database variables
	Driver driver = null;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String query;
	boolean recordfound;

	// initialize variables
	driver = (Driver)Class.forName(getServletContext().getInitParameter("dbDriver")).newInstance();
	conn = DriverManager.getConnection(getServletContext().getInitParameter("dbServer"), getServletContext().getInitParameter("dbLogin"), getServletContext().getInitParameter("dbPassword"));
	conn.setTransactionIsolation (Connection.TRANSACTION_READ_COMMITTED);
	conn.setAutoCommit (false);
	stmt = conn.createStatement();
%>
