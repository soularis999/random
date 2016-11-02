<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Secure Login</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	boolean MissingInput;

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : request.getParameter("submit").trim();
	String userid = request.getParameter("userid") == null ? "" : request.getParameter("userid").trim();
	String password = request.getParameter("password") == null ? "" : request.getParameter("password").trim();

	%>
	<% // open the database %>
	<%@ include file="include/open_db.jsp" %>
	<%

	// check input parameters
	MissingInput = false;
	if ( !(submit.equals("") || submit.equals("log in")) ) {
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

	// if we called ourself, try to log in
	if (submit.equals("log in")) {

		// get user information
		query = "select userid, username, email, companyname from users where lower(userid) = lower('" + SQLize(userid) + "') and password = EDPP001_enc.encrypt('" + SQLize(password) + "')";
		rs = stmt.executeQuery(query);
		recordfound = rs.next();

		// if account not found, user typed in the wrong password or the account does not exist
		if (!recordfound) {
			session.removeAttribute("Login Passed");
			%>
			<% // close the database %>
			<%@ include file="include/close_db.jsp" %>
			<% 
			request.setAttribute ("msg", "The user ID or password was incorrect. Please try again.");
			%>
			<jsp:forward page="login.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		};

		// else, the record was found, so proceed with login
		session.setAttribute ("Login Passed", "true");

		// save user information
		userid = rs.getString(1);
		String username = rs.getString(2);
		String useremail = rs.getString(3);
		String companyname = rs.getString(4);
		session.setAttribute ("Current User ID", userid);
		session.setAttribute ("Current User Name", username);
		session.setAttribute ("Current User Email", useremail);
		session.setAttribute ("Current Company Name", companyname);

		%>
		<% // close the database %>
		<%@ include file="include/close_db.jsp" %>
		<%

		// send existing registrants to home page
		request.setAttribute ("msg", "Log in successfull.");
		%>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%

	};

%>
<% // close the database %>
<%@ include file="include/close_db.jsp" %>
<% 

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610" border="0">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h3 align="center">Secure Login</h3>

			<div align="center">
				<form method="post" action="login.jsp">
					<table border="0" bgcolor="#333399">
						<tr>
							<td align="right"> 
								<span class="logintext">User ID: </span>
								<input name="userid" type="text" size="10" maxlength="10">
								<br>
								<span class="logintext">Password: </span>
								<input name="password" type="password" size="10" maxlength="16">
							</td>
							<td valign="top"> 
								<input name="submit" type="submit" value="log in">
							</td>
						</tr>
					</table>
				</form>
			</div>

			<p align="center">
				Note: User IDs are not case-sensitive. Passwords <b>are</b> case-sensitive.
			</p>

			<p align="center">
				If you have forgotten your password, we can <a href="accountdetailsmail.jsp">mail</a> it to you.
			</p>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>
