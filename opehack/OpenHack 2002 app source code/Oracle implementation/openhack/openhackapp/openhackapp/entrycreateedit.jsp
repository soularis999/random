<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Create or Edit Entries</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	Calendar CurrentTimeStamp = Calendar.getInstance();
	Calendar EntryDeadline = Calendar.getInstance();
		EntryDeadline.set(2002,11,01,23,59,59);		// year, month, hour, minute and second values are 0-based; day value is 1-based
	boolean bPastEntryDeadline = false;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validCompanyIdPattern = null;
	Pattern validProductIdPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String userid = (String) session.getAttribute("Current User ID");
	String companyname = "";

	String productname = "";
	String version = "";
	String announcementdate = "";
	String shipdate = "";
	String url = "";
	String nda = "";
	String targetaudience = "";
	String description = "";
	String businessproblem = "";
	String competitors = "";
	String keyfeatures = "";
	String price = "";
	String customerreferences = "";

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

	// TODO: check if user session has expired
	if (!request.isRequestedSessionIdValid()) {
		request.setAttribute ("msg", "ERROR: Your login session has timed out. Please log in again.");
		%>
		<jsp:forward page="index.jsp">
			<jsp:param name="submit" value="" />
		</jsp:forward>
		<%
	}

	// get passed parameters

	// get parameters passed from self
	String submit = request.getParameter("submit") == null ? "" : HTMLize(request.getParameter("submit").trim());
	String sMissingInput = request.getAttribute("MissingInput") == null ? "" : (String) request.getAttribute("MissingInput");

	// get parameters passed from companylist.jsp (number)
	String companyid = request.getParameter("companyid") == null ? "" : HTMLize(request.getParameter("companyid").trim());

	// get parameters passed from entrylist.jsp or entryconfirm.jsp
	String productid = request.getParameter("productid") == null ? "" : HTMLize(request.getParameter("productid").trim());

	// get parameters passed from self or entryconfirm.jsp
	productname = request.getParameter("productname") == null ? "" : HTMLize(request.getParameter("productname").trim());
	version = request.getParameter("version") == null ? "" : HTMLize(request.getParameter("version").trim());
	announcementdate = request.getParameter("announcementdate") == null ? "" : HTMLize(request.getParameter("announcementdate").trim());
	shipdate = request.getParameter("shipdate") == null ? "" : HTMLize(request.getParameter("shipdate").trim());
	url = request.getParameter("url") == null ? "" : HTMLize(request.getParameter("url").trim());
	nda = request.getParameter("nda") == null ? "" : HTMLize(request.getParameter("nda").trim());
	targetaudience = request.getParameter("targetaudience") == null ? "" : HTMLize(request.getParameter("targetaudience").trim());
	description = request.getParameter("description") == null ? "" : HTMLize(request.getParameter("description").trim());
	businessproblem = request.getParameter("businessproblem") == null ? "" : HTMLize(request.getParameter("businessproblem").trim());
	competitors = request.getParameter("competitors") == null ? "" : HTMLize(request.getParameter("competitors").trim());
	keyfeatures = request.getParameter("keyfeatures") == null ? "" : HTMLize(request.getParameter("keyfeatures").trim());
	price = request.getParameter("price") == null ? "" : HTMLize(request.getParameter("price").trim());
	customerreferences = request.getParameter("customerreferences") == null ? "" : HTMLize(request.getParameter("customerreferences").trim());

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
	// companyid can be blank
	if ( !(companyid.equals("") || matcher.matches(companyid, validCompanyIdPattern)) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
	if ( !(submit.equals("") || submit.equals("Double-check entry") || submit.equals("Make changes")) ) {
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

	// if called with a company ID, do a security check on the passed companyid
	if (!companyid.equals("")) {
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

	// if passed a companyid parameter, than use that to retrieve the company name for passed companyid
	if (!companyid.equals("")) {
		query = "select companyname " +
					"from companies " +
					"where id = " + SQLize(companyid);
		rs = stmt.executeQuery(query);
		recordfound = rs.next();
		if (recordfound) {
			companyname = rs.getString(1);
		}
	}
	// otherwise look up the company id and company name based on the user ID
	else {
		query = "select companies.id, companies.companyname " +
					"from companies, users_companies " +
					"where companies.id = users_companies.companyid " +
						"and users_companies.userid = '" + SQLize(userid) + "'";
		rs = stmt.executeQuery(query);
		recordfound = rs.next();
		if (recordfound) {
			companyid = rs.getString(1);
			companyname = rs.getString(2);
		}
	}

	// find out if we called ourself
	if (submit.equals("Double-check entry")) {

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
			request.setAttribute ("msg", "The product or service name field value is missing. Please fill in all required fields.");
			MissingInput = true;
		}
		if (!InputOK(productname, 100)) {
			request.setAttribute ("msg", "The product or service name field value is too long or has invalid characters. It is currently " + productname.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 100 characters for this field.");
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
		else {
			%>
			<% // close the database connection %>
			<%@ include file="include/close_db.jsp" %>
			<%
			request.setAttribute ("companyid", companyid);
			request.setAttribute ("productid", productid);
			%>
			<jsp:forward page="entryconfirm.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

	}

	// if called with a product ID and not from entryconfirm.jsp, load product record from database
	if (!productid.equals("") && !submit.equals("Make changes") && !sMissingInput.equals("true")) {

		// security and record existence check for productid
		query = "select userid from users_companies, products " +
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
			<jsp:forward page="entrycreateedit.jsp">
				<jsp:param name="submit" value="" />
			</jsp:forward>
			<%
		}

		// get entry information
		query = "select companyid, productname, version, announcementdate, shipdate, url, nda, targetaudience, description, businessproblem, competitors, keyfeatures, price, customerreferences from products where id = " + SQLize(productid);
		rs = stmt.executeQuery(query);
		recordfound = rs.next();
		// get product or service registration data
		companyid = rs.getString(1);
		productname = rs.getString(2);
		version = rs.getString(3);
		announcementdate = rs.getString(4);
		shipdate = rs.getString(5);
		url = rs.getString(6);
		nda = rs.getString(7);
		targetaudience = rs.getString(8);
		description = rs.getString(9);
		businessproblem = rs.getString(10);
		competitors = rs.getString(11);
		keyfeatures = rs.getString(12);
		price = rs.getString(13);
		customerreferences = rs.getString(14);

		%>
		<% // close the database connection %>
		<%@ include file="include/close_db.jsp" %>
		<%

	}

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
</table>

<table width="610">
	<tr>
		<td>

			<p><b>Note:</b> Users who do not submit a page for more than <b>12 hours</b> are automatically logged out of the system. You should not leave this page open without submitting data for more than this time, or your entry submission will not be saved.</p>
			<h3>Create or Edit Entries</h3>
			<%@ include file="/include/display_error_msg.jsp" %>

			<form method="post" action="entrycreateedit.jsp">

				<table width="610" cellpadding="4">
					<tr>
						<td width="30%" align="right"><b>Company Name: </b></td>
						<td width="70%" valign="bottom">
							<b><%=HTMLize(companyname)%></b>
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>Product or Service Name: </b></td>
						<td width="70%" valign="bottom">
							<input name="productname" type="text" size="30" maxlength="100" value="<%=HTMLize(productname)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>Version: </b></td>
						<td width="70%" valign="bottom">
							<input name="version" type="text" size="30" maxlength="30" value="<%=HTMLize(version)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>Announcement Date: </b></td>
						<td width="70%" valign="bottom">
							<input name="announcementdate" type="text" size="30" maxlength="30" value="<%=HTMLize(announcementdate)%>">
							<span class="asterisk">*</span><br>
						</td>
					</tr>
					<tr>
						<td width="30%"></td>
						<td width="70%">
							<span class="instructions">(format: <b>mm/dd/yyyy</b> or spell the month out)</span><br>
							<span class="instructions">(announcement date must be on or after <b>Jan. 1, 2001</b> and on or before <b>Dec. 31, 2001</b>)</span>
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>Scheduled Ship Date: </b></td>
						<td width="70%" valign="bottom">
							<input name="shipdate" type="text" size="30" maxlength="30" value="<%=HTMLize(shipdate)%>">
							<span class="asterisk">*</span><br>
						</td>
					</tr>
					<tr>
						<td width="30%"></td>
						<td width="70%">
							<span class="instructions">(format: <b>mm/dd/yyyy</b> or spell the month out)</span><br>
							<span class="instructions">(ship date must be on or before <b>Jan. 31, 2002</b>)</span>
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>Product or Service's Web page: </b></td>
						<td width="70%" valign="bottom">
							<input name="url" type="text" size="30" maxlength="100" value="<%=HTMLize(url)%>">
						</td>
					</tr>
					<tr>
						<td width="30%" align="right"><b>NDA or Embargo Required? </b></td>
						<td width="70%" valign="bottom">
							<%
							if (nda.equals("Y")) {
								%>
								<input type="radio" value="N" name="nda">no
								<input type="radio" value="Y" name="nda" CHECKED>yes
								<%
							}
							else {
								%>
								<input type="radio" value="N" name="nda" CHECKED>no
								<input type="radio" value="Y" name="nda">yes
								<%
							}
							%>
							<span class="asterisk">*</span><br>
						</td>
					</tr>
					<tr>
						<td width="30%"></td>
						<td width="70%"><span class="instructions">(Note that any NDAs need to expire after a product or service is publicly announced.)</span></td>
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
							Target audience for product or service (max. 2000 characters):<br>
							<br>
							<textarea name="targetaudience" rows="10" cols="70"><%=targetaudience%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Description of product or service (max. 5000 characters):<br>
							<br>
							<textarea name="description" rows="10" cols="70"><%=description%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Business problem that the product or service proposes to solve (max. 2000 characters):<br>
							<br>
							<textarea name="businessproblem" rows="10" cols="70"><%=businessproblem%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Please provide the names of competing products or services in your market segment (max. 2000 characters):<br>
							<br>
							<textarea name="competitors" rows="10" cols="70"><%=competitors%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Key features that differentiate this product or service from its competition (max. 5000 characters):<br>
							<textarea name="keyfeatures" rows="10" cols="70"><%=keyfeatures%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 characters):<br>
							<br>
							<textarea name="price" rows="10" cols="70"><%=price%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							Provide at least one customer reference, including contact information for someone we could contact to ask about their experiences with this entry (max. 2000 characters):<br>
							<br>
							<textarea name="customerreferences" rows="10" cols="70"><%=customerreferences%></textarea>
							<span class="asterisk">*</span>
							<br>
							<br>
						</td>
					</tr>
				</table>

				<p><span class="asterisk">*</span> indicates a required field.</p>
				<p>
					<input name="submit" type="submit" value="Double-check entry">
					<input name="companyid" type="hidden" value=<%=HTMLize(companyid)%>>
					<input name="productid" type="hidden" value=<%=HTMLize(productid)%>>
				</p>

			</form>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

