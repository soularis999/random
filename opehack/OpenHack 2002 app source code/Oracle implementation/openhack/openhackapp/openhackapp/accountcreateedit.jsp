<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>


<html>

<head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Create an account</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<% // open the database connection %>
<%@ include file="include/open_db.jsp" %>

<%

	// declare variables
	Calendar CurrentTimeStamp = Calendar.getInstance();
	Calendar EntryDeadline = Calendar.getInstance();
		EntryDeadline.set(2002,11,01,23,59,59);		// year, month, hour, minute and second values are 0-based; day value is 1-based
	boolean bPastEntryDeadline = false;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validEMailAddressPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String LoginPassed = session.getAttribute("Login Passed") == null ? "" : (String) session.getAttribute("Login Passed");
	boolean bLoggedIn = LoginPassed.equals("true") ? true : false;
	String userid = "";
	String password = "";
	String password2 = "";
	String username = "";
	String companyname = "";
	String title = "";
	String userphone = "";
	String email = "";
	String notifynextyear = "";

	// initialize variables

	String validEMailRegExp = "^[0-9a-zA-Z\\.\\-\\_]+\\@[0-9a-zA-Z\\.\\-]+\\.[a-zA-Z]{2,3}$";
	try {
		validEMailAddressPattern = compiler.compile(validEMailRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// determine if entry deadline has passed
	if (CurrentTimeStamp.after(EntryDeadline)) {
		bPastEntryDeadline = true;
	}

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : HTMLize(request.getParameter("submit").trim());
	String sMissingInput = request.getAttribute("MissingInput") == null ? "" : HTMLize((String) request.getAttribute("MissingInput"));

	// check input parameters
	MissingInput = false;
	if ( !(submit.equals("") || submit.equals("Submit data")) ) {
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

	// if we called ourself or if we were called by administration tools, check user input
	if (submit.equals("Submit data") || sMissingInput.equals("true")) {

		// get parameters passed from self
		if (session.getAttribute("Current User ID") == null) 
		{ 
			userid = request.getParameter("userid") == null ? "" : HTMLize(request.getParameter("userid").trim());
		}
		else
		{
			userid = (String) session.getAttribute("Current User ID");
		}
		password = request.getParameter("password") == null ? "" : HTMLize(request.getParameter("password").trim());
		password2 = request.getParameter("password2") == null ? "" : HTMLize(request.getParameter("password2").trim());
		username = request.getParameter("username") == null ? "" : HTMLize(request.getParameter("username").trim());
		companyname = request.getParameter("companyname") == null ? "" : HTMLize(request.getParameter("companyname").trim());
		title = request.getParameter("title") == null ? "" : HTMLize(request.getParameter("title").trim());
		userphone = request.getParameter("userphone") == null ? "" : HTMLize(request.getParameter("userphone").trim());
		email = request.getParameter("email") == null ? "" : HTMLize(request.getParameter("email").trim());
		notifynextyear = request.getParameter("notifynextyear") == null ? "" : HTMLize(request.getParameter("notifynextyear").trim());

		// check input parameters
		if (!sMissingInput.equals("true")) {

			MissingInput = false;
			if (!(notifynextyear.equals("Y") || notifynextyear.equals("N"))) {
				request.setAttribute ("msg", "The Notify Next Year field value is missing or set to an invalid value. Please click on an option and resubmit the form.");
				MissingInput = true;
			}
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
			// check to see that the e-mail address is not already in use
			query = "select userid, email from users where email = '" + SQLize(email) + "'";
			rs = stmt.executeQuery(query);
			recordfound = rs.next();
			// if there was a result, then there is already a user with that e-mail address
			if (recordfound) {
				// we have an e-mail address duplication -- if the user is logged in, it is their own e-mail address they are updating, and so there is no problem
				if (!bLoggedIn) {
					request.setAttribute ("msg", "There is already a user with that e-mail address. Perhaps you already have an account?" );
					MissingInput = true;
				}
				else {
					String currentuserid = (String) session.getAttribute("Current User ID");
					String useridtest = rs.getString(1);
					if (!currentuserid.equals(useridtest)) {
						request.setAttribute ("msg", "There is already a user with that e-mail address. Perhaps you already have an account? ");
						MissingInput = true;
					}
				}
			}
			if (!InputOK(userphone, 20)) {
				request.setAttribute ("msg", "The Phone field value is too long or has invalid characters. It is currently " + userphone.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 20 characters for this field.");
				MissingInput = true;
			}
			if (userphone.equals("")) {
				request.setAttribute ("msg", "The Phone field value is missing. Please fill in all required fields.");
				MissingInput = true;
			}
			if (!InputOK(companyname, 50)) {
				request.setAttribute ("msg", "The Full Company Name field value is too long or has invalid characters. It is currently " + companyname.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 50 characters for this field.");
				MissingInput = true;
			}
			if (companyname.equals("")) {
				request.setAttribute ("msg", "The Full Company Name field value is missing. Please fill in all required fields.");
				MissingInput = true;
			}
			if (!InputOK(username, 30)) {
				request.setAttribute ("msg", "The Full Name field value is too long or has invalid characters. It is currently " + username.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
				MissingInput = true;
			}
			if (username.equals("")) {
				request.setAttribute ("msg", "The Full Name field value is missing. Please fill in all required fields.");
				MissingInput = true;
			}
			if (!bLoggedIn) {
				// check to see if the password confirmation was correct
				if (!password.equals(password2)) {
					request.setAttribute ("msg", "The passwords you entered did not match. Please re-enter them.");
					MissingInput = true;
				}
				if (password2.equals("")) {
					request.setAttribute ("msg", "The Confirm Password field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
                                if (!InputOK(password2, 16)) {
                                        request.setAttribute ("msg", "The Password field value is too long or has invalid characters. Please choose a different password.");
                                        MissingInput = true;
                                }
				if (!InputOK(password, 16)) {
					request.setAttribute ("msg", "The Password field value is too long or has invalid characters. Please choose a different password.");
					MissingInput = true;
				}
				if (password.equals("")) {
					request.setAttribute ("msg", "The Password field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
			}
			// check to see that the userid is not already in use
			if ((!bLoggedIn) || (bLoggedIn && !userid.equals((String) session.getAttribute("Current User ID")))) {
				query = "select userid from users where userid = '" + SQLize(userid) + "'";
				rs = stmt.executeQuery(query);
				recordfound = rs.next();
				if (recordfound) {
					// if there was a result, then there is already a user by that name
					request.setAttribute ("msg", "There is already a user with that user ID. Please choose a different user ID.");
					MissingInput = true;
				}
			}
			// check user ID parameter for valid data
			if (!InputOK(userid, 10)) {
				request.setAttribute ("msg", "The user ID is too long or has invalid characters. Please choose a different user ID.");
				MissingInput = true;
			}
			if (userid.equals("")) {
				request.setAttribute ("msg", "The User ID field value is missing. Please fill in all required fields.");
				MissingInput = true;
			}

			if (MissingInput) {

				%>
				<% // close the database %>
				<%@ include file="include/close_db.jsp" %>
				<%
				request.setAttribute ("MissingInput", "true");
				%>
				<jsp:forward page="accountcreateedit.jsp">
					<jsp:param name="submit" value="" />
				</jsp:forward>
				<%

			} // if (MissingInput)

			else {

				// otherwise, write the information to the database

				// if the user is not logged in, this is a first-time sign-up
				if (!bLoggedIn) {
					query = "insert into users values (" + 
								"'" + SQLize(userid) + "', " +
								"EDPP001_enc.encrypt('" + SQLize(password) + "'), " +
								"'" + SQLize(username) + "', " +
								"'" + SQLize(title) + "', " +
								"'" + SQLize(companyname) + "', " +
								"'" + SQLize(userphone) + "', " +
								"'" + SQLize(email) + "', " +
								"'" + SQLize(notifynextyear) + "', " +
								// "CURRENT TIMESTAMP, CURRENT TIMESTAMP" +
								"SYSDATE, SYSDATE" +
							")";
				} // if (!bLoggedIn)
				else {
					// need to use old (stored) userid to do the update
					query = "update users set " +
					//			"userid = '" + SQLize(userid) + "', " +
								"username = '" + SQLize(username) + "', " +
								"title = '" + SQLize(title) + "', " +
								"companyname = '" + SQLize(companyname) + "', " +
								"phone = '" + SQLize(userphone) + "', " +
								"email = '" + SQLize(email) + "', " +
								"notifynextyear = '" + SQLize(notifynextyear) + "', " +
								//"recordmodificationtimestamp = CURRENT TIMESTAMP " +
								"recordmodificationtimestamp = SYSDATE " +
							"where userid = '" + SQLize((String) session.getAttribute("Current User ID")) + "'";
				} // if (bLoggedIn) [else]
				stmt.executeUpdate (query);

				%>
				<% // close the database %>
				<%@ include file="include/close_db.jsp" %>
				<%

				// save the data so far
				session.setAttribute ("Current User ID", userid);
				session.setAttribute ("Current User Name", username);
				session.setAttribute ("Current User Email", email);
				session.setAttribute ("Current Company Name", companyname);

				// if the user is not logged in, this is a first-time sign-up
				if (!bLoggedIn) {

					// send confirmation e-mail
					String sMessageText = 
						"Dear " + SMTPize(username) + ", \n" +
						"\n" +
						"Your account in eWEEK's eXcellence Awards program has been created.\n" +
						"\n" +
						"Here are your account details for your reference:\n" +
						"\n" +
						"User ID: " + SMTPize(userid) + "\n" +
						"Password: " + SMTPize(password) + "\n" +
						"\n";
					if (!bPastEntryDeadline) {
						sMessageText +=
							"The next step is to regiser company details for the firm creating the product or service eWEEK will be judging. Please log onto the eXcellence Awards site and then choose the \"Step 2 of 3: Register a company\" option.\n" +
							"\n";
					}
					else {
						sMessageText +=
							"We are not yet accepting entries for 2002 but if you chose the \"notification e-mail\" option, we will send you an e-mail message when we do start accepting entries.\n" +
							"\n";
					}
					sMessageText +=
						"Regards,\n" +
						"eWEEK\n" +
						"http://www.excellenceawardsonline.com\n";
					SendMailMessage (username, email, "eWEEK eXcellence Awards site account created", sMessageText);

					// the signup is complete, and login is thereby passed as well, so go to main page
					session.setAttribute ("Login Passed", "true");
					session.removeAttribute("Mid Sign-Up");

					// bounce the user off to the next stage
					session.setAttribute ("Mid Sign-Up", "true");
					session.setAttribute ("fromsign_up", "true");
					request.setAttribute ("userid", userid);

					// send new registrants to overview.jsp
					request.setAttribute ("msg", "Your user account has been created and you have been sent a confirmation e-mail with your account details. Please read the following few pages of information to get started.");
					%>
					<jsp:forward page="overview.jsp" />
					<%
				} // if (!bLoggedIn)

				// otherwise, we have edited an existing entry
				else {
					// send new registrants back to main page
					request.setAttribute ("msg", "User account details have been updated.");
					%>
					<jsp:forward page="index.jsp">
						<jsp:param name="submit" value="" />
					</jsp:forward>
					<%
				} // if (!bLoggedIn) [else]

			} // if (!MissingInput) [else]

		} // if (!sMissingInput.equals("true"))

	} // if (submit.equals("Submit data") || sMissingInput.equals("true"))

	else {

		if (bLoggedIn) {

			// get parameters from session object
			userid = (String) session.getAttribute("Current User ID");
			password = "";
			password2 = "";
			username = (String) session.getAttribute("Current User Name");
			companyname = (String) session.getAttribute("Current Company Name");
			title = "";
			userphone = "";
			email = (String)session.getAttribute("Current User Email");
			notifynextyear = "";
			// get rest of parameters
			query = "select title, phone, notifynextyear from users where userid = '" + SQLize(userid) + "'";
			rs = stmt.executeQuery(query);
			recordfound = rs.next();
			if (recordfound) {
				// get user data
				title = rs.getString(1);
				userphone = rs.getString(2);
				notifynextyear = rs.getString(3);
			}
			%>
			<% // close the database %>
			<%@ include file="include/close_db.jsp" %>
			<%

		} // if (bLoggedIn)

	} // if (!submit.equals("Submit data") && !sMissingInput.equals("true")) [else]

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<%
			if (!bLoggedIn) {
				%>
				<h4 align="center">Step 1 of 3: Create an account</h4>
				<h4 align="center">Please enter your user information below to create a site account.</h4>
				<%
			}
			else {
				%>
				<h4 align="center">Edit User Account Details</h4>
				<%
			}
			%>

			<form method="get" action="accountcreateedit.jsp">

				<table cellspacing="5">
					<%
					if (!bLoggedIn) {
						%>
						<tr valign="top">
							<td align="right">User ID:</td>
							<td>
								<input name="userid" type="text" size="10" maxlength="10" value="<%=HTMLize(userid)%>">
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><span class="instructions">(maximum 10 characters)</span></td>
						</tr>
						<tr valign="top">
							<td align="right">Password:</td>
							<td>
								<input name="password" type="password" size="10" maxlength="16" value="<%=HTMLize(password)%>">
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><span class="instructions">(maximum 16 characters)</span></td>
						</tr>
						<tr valign="top">
							<td align="right">Confirm Password:</td>
							<td>
								<input name="password2" type="password" size="10" maxlength="16" value="<%=HTMLize(password2)%>">
								<span class="asterisk">*</span>
							</td>
						</tr>
						<%
						}
					else {
						%>
						<tr valign="top">
							<td align="right">User ID:</td>
							<td>
								<p>
									<%=userid%>
									<input type="hidden" name="userid" value="<%=HTMLize(userid)%>">
								</p>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><span class="instructions">(User ID cannot be changed once an account is created.)</span></td>
						</tr>
						<tr valign="top">
							<td align="right">Password:</td>
							<td>
								<p>(hidden)</p>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><span class="instructions">(Please change password using the <a class="small" href="passwordchange.jsp">Change Password</a> page.)</span></td>
						</tr>
						<%
					}
					%>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr>
						<td align="right">Full Name:</td>
						<td>
							<input name="username" type="text" size="30" maxlength="30" value="<%=HTMLize(username)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Title:</td>
						<td>
							<input name="title" type="text" size="30" maxlength="50" value="<%=HTMLize(title)%>">
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Full Company Name:</td>
						<td>
							<input name="companyname" size="30" maxlength="50" type="text" value="<%=HTMLize(companyname)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Phone:</td>
						<td>
							<input name="userphone" type="text" size="30" maxlength="20" value="<%=HTMLize(userphone)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(format: xxx-xxx-xxxx or +x-xxx-xxx-xxxx)</span></td>
					</tr>
					<tr valign="top">
						<td align="right">E-Mail Address: </td>
						<td>
							<input name="email" type="text" size="30" maxlength="50" value="<%=HTMLize(email)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(We will send e-mail messages to this address alerting you to upcoming deadlines and updating you on your entry's status.)</span></td>
					</tr>

					<tr>
						<td align="right">Send you a notification e-mail when next year's awards program starts?</td>
						<td width="70%" valign="bottom">
							<%
							if (notifynextyear.equals("Y")) {
								%>
								<input type="radio" value="N" name="notifynextyear">no
								<input type="radio" value="Y" name="notifynextyear" CHECKED>yes
								<%
							}
							else {
								%>
								<input type="radio" value="N" name="notifynextyear" CHECKED>no
								<input type="radio" value="Y" name="notifynextyear">yes
								<%
							}
							%>
							<span class="asterisk">*</span><br>
						</td>
					</tr>

					<tr>
						<td colspan="2">
							<p align="center"><span class="asterisk">*</span> indicates a required field.</p>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<br>
							<input name="submit" type="submit" value="Submit data">
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

