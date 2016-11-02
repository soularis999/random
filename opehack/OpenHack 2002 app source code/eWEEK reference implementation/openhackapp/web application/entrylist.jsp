<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>List of Entries</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%
	// define local variables
	String userid = (String) session.getAttribute("Current User ID");
	String productid;
	String companyname;
	String productname;
	String version;
	String recordcreationtimestamp;
%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h3>View, Edit or Delete Entries</h3>

			<table cellpadding="5">

				<tr>
					<td class="reverse">Company Name</td>
					<td class="reverse">Product or Service Name</td>
					<td class="reverse">Version</td>
					<td class="reverse">Registration Timestamp (EST)</td>
					<td></td>
					<td></td>
					<td></td>
				</tr>

				<% // open the database %>
				<%@ include file="include/open_db.jsp" %>

				<%
				// now we get the list of products/services registered by this user's company to date
				query = "select companies.companyname, products.id, products.productname, products.version, products.recordcreationtimestamp " +
							"from products, users_companies, companies " +
							"where users_companies.userid = '" + SQLize(userid) + "' " +
								"and users_companies.companyid = products.companyid " +
								"and users_companies.companyid = companies.id " +
							" order by products.recordcreationtimestamp";
				rs = stmt.executeQuery(query);
				recordfound = false;
				while (rs.next()) {
					recordfound = true;
					companyname = rs.getString(1);
					productid = rs.getString(2);
					productname = rs.getString(3);
					version = rs.getString(4);
					recordcreationtimestamp = rs.getString(5);
					%>
					<tr>
						<td><b><%=HTMLize(companyname)%></b></td>
						<td><b><%=HTMLize(productname)%></b></td>
						<td><%=HTMLize(version)%></td>
						<td><%=HTMLize(recordcreationtimestamp)%></td>
						<td><a href="entryview.jsp?productid=<%=productid%>"><font size="-1">View Entry Details</font></a></td>
						<td><a href="entrycreateedit.jsp?productid=<%=productid%>"><font size="-1">Edit Entry</font></a></td>
						<td><a href="entrydelete.jsp?productid=<%=productid%>"><font size="-1">Delete Entry</font></a></td>
					</tr>
					<%
				}
				if (!recordfound) {
					%>
					<tr>
						<td colspan="7">
							<b>No entries submitted.</b><br>
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

