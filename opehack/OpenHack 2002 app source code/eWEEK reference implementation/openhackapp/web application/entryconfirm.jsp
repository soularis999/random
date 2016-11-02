<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>Confirm entry information</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	Calendar CurrentTimeStamp = Calendar.getInstance();
	Calendar EntryDeadline = Calendar.getInstance();
		EntryDeadline.set(2002,05,30,23,59,59);		// year, month, hour, minute and second values are 0-based; day value is 1-based
	boolean bPastEntryDeadline = false;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validCompanyIdPattern = null;
	Pattern validProductIdPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String userid = (String) session.getAttribute("Current User ID");
	String companyname = "";

	// initialize variables
	String validCompanyIDRegExp = "[0-9]+";
	try {
		validCompanyIdPattern = compiler.compile(validCompanyIDRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}
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
					<p>We're sorry, the deadline for new submissions or submission changes for the eWEEK eXcellence Awards program has passed. Thank you for you interest, and we invite you to participate next year.</p>
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

	// get parameters passed from entrycreateedit.jsp or self
	String companyid = request.getAttribute("companyid") == null ? "" : (String) request.getAttribute("companyid");
	if (request.getParameter("companyid") != null) companyid = request.getParameter("companyid").trim();
	String productid = request.getAttribute("productid") == null ? "" : (String) request.getAttribute("productid");
	if (request.getParameter("productid") != null) productid = request.getParameter("productid").trim();

	String productname = request.getParameter("productname") == null ? "" : request.getParameter("productname").trim();
	String version = request.getParameter("version") == null ? "" : request.getParameter("version").trim();
	String announcementdate = request.getParameter("announcementdate") == null ? "" : request.getParameter("announcementdate").trim();
	String shipdate = request.getParameter("shipdate") == null ? "" : request.getParameter("shipdate").trim();
	String url = request.getParameter("url") == null ? "" : request.getParameter("url").trim();
	// get rid of extra "http://" in URL if it's there
	if (url.startsWith("http://")) {
		url = url.substring(7);
	}
	String nda = request.getParameter("nda") == null ? "" : request.getParameter("nda").trim();
	String targetaudience = request.getParameter("targetaudience") == null ? "" : request.getParameter("targetaudience").trim();
	String description = request.getParameter("description") == null ? "" : request.getParameter("description").trim();
	String businessproblem = request.getParameter("businessproblem") == null ? "" : request.getParameter("businessproblem").trim();
	String competitors = request.getParameter("competitors") == null ? "" : request.getParameter("competitors").trim();
	String keyfeatures = request.getParameter("keyfeatures") == null ? "" : request.getParameter("keyfeatures").trim();
	String price = request.getParameter("price") == null ? "" : request.getParameter("price").trim();
	String customerreferences = request.getParameter("customerreferences") == null ? "" : request.getParameter("customerreferences").trim();

	%>
	<% // open the database connection %>
	<%@ include file="include/open_db.jsp" %>
	<%

	// check input parameters
	MissingInput = false;
	// productid can be blank
	if ( !(productid.equals("") || matcher.matches(productid, validProductIdPattern)) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
	// companyid CANNOT be blank: pass of regular expression check guarantees non-blankness, but having it explicit is more clear
	if ( !(!companyid.equals("") && matcher.matches(companyid, validCompanyIdPattern)) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
	if ( !(submit.equals("") || submit.equals("Save entry")) ) {
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

	// do a security check on the passed companyid
	query = "select companyid " +
				"from users_companies " +
				"where userid = '" + SQLize(userid) + "' " +
					"and companyid = " + SQLize(companyid);
	rs = stmt.executeQuery(query);
	recordfound = rs.next();
	if (!recordfound) {
		// probable security violation
		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<%
		request.setAttribute ("msg", "ERROR: Company not found or not registered by you. Please contact eWEEK for assistance.");
		%>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// if called with a product ID, do a security check on the passed productid
	if (!productid.equals("")) {
		// security and record existence check for productid
		query = "select userid " +
					"from users_companies, products " +
					"where userid = '" + SQLize(userid) + "' " +
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
	}

	// check input parameters
	MissingInput = false;
	if (customerreferences.equals("")) {
		request.setAttribute ("msg", "The customer reference field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(customerreferences, 5000)) {
		request.setAttribute ("msg", "The customer reference field value is too long or has invalid characters. It is currently " + customerreferences.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 5000 characters for this field.");
		MissingInput = true;
	}
	if (price.equals("")) {
		request.setAttribute ("msg", "The pricing field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(price, 2000)) {
		request.setAttribute ("msg", "The pricing field value is too long or has invalid characters. It is currently " + price.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 2000 characters for this field.");
		MissingInput = true;
	}
	if (keyfeatures.equals("")) {
		request.setAttribute ("msg", "The key features field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(keyfeatures, 5000)) {
		request.setAttribute ("msg", "The key features field value is too long or has invalid characters. It is currently " + keyfeatures.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 5000 characters for this field.");
		MissingInput = true;
	}
	if (businessproblem.equals("")) {
		request.setAttribute ("msg", "The business problem solved field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(businessproblem, 2000)) {
		request.setAttribute ("msg", "The business problem solved field value is too long or has invalid characters. It is currently " + businessproblem.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 2000 characters for this field.");
		MissingInput = true;
	}
	if (description.equals("")) {
		request.setAttribute ("msg", "The description of product or service field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(description, 5000)) {
		request.setAttribute ("msg", "The description of product or service field value is too long or has invalid characters. It is currently " + description.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 5000 characters for this field.");
		MissingInput = true;
	}
	if (targetaudience.equals("")) {
		request.setAttribute ("msg", "The target audience field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(targetaudience, 2000)) {
		request.setAttribute ("msg", "The target audience field value is too long or has invalid characters. It is currently " + targetaudience.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 2000 characters for this field.");
		MissingInput = true;
	}
	if (nda.equals("")) {
		request.setAttribute ("msg", "The NDA or embargo required field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!(nda.equals("Y") || nda.equals("N"))) {
		request.setAttribute ("msg", "The NDA or embargo required field value is set to an invalid value. Please click on an option and resubmit the form.");
		MissingInput = true;
	}
	if (!InputOK(url, 100) && url.length() > 0) {
		request.setAttribute ("msg", "The product or service's Web page field value is too long or has invalid characters. It is currently " + url.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 100 characters for this field.");
		MissingInput = true;
	}
	if (shipdate.equals("")) {
		request.setAttribute ("msg", "The scheduled ship date field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(shipdate, 30)) {
		request.setAttribute ("msg", "The scheduled ship date field value is too long or has invalid characters. It is currently " + shipdate.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
		MissingInput = true;
	}
	if (announcementdate.equals("")) {
		request.setAttribute ("msg", "The announcement date field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(announcementdate, 30)) {
		request.setAttribute ("msg", "The announcement date field value is too long or has invalid characters. It is currently " + announcementdate.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
		MissingInput = true;
	}
	if (version.equals("")) {
		request.setAttribute ("msg", "The version field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(version, 30)) {
		request.setAttribute ("msg", "The version field value is too long or has invalid characters. It is currently " + version.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
		MissingInput = true;
	}
	if (productname.equals("")) {
		request.setAttribute ("msg", "The name field value is missing. Please fill in all required fields.");
		MissingInput = true;
	}
	if (!InputOK(productname, 100)) {
		request.setAttribute ("msg", "The name field value is too long or has invalid characters. It is currently " + productname.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 100 characters for this field.");
		MissingInput = true;
	}
	if (MissingInput) {
		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<%
		request.setAttribute ("MissingInput", "true");
		%>
		<jsp:forward page="entrycreateedit.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// otherwise, continue

	// retrieve company name for inclusion in form and mailing
	query = "select companyname " +
				"from companies " +
				"where id = " + SQLize(companyid);
	rs = stmt.executeQuery(query);
	recordfound = rs.next();
	if (recordfound) {
		companyname = rs.getString(1);
	}

	// find out if we called ourself
	if (submit.equals("Save entry")) {

		//write product information to the database

		// if we didn't get passed a product ID, this is a new entry
		if (productid.equals("")) {
			query = "insert into products values (" +
						"DEFAULT, " +
						SQLize(companyid) + ", " +
						"'" + SQLize(productname) + "', " +
						"'" + SQLize(version) + "', " +
						"'" + SQLize(announcementdate) + "', " +
						"'" + SQLize(shipdate) + "', " +
						"'" + SQLize(url) + "', " +
						"'" + SQLize(nda) + "', " +
						"'" + SQLize(targetaudience) + "', " +
						"'" + SQLize(description) + "', " +
						"'" + SQLize(businessproblem) + "', " +
						"'" + SQLize(competitors) + "', " +
						"'" + SQLize(keyfeatures) + "', " +
						"'" + SQLize(price) + "', " +
						"'" + SQLize(customerreferences) + "', " +
						"NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, " +
						"CURRENT TIMESTAMP, CURRENT TIMESTAMP" +
						")";
		}
		// otherwise this is an update
		else {
			// security and record existence check for productid
			query = "select userid from users_companies, products " +
						"where userid = '" + SQLize(userid) +"' " +
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
				request.setAttribute ("msg", "ERROR: Product or service was not found or not registered by you. Please contact eWEEK for assistance.");
				%>
				<jsp:forward page="index.jsp">
					<jsp:param name="submit" value="" />
				</jsp:forward>
				<%
			}
			else {
				query = "update products set " +
								"productname = '" + SQLize(productname) + "', " +
								"version = '" + SQLize(version) + "', " +
								"announcementdate = '" + SQLize(announcementdate) + "', " +
								"shipdate = '" + SQLize(shipdate) + "', " +
								"url = '" + SQLize(url) + "', " +
								"nda = '" + SQLize(nda) + "', " +
								"targetaudience = '" + SQLize(targetaudience) + "', " +
								"description = '" + SQLize(description) + "', " +
								"businessproblem = '" + SQLize(businessproblem) + "', " +
								"competitors = '" + SQLize(competitors) + "', " +
								"keyfeatures = '" + SQLize(keyfeatures) + "', " +
								"price = '" + SQLize(price) + "', " +
								"customerreferences = '" + SQLize(customerreferences) + "', " +
								"recordmodificationtimestamp = CURRENT TIMESTAMP " +
							"where id = " + SQLize(productid);
			}
		}
		stmt.executeUpdate (query);

		// send confirmation e-mail

		// if we didn't get passed a product ID, this is a new entry, so send an e-mail
		if (productid.equals("")) {
			// get user name and e-mail address
			String username = "";
			String useremail = "";
			query = "select username, email from users where userid = '" + SQLize((String) session.getAttribute ("Current User ID")) + "'";
			rs = stmt.executeQuery(query);
			recordfound = rs.next();
			if (recordfound) {
				username = rs.getString(1);
				useremail = rs.getString(2);
			}
			// create message body text
			String sMessageText = 
				"Dear " + username + ", \n" +
				"\n" +
				"This e-mail is to confirm that following product or service has been submitted to eWEEK's eXcellence Awards program:\n" +
				"\n" +
				"Company Name: " + companyname + "\n" +
				"Product or Service Name: " + productname + "\n" +
				"Version: " + version + "\n" +
				"Announcement Date: " + announcementdate + "\n" +
				"Scheduled Ship Date: " + shipdate + "\n";
				;
			if (url.equals("")) {
				sMessageText += "Product or Service's Web page: (none provided)\n";
			}
			else {
				sMessageText += "Product or Service's Web page: http://" + url + "\n";
			}
			sMessageText += 
				"NDA or Embargo Required? " + nda + "\n" +
				"\n" +
				"Target audience for product or service:\n" +
				"\n" +
				targetaudience + "\n" +
				"\n" +
				"Description of product or service:\n" +
				"\n" +
				description + "\n" +
				"\n" +
				"Business problem that the product or service proposes to solve:\n" +
				"\n" +
				businessproblem + "\n" +
				"\n" +
				"Names of competing products or services:\n" +
				"\n" +
				competitors + "\n" +
				"\n" +
				"Key features that differentiate this product or service from its competition:\n" +
				"\n" +
				keyfeatures + "\n" +
				"\n" +
				"Pricing:\n" +
				"\n" +
				price + "\n" +
				"\n" +
				"Customer references:\n" +
				"\n" +
				customerreferences + "\n" +
				"\n" +
				"Regards,\n" +
				"eWEEK\n" +
				"http://www.excellenceawardsonline.com";
			SendMailMessage (username, useremail, "eWEEK eXcellence Awards entry confirmation", sMessageText);
			request.setAttribute ("msg", "Your entry has been <b>successfully received.</b> A confirmation e-mail has been sent to the e-mail address <b>" + useremail + "</b>.");
		}

		%>
		<% // close the database %>
		<%@ include file="include/close_db.jsp" %>
		<%

		// we're done, so go back to main page

		// set user message and go back to main page
		if (productid.equals("")) {
			// msg set above
			%>
			<jsp:forward page="thankyou.jsp" />
			<%
		}
		else {
			request.setAttribute ("msg", "Your entry has been updated.");
			%>
			<jsp:forward page="index.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

	}

%>

<body>

<%@ include file="include/header.jsp" %>

<h3>Confirm registration information</h3>

<table width="610" cellpadding="4">

	<tr>
		<td width="30%" align="right"><b>Company Name: </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(companyname)%></td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>Product or Service Name: </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(productname)%></td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>Version: </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(version)%></td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>Announcement Date: </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(announcementdate)%></td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>Scheduled Ship Date: </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(shipdate)%></td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>Product or Service's Web page: </b></td>
		<td width="70%" valign="bottom">
			<%
			if (url.equals("")) {
				out.print ("(none provided)");
			}
			else {
				out.print ("<a href=\"http://" + url + "\">" + url + "</a>");
			}
			%>
		</td>
	</tr>
	<tr>
		<td width="30%" align="right"><b>NDA or Embargo Required? </b></td>
		<td width="70%" valign="bottom"><%=HTMLize(nda)%></td>
	</tr>

</table>

<table width="610">
	<tr>
		<td>
			<br>
			<hr>
			<br>
		</td>
	</tr>
</table>

<table width="610">

	<tr>
		<td>
			<b>Target audience for product or service (max. 2000 characters): </b><br>
			<br>
			<%=HTMLize(targetaudience)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Description of product or service (max. 5000 characters): </b><br>
			<br>
			<%=HTMLize(description)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Business problem that the product or service proposes to solve (max. 2000 characters): </b><br>
			<br>
			<%=HTMLize(businessproblem)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Please provide the names of competing products or services in your market segment (max. 2000 characters): </b><br>
			<br>
			<%=HTMLize(competitors)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Key features that differentiate this product or service from its competition (max. 5000 characters): </b><br>
			<br>
			<%=HTMLize(keyfeatures)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 characters): </b><br>
			<br>
			<%=HTMLize(price)%><br>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<b>Provide at least one customer reference, including contact information for someone we could contact to ask about their experiences with this entry (max. 5000 characters): </b><br>
			<br>
			<%=HTMLize(customerreferences)%><br>
			<br>
		</td>
	</tr>

</table>

<table width="610">
	<tr>
		<td>
			<br>
			<hr>
			<br>
		</td>
	</tr>
</table>

<table width="610">
	<tr>
		<td colspan="2">
			If this information is correct, then click the "Save entry" button to save your new entry to our entries database.<br>
			<br>
			If you would like to change something, click the "Make changes" button to return to the entry form and edit this information.<br>
			<br>
			<%
			// if we didn't get passed a product ID, this is a new entry
			if (productid.equals("")) {
				%>
				<b>Your registration will be processed and a confirmation e-mail sent once you press "Save entry". This will take a few seconds... </b><br>
				<br>
				<%
			}
			%>
		</td>
	</tr>
	<tr>
		<td align="center">
			<form action="entryconfirm.jsp" method="post">
				<input name="submit" type="submit" value="Save entry">
				<input name="companyid" type="hidden" value="<%=HTMLize(companyid)%>">
				<input name="productid" type="hidden" value="<%=HTMLize(productid)%>">
				<input name="productname" type="hidden" value="<%=HTMLize(productname)%>">
				<input name="version" type="hidden" value="<%=HTMLize(version)%>">
				<input name="announcementdate" type="hidden" value="<%=HTMLize(announcementdate)%>">
				<input name="shipdate" type="hidden" value="<%=HTMLize(shipdate)%>">
				<input name="url" type="hidden" value="<%=HTMLize(url)%>">
				<input name="nda" type="hidden" value="<%=HTMLize(nda)%>">
				<input name="targetaudience" type="hidden" value="<%=HTMLize(targetaudience)%>">
				<input name="description" type="hidden" value="<%=HTMLize(description)%>">
				<input name="businessproblem" type="hidden" value="<%=HTMLize(businessproblem)%>">
				<input name="competitors" type="hidden" value="<%=HTMLize(competitors)%>">
				<input name="keyfeatures" type="hidden" value="<%=HTMLize(keyfeatures)%>">
				<input name="price" type="hidden" value="<%=HTMLize(price)%>">
				<input name="customerreferences" type="hidden" value="<%=HTMLize(customerreferences)%>">
			</form>
		</td>
		<td align="center">
			<form action="entrycreateedit.jsp" method="post">
				<input name="submit" type="submit" value="Make changes">
				<input name="companyid" type="hidden" value="<%=HTMLize(companyid)%>">
				<input name="productid" type="hidden" value="<%=HTMLize(productid)%>">
				<input name="productname" type="hidden" value="<%=HTMLize(productname)%>">
				<input name="version" type="hidden" value="<%=HTMLize(version)%>">
				<input name="announcementdate" type="hidden" value="<%=HTMLize(announcementdate)%>">
				<input name="shipdate" type="hidden" value="<%=HTMLize(shipdate)%>">
				<input name="url" type="hidden" value="<%=HTMLize(url)%>">
				<input name="nda" type="hidden" value="<%=HTMLize(nda)%>">
				<input name="targetaudience" type="hidden" value="<%=HTMLize(targetaudience)%>">
				<input name="description" type="hidden" value="<%=HTMLize(description)%>">
				<input name="businessproblem" type="hidden" value="<%=HTMLize(businessproblem)%>">
				<input name="competitors" type="hidden" value="<%=HTMLize(competitors)%>">
				<input name="keyfeatures" type="hidden" value="<%=HTMLize(keyfeatures)%>">
				<input name="price" type="hidden" value="<%=HTMLize(price)%>">
				<input name="customerreferences" type="hidden" value="<%=HTMLize(customerreferences)%>">
			</form>
		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

