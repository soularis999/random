<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>List of Companies</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%
	// declare variables
	String companyid;
	String companyname;
	String numentries;
	String recordcreationtimestamp;
%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h3>View or Edit Company Registrations</h3>

			<table cellpadding="5">

				<tr>
					<td class="reverse">Name</td>
					<td class="reverse">Number of Entries</td>
					<td class="reverse">Registration Timestamp (EST)</td>
					<td></td>
					<td></td>
				</tr>

				<% // open the database %>
				<%@ include file="include/open_db.jsp" %>

				<%
				// now we get the list of companies registered by this user to date
				query = "select companies.id, companies.companyname, companies.recordcreationtimestamp, count(products.id) " +
							"from users_companies, companies left join products on companies.id = products.companyid " +
							"where users_companies.userid = '" + SQLize((String) session.getAttribute("Current User ID")) + "' " +
								"and users_companies.companyid = companies.id " +
							"group by companies.id, companies.companyname, companies.recordcreationtimestamp " +
							"order by recordcreationtimestamp";
				rs = stmt.executeQuery(query);
				recordfound = false;
				while (rs.next()) {
					recordfound = true;
					companyid = rs.getString(1);
					companyname = rs.getString(2);
					recordcreationtimestamp = rs.getString(3);
					numentries = rs.getString(4)==null ? "0" : rs.getString(4);
					%>
					<tr>
						<td><b><%=HTMLize(companyname)%></b></td>
						<td><%=numentries%></td>
						<td><%=recordcreationtimestamp%></td>
						<td><a href="companycreateedit.jsp?companyid=<%=companyid%>"><font size="-1">Edit company or payment details</font></a></td>
						<td><a href="entrycreateedit.jsp?companyid=<%=companyid%>"><font size="-1">Submit a new entry for this company</font></a></td>
					</tr>
					<%
				}
				if (!recordfound) {
					%>
					<tr>
						<td colspan="5">
							<b>No companies submitted.</b><br>
							<br>
							Return to <a href="index.jsp">home page</a>.
						</td>
					</tr>
					<%
				}
				%>

				<% // close the database %>
				<%@ include file="include/close_db.jsp" %>

			</table>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

