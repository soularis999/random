<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>

<head>
	<title>Change Password</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	boolean MissingInput;
	String userid = (String) session.getAttribute("Current User ID");

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : request.getParameter("submit").trim();
	String currentpassword = request.getParameter("currentpassword") == null ? "" : request.getParameter("currentpassword").trim();
	String newpassword1 = request.getParameter("newpassword1") == null ? "" : request.getParameter("newpassword1").trim();
	String newpassword2 = request.getParameter("newpassword2") == null ? "" : request.getParameter("newpassword2").trim();

	%>
	<% // open the database %>
	<%@ include file="include/open_db.jsp" %>
	<%

	// check input parameters
	MissingInput = false;
	if ( !(submit.equals("") || submit.equals("Change password")) ) {
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

	// if we called ourself, try to change password
	if (submit.equals("Change password")) {

		// check input parameters
		boolean MissingInput = false;
		if (!newpassword1.equals(newpassword2)) {
			request.setAttribute ("msg", "The two new passwords aren't the same. Please try again.");
			MissingInput = true;
		}
		if (newpassword2.equals("")) {
			request.setAttribute ("msg", "The Retype new password field value is missing. Please fill in all required fields.");
			MissingInput = true;
		}
		if (!InputOK(newpassword1, 16)) {
			request.setAttribute ("msg", "The New password field value is too long or has invalid characters. Please choose a different password.");
			MissingInput = true;
		}
		if (newpassword1.equals("")) {
			request.setAttribute ("msg", "The New password field value is missing. Please fill in all required fields.");
			MissingInput = true;
		}
		if (!InputOK(currentpassword, 16)) {
			request.setAttribute ("msg", "The Password field value is too long or has invalid characters. Please retype it.");
			MissingInput = true;
		}
		if (currentpassword.equals("")) {
			request.setAttribute ("msg", "The Current password field value is missing. Please fill in all required fields.");
			MissingInput = true;
		}
		if (MissingInput) {
			%>
			<% // close the database connection %>
			<%@ include file="include/close_db.jsp" %>
			<jsp:forward page="passwordchange.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

		// check that account exists
		query = "select userid " +
					"from users " +
						"where userid = '" + SQLize(userid) + "' " +
							"and password = '" + SQLize(currentpassword) + "'";
		rs = stmt.executeQuery(query);
		recordfound = rs.next();
		if (recordfound) {
			// change password
			query = "update users " +
						"set password = '" + SQLize(newpassword1) + "', recordmodificationtimestamp = CURRENT TIMESTAMP " +
						"where userid = '" + SQLize(userid) + "'";
			stmt.executeUpdate (query);
		}
		else {
			request.setAttribute ("msg", "The current password was not correct. Please try again or contact us for assistance.");
			%>
			<% // close the database connection %>
			<%@ include file="include/close_db.jsp" %>
			<jsp:forward page="passwordchange.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

		%>
		<% // close the database %>
		<%@ include file="include/close_db.jsp" %>
		<%

		// send users back to main page
		request.setAttribute ("msg", "Your password has been changed.");
		%>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%

	}

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610" border="0">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h2>Change Password</h2>

			<p>
				Please enter your current password and your new password twice in the fields below.
			</p>
			
			<form>
				<table>
					<tr valign="top">
						<td align="right">Current password: </td>
						<td>
							<input name="currentpassword" type="password" size="10" maxlength="16" value="<%=currentpassword%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">New password: </td>
						<td>
							<input name="newpassword1" type="password" size="10" maxlength="16" value="<%=newpassword1%>">
							<span class="asterisk">*</span>
							<span class="instructions">(maximum 16 characters)</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Retype new password: </td>
						<td>
							<input name="newpassword2" type="password" size="10" maxlength="16" value="<%=newpassword2%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<br>
							<input name="submit" type="submit" value="Change password">
						</td>
					</tr>
				</table>
			</form>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

