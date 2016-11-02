

<%
	// close database connection
	try {
		if (rs != null) rs.close();
	} catch (SQLException ignore) {
		// can ignore
	}
	try {
		if (stmt != null) stmt.close();
	} catch (SQLException ignore) {
		// can ignore
	}

	try {
		if (conn != null) conn.close();
	} catch (SQLException ignore) {
		// can ignore
	}
%>
