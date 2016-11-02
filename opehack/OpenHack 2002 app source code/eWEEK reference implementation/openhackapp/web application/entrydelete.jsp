<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>Confirm Entry Deletion</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	Calendar CurrentTimeStamp = Calendar.getInstance();
	Calendar EntryDeadline = Calendar.getInstance();
		EntryDeadline.set(2002,05,30,23,59,59);		// year, month, hour, minute and second values are 0-based; day value is 1-based
	boolean bPastEntryDeadline = false;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validProductIdPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String userid = (String) session.getAttribute("Current User ID");
	String companyname;
	String productname;
	String version;
	String recordcreationtimestamp;

	// initialize variables
	String validProductIDRegExp = "[0-9]+";
	try {
		validProductIdPattern = compiler.compile(validProductIDRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// determine if entry deadline has passed
	if (CurrentTimeStamp.after(EntryDeadline)) {
		bPastEntryDeadline = true;
	}

	// check if site is now read-only for normal users
	if (bPastEntryDeadline) {
		%>
		<body>
		<%@ include file="include/header.jsp" %>
		<table width="610">
			<tr>
				<td>
					<h3>Deadline Passed</h3>
					<p>We're sorry, the deadline for submission changes for the eWEEK eXcellence Awards program has passed.</p>
					<p>Return to <a href="/index.jsp">site homepage</a></p>
				</td>
			</tr>
		</table>
		<%@ include file="include/footer.jsp" %>
		</body>
		</html>
		<%
		return;
	}

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : request.getParameter("submit").trim();
	// get parameters passed from entrylist.jsp or self
	String productid = request.getParameter("productid") == null ? "" : request.getParameter("productid").trim();

	%>
	<% // open the database connection %>
	<%@ include file="include/open_db.jsp" %>
	<%

	// check input parameters
	MissingInput = false;
	// productid CANNOT be blank: pass of regular expression check guarantees non-blankness, but having it explicit is more clear
	if ( !(!productid.equals("") && matcher.matches(productid, validProductIdPattern)) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
	if ( !(submit.equals("") || submit.equals("Cancel") || submit.equals("Delete entry")) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
	if (MissingInput) {
		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// do a security check on the passed productid
	query = "select userid from users_companies, products " +
				"where users_companies.userid = '" + SQLize(userid) +"' " +
					"and users_companies.companyid = products.companyid " +
					"and products.id = " + SQLize(productid);
	rs = stmt.executeQuery(query);
	recordfound = rs.next();
	if (!recordfound) {
		// probable security violation
		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<%
		request.setAttribute ("msg", "ERROR: Product not found or not registered by you. Please contact eWEEK for assistance.");
		%>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// implement cancel action
	if (submit.equals("Cancel")) {
		request.setAttribute ("msg", "Action cancelled.");
		%>
		<jsp:forward page="entrylist.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// implement delete action
	if (submit.equals("Delete entry")) {
		query = "delete from products " +
					"where id = " + SQLize(productid);
		stmt.executeUpdate(query);
		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<%
		request.setAttribute ("msg", "Entry deleted.");
		%>
		<jsp:forward page="entrylist.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h3>Confirm Entry Deletion</h3>

			<table cellpadding="5">

				<tr>
					<td class="reverse">Company Name</td>
					<td class="reverse">Product or Service Name</td>
					<td class="reverse">Version</td>
					<td class="reverse">Registration Timestamp (EST)</td>
				</tr>

				<%
				// get entry information
				query = "select companies.companyname, products.id, products.productname, products.version, products.recordcreationtimestamp " +
							"from products, users_companies, companies " +
							"where users_companies.userid = '" + SQLize(userid) + "' " +
								"and users_companies.companyid = products.companyid " +
								"and products.id = " + SQLize(productid) + " " +
								"and users_companies.companyid = companies.id " +
							" order by products.recordcreationtimestamp";
				rs = stmt.executeQuery(query);
				recordfound = rs.next();
				if (recordfound) {
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
					</tr>
					<%
				}
				%>

			</table>

			<br>
			If you would like to permanently delete this entry, then click the "Delete entry" button.<br>
			<br>
			If you would like to cancel this action, click the "Cancel" button to return to the entry list.<br>
			<br>
			<form action="entrydelete.jsp" method="post">
				<input name="submit" type="submit" value="Delete entry">
				<input name="submit" type="submit" value="Cancel">
				<input name="productid" type="hidden" value="<%=productid%>">
			</form>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

<% // close the database %>
<%@ include file="include/close_db.jsp" %>

</html>

<%@ include file="include/catch.inc" %>

