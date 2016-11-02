<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Mail User ID and Password</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validEMailAddressPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	// initialize variables
	String validEMailRegExp = "^[0-9a-zA-Z\\.\\-\\_]+\\@[0-9a-zA-Z\\.\\-]+\\.[a-zA-Z]{2,3}$";
	try {
		validEMailAddressPattern = compiler.compile(validEMailRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : HTMLize(request.getParameter("submit").trim());
	String email = request.getParameter("email") == null ? "" : HTMLize(request.getParameter("email").trim());

	%>
	<% // open the database connection %>
	<%@ include file="include/open_db.jsp" %>
	<%

	// check input parameters
	MissingInput = false;
	if ( !(submit.equals("") || submit.equals("Mail account details")) ) {
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

	// check input parameters
	if (submit.equals("Mail account details")) {

		// check input parameters
		MissingInput = false;
		if (!InputOK(email, 50)) {
			request.setAttribute ("msg", "The E-Mail Address field value is too long or has invalid characters. It is currently " + email.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 50 characters for this field.");
			MissingInput = true;
		}
		if (!matcher.matches(email, validEMailAddressPattern)) {
			request.setAttribute ("msg", "The E-Mail Address field value isn't a valid e-mail address in \"name@server.top-level-domain\" format. Please enter a valid e-mail address.");
			MissingInput = true;
		}
		if (email.equals("")) {
			request.setAttribute ("msg", "The E-Mail Address field value is missing. Please fill in all required fields.");
			MissingInput = true;
		}
		if (MissingInput) {
			%>
			<% // close the database connection %>
			<%@ include file="include/close_db.jsp" %>
			<jsp:forward page="accountdetailsmail.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

		// check that account exists
		query = "select userid, EDPP001_denc1.decrypt(password), username " +
					"from users " +
					"where email = '" + SQLize(email) + "'";
		rs = stmt.executeQuery(query);
		recordfound = rs.next();
		if (recordfound) {
			String userid = rs.getString(1);
			String password = rs.getString(2);
			String username = rs.getString(3);
			// send confirmation e-mail
			String sMessageText = 
				"Dear " + SMTPize(username) + ", \n" +
				"\n" +
				"You requested the following eWEEK eXcellence Awards site account details associated with the e-mail address " + email + ".\n" +
				"\n" +
				"You can now log into the site using the following information:\n" +
				"\n" +
				"User ID: " + SMTPize(userid) + "\n" +
				"Password: " + SMTPize(password) + "\n" +
				"\n" +
				"Regards,\n" +
				"eWEEK\n" +
				"http://www.excellenceawardsonline.com";
			SendMailMessage (username, email, "requested eWEEK eXcellence Awards site account details", sMessageText);
			%>
			<% // close the database %>
			<%@ include file="include/close_db.jsp" %>
			<%
			// send users back to main page
			request.setAttribute ("msg", "Your account details have been mailed to you.");
			%>
			<jsp:forward page="index.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}
		else {
			%>
			<% // close the database %>
			<%@ include file="include/close_db.jsp" %>
			<%
			// send users back to main page
			request.setAttribute ("msg", "We do not have that e-mail address in our database. Please try again or contact us for assistance.");
			%>
			<jsp:forward page="accountdetailsmail.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

	}

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610" border="0">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<h2>Mail User ID and Password</h2>

			<p>
				If you have forgotten your user ID or password, please enter your 
				e-mail address here, and we will mail those details to you.
			</p>

			<form>
				<table>
					<tr>
						<td align="right">E-Mail Address: </td>
						<td>
							<input name="email" size="20" maxlength="50" type="text">
							<span class="asterisk">*</span><br>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<br>
							<input name="submit" type="submit" value="Mail account details">
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

