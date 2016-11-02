<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>eWEEK Openhack 4</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<% // open the database connection %>
<%@ include file="include/open_db.jsp" %>

<%
	// define local variables
	Calendar CurrentTimeStamp = Calendar.getInstance();
	Calendar EntryDeadline = Calendar.getInstance();
		EntryDeadline.set(2002,11,01,23,59,59);		// year, month, hour, minute and second values are 0-based; day value is 1-based
	boolean bPastEntryDeadline = false;
	boolean bLoggedIn = false;
	String userid = "";
	int iNumCompaniesRegistered = 0;
	int iNumEntries = 0;
	String companyid = "";

	// determine if entry deadline has passed
	if (CurrentTimeStamp.after(EntryDeadline)) {
		bPastEntryDeadline = true;
	}

	// get user statistics
	bLoggedIn = session.getAttribute("Login Passed") == null ? false : true;
	if (bLoggedIn) {
		userid = (String) session.getAttribute("Current User ID");
		// see how many companies the person has registered
		query = "select count(companyid) from users_companies where userid = '" + SQLize(userid) + "'";
		rs = stmt.executeQuery(query);
		while (rs.next()) {
			iNumCompaniesRegistered = rs.getInt(1);
		}
		// see how many entries the person has registered in total
		query = "select count(products.id) from products, users_companies " +
					"where products.companyid = users_companies.companyid " +
						"and users_companies.userid = '" + SQLize(userid) + "'";
		rs = stmt.executeQuery(query);
		while (rs.next()) {
			iNumEntries = rs.getInt(1);
		}
	}
%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>
			<%
			if (bPastEntryDeadline) {
				%>
				<p align="center"><b>eWEEK Openhack 4 has finished.</b></p>
				<%
			}
			else {
				%>
				<p align="center"><b>eWEEK Openhack 4 is currently in progress.</b></p>
				<%
			}
			%>
		</td>
	</tr>
	<tr>
		<td align="center">
			<br>
			<%@ include file="include/display_error_msg.jsp" %>
		</td>
	</tr>
</table>

<table width="610" cellspacing="20">

	<tr>
		<td width="70%" valign="top">
			<h2 align="center">eWEEK eXcellence Awards</h2>
			<p>
				eWEEK Openhack is an online security test. Openhack 4 is based on the 
				actual code from eWEEK's eXcellence Awards Web site.
			</p>
			<p>
				In the actual eXcellence Awards process, you are asked for credit card details
				to cover the entry fee. For Openhack, do <b>not</b> enter a real credit card number!
				The site will accept any number used.
			</p>
		</td>
		<td width="30%" align="center" valign="top">
			<div align="center"><a href="/index.jsp"><img src="images/EWEA2_small.jpg" width="168" height="107" alt="eWEEK eXcellence Awards logo" border="0"></a></div>
			<table>
				<tr>
					<td colspan="2" align="center" class="reverse">Site News</td>
				</tr>
				<tr>
					<td colspan="2" align="center" class="small">
						last updated <a class="small" href="news.jsp">Feb. 26, 2002</a><br>
						<br>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" class="reverse">Your Status</td>
				</tr>
				<%
				if (!bLoggedIn) {
					%>
					<tr>
						<td colspan="2" align="center" class="small">Not logged in.</td>
					</tr>
					<%
				}
				else {
					%>
					<tr>
						<td align="right" class="small">Account:</td>
						<td class="small"><b>Created</b></td>
					</tr>
					<tr>
						<td align="right" class="small">Entry fee:</td>
						<td class="small"><b><% out.write(iNumCompaniesRegistered==0 ? "Not paid" : "Paid"); %></b></td>
					</tr>
					<tr>
						<td align="right" class="small">Total entries:</td>
						<td class="small"><b><%=iNumEntries%></b></td>
					</tr>
					<tr>
						<td colspan="2" align="center" class="small">
							<br>
							<b><%=userid%></b> is logged in.<br>
						</td>
					</tr>
					<%
				}
				%>
			</table>
			<p class="small">
				<a class="small" href="entryformsample.jsp">Sample entry form</a><br>
				<a class="small" href="http://www.eweek.com/article/0,3658,s=702&a=23530,00.asp">See the 2001 winners of the real eWEEK eXcellence Awards</a>
			</p>
			<%
			if (!bLoggedIn) {
				%>
				<p class="small">
					<%
					if (!bPastEntryDeadline) {
						%>
						Step 1 of 3: <a class="small" href="accountcreateedit.jsp"><b>Create an account</b></a>
						or <a class="small" href="login.jsp"><b>Log in</b></a>
						<%
					}
					else {
						%>
						<a class="small" href="accountcreateedit.jsp"><b>Create an account</b></a>
						or <a class="small" href="login.jsp"><b>Log in</b></a>
						<%
					}
					%>
				</p>
				<p class="small"><a class="small" href="accountdetailsmail.jsp"><b>Forgot your user ID or password?</b></a></p>
				<%
			}
			else {
				if (!bPastEntryDeadline) {
					if (iNumCompaniesRegistered == 0) {
						%>
						<p class="small">Step 2 of 3: <a class="small" href="companycreateedit.jsp"><b>Register a company</b></a></p>
						<%
					}
					else {
						if (iNumCompaniesRegistered == 1) {
							%>
							<p class="small">Step 3 of 3: <a class="small" href="entrycreateedit.jsp"><b>Submit a new entry</b></a></p>
							<%
						}
						else {
							%>
							<p class="small">Step 3 of 3: <a class="small" href="companylist.jsp"><b>Submit a new entry</b></a></p>
							<%
						}
					}
					if (iNumEntries > 0) {
						%>
						<p class="small"><a class="small" href="entrylist.jsp"><b>View, edit or delete entries</b></a></p>
						<%
					}
				}
				else {
					if (iNumEntries > 0) {
						%>
						<p class="small"><a class="small" href="entrylist.jsp"><b>View entries</b></a></p>
						<%
					}
				} // if past entry deadline
				%>
				<p><a class="small" href="accountcreateedit.jsp"><b>Edit user account details</b></a></p>
				<%
				if (iNumCompaniesRegistered > 0) {
					if (iNumCompaniesRegistered == 1) {
						%>
						<p class="small"><a class="small" href="companycreateedit.jsp"><b>View or edit company and/or payment details</b></a></p>
						<%
					}
					if (iNumCompaniesRegistered > 1) {
						%>
						<p class="small"><a class="small" href="companylist.jsp"><b>View or edit company and/or payment details</b></a></p>
						<%
					}
					if (!bPastEntryDeadline) {
						%>
						<p class="small"><a class="small" href="companycreateedit.jsp?companyid=new"><b>Register another company</b></a></p>
						<%
					}
				}
				%>
				<p class="small"><a class="small" href="logout.jsp"><b>Log out</b></a></p>
				<p class="small"><a class="small" href="passwordchange.jsp"><b>Change password</b></a></p>
				<%
			}
			%>
		</td>
	</tr>

</table>

<% // close the database %>
<%@ include file="include/close_db.jsp" %>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

