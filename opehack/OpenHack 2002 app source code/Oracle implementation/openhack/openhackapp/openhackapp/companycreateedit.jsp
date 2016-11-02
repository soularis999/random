<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Register or edit company details</title>
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
	Pattern validCompanyIdPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String LoginPassed = session.getAttribute("Login Passed") == null ? "" : (String) session.getAttribute("Login Passed");
	boolean bLoggedIn = LoginPassed.equals("true") ? true : false;
	boolean bPaid = false;
	String userid = (String) session.getAttribute("Current User ID");
	String companyname = "";
	String address1 = "";
	String address2 = "";
	String city = "";
	String state = "";
	String zip = "";
	String country = "";
	String companyphone = "";
	String fax = "";
	String url = "";
	String creditcardbrand = "";
	String creditcard = "";
	String creditcardexpiry = "";
	String billingname = "";
	String billingaddress1 = "";
	String billingaddress2 = "";
	String billingcity = "";
	String billingstate = "";
	String billingzip = "";
	String billingcountry = "";
	String billingphone = "";
	String checkpayment = "";

	// initialize variables
	String validCompanyIDRegExp = "[0-9]+";
	try {
		validCompanyIdPattern = compiler.compile(validCompanyIDRegExp);
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
	// get parameters passed from companylist.jsp (number) or index.jsp (the string 'new')
	String companyid = request.getParameter("companyid") == null ? "" : HTMLize(request.getParameter("companyid").trim());
	// get parameter from login.jsp
	if (request.getAttribute("from_login_userid") != null) {
		userid = HTMLize((String) request.getAttribute("from_login_userid"));
		request.removeAttribute ("from_login_userid");
	}

	// check input parameters
	MissingInput = false;
	if ( !(companyid.equals("") || companyid.equals("new") || matcher.matches(companyid, validCompanyIdPattern)) ) {
		request.setAttribute ("msg", "Required parameter missing. Please contact eWEEK for assistance.");
		MissingInput = true;
	}
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

	// see if person has registered a company yet and get the first company ID registered if it was not passed in as a parameter
	bPaid = false;
	if (companyid.equals("")) {
		query = "select companyid " +
					"from users_companies " +
					"where userid = '" + SQLize(userid) + "'";
		rs = stmt.executeQuery(query);
		while (rs.next()) {
			companyid = rs.getString(1);
			bPaid = true;
		}
	}
	else {
		if (!companyid.equals("new")) {
			// security and record existence check
			query = "select companyid " +
						"from users_companies " +
						"where userid = '" + SQLize(userid) + "' " +
							"and companyid = " + SQLize(companyid);    
			rs = stmt.executeQuery(query);
			recordfound = rs.next();
			if (!recordfound && session.getAttribute("AdminLogin") == null) {
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
			else {
				bPaid = true;
			}
		}
	}

	// if deadline is passed, only allow edits of existing company and payment records
	if (bPastEntryDeadline && companyid.equals("new")) {
		%>
		<body>
		<%@ include file="include/header.jsp" %>
		<table width="610">
			<tr>
				<td>
					<h3>Deadline Passed</h3>
					<p>We're sorry, the deadline for new company registrations for the eWEEK eXcellence Awards program has passed. Thank you for you interest, and we invite you to participate next year.</p>
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

	// special case for calls from accountcreateedit.jsp
	if (session.getAttribute("fromsign_up") != null) {

		companyname = request.getParameter("companyname") == null ? "" : HTMLize(request.getParameter("companyname"));
		session.removeAttribute("fromsign_up");

	}

	else {

		// check rest of the parameters
		if (submit.equals("Submit data") || sMissingInput.equals("true")) {

			// get parameters passed from self
			companyname = request.getParameter("companyname") == null ? "" : HTMLize(request.getParameter("companyname").trim());
			address1 = request.getParameter("address1") == null ? "" : HTMLize(request.getParameter("address1").trim());
			address2 = request.getParameter("address2") == null ? "" :  request.getParameter("address2").trim();
			city = request.getParameter("city") == null ? "" : HTMLize(request.getParameter("city").trim());
			state = request.getParameter("state") == null ? "" : HTMLize(request.getParameter("state").trim());
			zip = request.getParameter("zip") == null ? "" :HTMLize( request.getParameter("zip").trim());
			country = request.getParameter("country") == null ? "" : HTMLize(request.getParameter("country").trim());
			companyphone = request.getParameter("companyphone") == null ? "" : HTMLize(request.getParameter("companyphone").trim());
			fax = request.getParameter("fax") == null ? "" : HTMLize(request.getParameter("fax").trim());
			url = request.getParameter("url") == null ? "" : HTMLize(request.getParameter("url").trim());
			creditcardbrand = request.getParameter("creditcardbrand") == null ? "" : HTMLize(request.getParameter("creditcardbrand").trim());
			creditcard = request.getParameter("creditcard") == null ? "" : HTMLize(request.getParameter("creditcard").trim());
			creditcardexpiry = request.getParameter("creditcardexpiry") == null ? "" : HTMLize(request.getParameter("creditcardexpiry").trim());
			billingname = request.getParameter("billingname") == null ? "" : HTMLize(request.getParameter("billingname").trim());
			billingaddress1 = request.getParameter("billingaddress1") == null ? "" : HTMLize(request.getParameter("billingaddress1").trim());
			billingaddress2 = request.getParameter("billingaddress2") == null ? "" : HTMLize(request.getParameter("billingaddress2").trim());
			billingcity = request.getParameter("billingcity") == null ? "" : HTMLize(request.getParameter("billingcity").trim());
			billingstate = request.getParameter("billingstate") == null ? "" : HTMLize(request.getParameter("billingstate").trim());
			billingzip = request.getParameter("billingzip") == null ? "" : HTMLize(request.getParameter("billingzip").trim());
			billingcountry = request.getParameter("billingcountry") == null ? "" : HTMLize(request.getParameter("billingcountry").trim());
			billingphone = request.getParameter("billingphone") == null ? "" : HTMLize(request.getParameter("billingphone").trim());
			checkpayment = request.getParameter("checkpayment") == null ? "" : HTMLize(request.getParameter("checkpayment").trim());

			// check input parameters
			String checkerrormessage = request.getAttribute("msg") == null ? "" : HTMLize((String)request.getAttribute("msg"));
			if (!sMissingInput.equals("true") && checkerrormessage.equals("")) {
				MissingInput = false;
				if (checkpayment.equals("")) {
					request.setAttribute ("msg", "The Check Payment field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!(checkpayment.equals("Y") || checkpayment.equals("N"))) {
					request.setAttribute ("msg", "The Check Payment field value is set to an invalid value. Please click on an option and resubmit the form.");
					MissingInput = true;
				}
				if (checkpayment.equals("N")) {
					if (billingphone.equals("")) {
						request.setAttribute ("msg", "The Billing Phone field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingphone, 20)) {
						request.setAttribute ("msg", "The Billing Phone field value is too long or has invalid characters. It is currently " + billingphone.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 20 characters for this field.");
						MissingInput = true;
					}
					if (billingcountry.equals("")) {
						request.setAttribute ("msg", "The Billing Country field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingcountry, 30)) {
						request.setAttribute ("msg", "The Billing Country field value is too long or has invalid characters. It is currently " + billingcountry.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
						MissingInput = true;
					}
					if (billingzip.equals("")) {
						request.setAttribute ("msg", "The Billing Zip/Postal Code field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingzip, 15)) {
						request.setAttribute ("msg", "The Billing Zip/Postal Code field value is too long or has invalid characters. It is currently " + billingzip.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 15 characters for this field.");
						MissingInput = true;
					}
					if (billingstate.equals("")) {
						request.setAttribute ("msg", "The Billing State/Province field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingstate, 2)) {
						request.setAttribute ("msg", "The Billing State/Province field value is too long or has invalid characters. It is currently " + billingstate.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 2 characters for this field.");
						MissingInput = true;
					}
					// check if billingstate string supplied is valid
					boolean billingstateValid = false;
					query = "select shortname from states";
					rs = stmt.executeQuery(query);
					while (rs.next()) {
						if (billingstate.equals(rs.getString(1))) {
							billingstateValid = true;
						}
					}
					if (!billingstateValid) {
						request.setAttribute ("msg", "The Billing State/Province field value is set to an invalid value. Please click on an option and resubmit the form.");
						MissingInput = true;
					}
					if (billingcity.equals("")) {
						request.setAttribute ("msg", "The Billing City field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingcity, 30)) {
						request.setAttribute ("msg", "The Billing City field value is too long or has invalid characters. It is currently " + billingcity.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
						MissingInput = true;
					}
					if (!InputOK(billingaddress2, 30) && billingaddress2.length() > 0) {
						request.setAttribute ("msg", "The Billing Address line 2 field value is too long or has invalid characters. It is currently " + billingaddress2.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
						MissingInput = true;
					}
					if (billingaddress1.equals("")) {
						request.setAttribute ("msg", "The Billing Address line 1 field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingaddress1, 30)) {
						request.setAttribute ("msg", "The Billing Address line 1 field value is too long or has invalid characters. It is currently " + billingaddress1.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
						MissingInput = true;
					}
					if (billingname.equals("")) {
						request.setAttribute ("msg", "The Name on Card field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(billingname, 30)) {
						request.setAttribute ("msg", "The Name on Card field value is too long or has invalid characters. It is currently " + billingname.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
						MissingInput = true;
					}
					if (creditcardexpiry.equals("")) {
						request.setAttribute ("msg", "The Credit Card Expiry Date field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(creditcardexpiry, 10)) {
						request.setAttribute ("msg", "The Credit Card Expiry Date field value is too long or has invalid characters. It is currently " + creditcardexpiry.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 10 characters for this field.");
						MissingInput = true;
					}
					if (creditcard.equals("")) {
						request.setAttribute ("msg", "The Credit Card Number field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					if (!InputOK(creditcard, 20)) {
						request.setAttribute ("msg", "The Credit Card Number field value is too long or has invalid characters. It is currently " + creditcard.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 20 characters for this field.");
						MissingInput = true;
					}
					if (creditcardbrand.equals("")) {
						request.setAttribute ("msg", "The Credit Card Brand field value is missing. Please fill in all required fields.");
						MissingInput = true;
					}
					// check if credit card brand string supplied is valid
					boolean creditcardbrandValid = false;
					query = "select shortname from creditcards";
					rs = stmt.executeQuery(query);
					while (rs.next()) {
						if (creditcardbrand.equals(rs.getString(1))) {
							creditcardbrandValid = true;
						}
					}
					if (!creditcardbrandValid) {
						request.setAttribute ("msg", "The Credit Card Brand field value is set to an invalid value. Please click on an option and resubmit the form.");
						MissingInput = true;
					}
				}
				else {
					creditcardbrand = "";
					creditcard = "";
					creditcardexpiry = "";
					billingname = "";
					billingaddress1 = "";
					billingaddress2 = "";
					billingcity = "";;
					billingstate = "";;
					billingzip = "";;
					billingcountry = "";;
					billingphone = "";
				}
				if (url.equals("")) {
					request.setAttribute ("msg", "The Company Web Site field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(url, 100)) {
					request.setAttribute ("msg", "The Company Web Site field value is too long or has invalid characters. It is currently " + url.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 100 characters for this field.");
					MissingInput = true;
				}
				// get rid of extra "http://" in URL if it's there
				if (url.startsWith("http://")) {
					url = url.substring(7);
				}
				if (companyphone.equals("")) {
					request.setAttribute ("msg", "The Company Phone field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(companyphone, 20)) {
					request.setAttribute ("msg", "The Company Phone field value is too long or has invalid characters. It is currently " + companyphone.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 20 characters for this field.");
					MissingInput = true;
				}
				if (country.equals("")) {
					request.setAttribute ("msg", "The Country field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(country, 30)) {
					request.setAttribute ("msg", "The Country field value is too long or has invalid characters. It is currently " + country.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
					MissingInput = true;
				}
				if (zip.equals("")) {
					request.setAttribute ("msg", "The Zip/Postal Code field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(zip, 15)) {
					request.setAttribute ("msg", "The Zip/Postal Code field value is too long or has invalid characters. It is currently " + zip.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 15 characters for this field.");
					MissingInput = true;
				}
				if (state.equals("")) {
					request.setAttribute ("msg", "The State/Province field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(state, 2)) {
					request.setAttribute ("msg", "The State/Province field value is too long or has invalid characters. It is currently " + state.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 2 characters for this field.");
					MissingInput = true;
				}
				// check if state string supplied is valid
				boolean stateValid = false;
				query = "select shortname from states";
				rs = stmt.executeQuery(query);
				while (rs.next()) {
					if (state.equals(rs.getString(1))) {
						stateValid = true;
					}
				}
				if (!stateValid) {
					request.setAttribute ("msg", "The State/Province field value is set to an invalid value. Please click on an option and resubmit the form.");
					MissingInput = true;
				}
				if (city.equals("")) {
					request.setAttribute ("msg", "The City field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(city, 30)) {
					request.setAttribute ("msg", "The City field value is too long or has invalid characters. It is currently " + city.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 30 characters for this field.");
					MissingInput = true;
				}
				if (!InputOK(address2, 50) && address2.length() > 0) {
					request.setAttribute ("msg", "The Address line 2 field value is too long or has invalid characters. It is currently " + address2.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 50 characters for this field.");
					MissingInput = true;
				}
				if (address1.equals("")) {
					request.setAttribute ("msg", "The Address line 1 field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(address1, 50)) {
					request.setAttribute ("msg", "The Address line 1 field value is too long or has invalid characters. It is currently " + address1.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 50 characters for this field.");
					MissingInput = true;
				}
				if (companyname.equals("")) {
					request.setAttribute ("msg", "The Full Company Name field value is missing. Please fill in all required fields.");
					MissingInput = true;
				}
				if (!InputOK(companyname, 100)) {
					request.setAttribute ("msg", "The Full Company Name field value is too long or has invalid characters. It is currently " + companyname.length() + " characters long (spaces count as one character and the ENTER key counts as two characters). The maximum is 100 characters for this field.");
					MissingInput = true;
				}
				if (MissingInput) {
					%>
					<% // close the database %>
					<%@ include file="include/close_db.jsp" %>
					<%
					request.setAttribute ("MissingInput", "true");
					%>
					<jsp:forward page="companycreateedit.jsp">
						<jsp:param name="submit" value="" />
					</jsp:forward>
					<%
				}
			} // if (!sMissingInput.equals("true") && checkerrormessage.equals(""))

		} // if (submit.equals("Submit data") || sMissingInput.equals("true"))

		else {

			if (!companyid.equals("") && !companyid.equals("new")) {
				// get company information from database
				query = "select companyname, address1, address2, city, state, zip, country, phone, fax, url from companies where id = " + SQLize(companyid);            
				rs = stmt.executeQuery(query);
				if (rs.next()) {
					companyname = rs.getString(1);
					address1 = rs.getString(2);
					address2 = rs.getString(3);
					city = rs.getString(4);
					state = rs.getString(5);
					zip = rs.getString(6);
					country = rs.getString(7);
					companyphone = rs.getString(8);
					fax = rs.getString(9) == null || rs.getString(9).equals("null") ? "" : rs.getString(9);          
					url = rs.getString(10);
				};
				// save company information 
				session.setAttribute ("Current Company ID", companyid);
				session.setAttribute ("Current Company Name", companyname);
				session.setAttribute ("Current Company Add1", address1);
				session.setAttribute ("Current Company Add2", address2);
				session.setAttribute ("Current Company City", city);
				session.setAttribute ("Current Company State", state);
				session.setAttribute ("Current Company Zip", zip);
				session.setAttribute ("Current Company Country", country);
				session.setAttribute ("Current Company Phone", companyphone);
				session.setAttribute ("Current Company Fax", fax);
				session.setAttribute ("Current Company URL", url);
				// get rest of parameters
				query = "select creditcardbrand, EDPP001_denc1.decrypt(creditcard), EDPP001_denc1.decrypt(creditcardexpiry), billingname, billingaddress1, billingaddress2, billingcity, billingstate, billingzip, billingcountry, billingphone, checkpayment from payment where companyid = " + SQLize(companyid);
				rs = stmt.executeQuery(query);
				recordfound = rs.next();
				if (recordfound) {
					// get payment data
					creditcardbrand = rs.getString(1) == null ? "" : rs.getString(1);	// creditcardbrand is stored as NULL in the database if it is blank
					creditcard = rs.getString(2) == null  || rs.getString(2).equals("null") ? "" : rs.getString(2);
					creditcardexpiry = rs.getString(3) == null  || rs.getString(3).equals("null") ? "" : rs.getString(3);
					billingname = rs.getString(4) == null  || rs.getString(4).equals("null") ? "" : rs.getString(4);
					billingaddress1 = rs.getString(5) == null  || rs.getString(5).equals("null") ? "" : rs.getString(5);
					billingaddress2 = rs.getString(6) == null  || rs.getString(6).equals("null") ? "" : rs.getString(6);
					billingcity = rs.getString(7) == null  || rs.getString(7).equals("null") ? "" : rs.getString(7);
					billingstate = rs.getString(8) == null  || rs.getString(8).equals("null") ? "" : rs.getString(8);	// billingstate is stored as NULL in the database if it is blank
					billingzip = rs.getString(9) == null  || rs.getString(9).equals("null") ? "" : rs.getString(9);
					billingcountry = rs.getString(10) == null  || rs.getString(10).equals("null") ? "" : rs.getString(10);
					billingphone = rs.getString(11) == null  || rs.getString(11).equals("null") ? "" : rs.getString(11);
					checkpayment = rs.getString(12) == null  || rs.getString(12).equals("null") ? "" : rs.getString(12);
				}
			}

		}

		if (submit.equals("Submit data")) {

			// write the information to the database

			// if the user has never paid, they need to register a company for the first time
			if (!bPaid) {
				query = "insert into companies values (" +
							"DEFAULT, " + 
							"'" + SQLize(companyname) + "', " +
							"'" + SQLize(address1) + "', " +
							"'" + SQLize(address2) + "', " +
							"'" + SQLize(city) + "', " +
							"'" + SQLize(state) + "', " +
							"'" + SQLize(zip) + "', " +
							"'" + SQLize(country) + "', " +
							"'" + SQLize(companyphone) + "', " +
							"'" + SQLize(fax) + "', " +
							"'" + SQLize(url) + "', " +
							//"CURRENT TIMESTAMP, " +
							"SYSDATE, " +
							//"CURRENT TIMESTAMP" +
							"SYSDATE" +
						")";   
				stmt.executeUpdate (query);
				// get the id for the new company
				//query = "select IDENTITY_VAL_LOCAL() from companies";	// NOTE: this is DB2-specific code!!
				query = "select ID_NUMBER.nextval from dual";	// NOTE: this is DB2-specific code!!
				// NOTE: will return null if autoCommit is ON
				rs = stmt.executeQuery(query);
				companyid = "";
				if (rs.next()) {
					companyid = rs.getString(1);
				}
				query = "insert into users_companies values (" +
							"'" + SQLize(userid) + "', " +
							SQLize(companyid) +
						")";
				stmt.executeUpdate (query);
				query = "insert into payment values (" +
							SQLize(companyid) + ", ";
				if (creditcardbrand.equals("")) {
					query += "NULL, ";
				}
				else {
					query += "'" + SQLize(creditcardbrand) + "', ";
				}
				query +=
					"EDPP001_enc.encrypt('" + SQLize(creditcard) + "'), " +
					"EDPP001_enc.encrypt('" + SQLize(creditcardexpiry) + "'), " +
					"'" + SQLize(billingname) + "', " +
					"'" + SQLize(billingaddress1) + "', " +
					"'" + SQLize(billingaddress2) + "', " +
					"'" + SQLize(billingcity) + "', ";
				if (billingstate.equals("")) {
					query += "NULL, ";
				}
				else {
					query += "'" + SQLize(billingstate) + "', ";
				}
				query +=
					"'" + SQLize(billingzip) + "', " +
					"'" + SQLize(billingcountry) + "', " +
					"'" + SQLize(billingphone) + "', " +
					"'" + SQLize(checkpayment) + "', " +
					"NULL, " +
					"NULL, " +
					"DEFAULT, " +
					"NULL, " +
					"NULL, " +
					//"CURRENT TIMESTAMP, " +
					"SYSDATE, " +
					//"CURRENT TIMESTAMP" +
					"SYSDATE," +
					// Added columns
					"'N', " +
					"SYSDATE" +
					
				")";
				stmt.executeUpdate (query);
			} // if (!bPaid)
			else {
				// update companies table
				query = "update companies set " +
								"companyname = '" + SQLize(companyname) + "', " + 
								"address1 = '" + SQLize(address1) + "', " + 
								"address2 = '" + SQLize(address2) + "', " + 
								"city = '" + SQLize(city) + "', " + 
								"state = '" + SQLize(state) + "', " + 
								"zip = '" + SQLize(zip) + "', " + 
								"country = '" + SQLize(country) + "', " + 
								"phone = '" + SQLize(companyphone) + "', " + 
								"fax = '" + SQLize(fax) + "', " + 
								"url = '" + SQLize(url) + "', " +
								//"recordmodificationtimestamp = CURRENT TIMESTAMP " +
								"recordmodificationtimestamp = SYSDATE " +
							"where id = " + SQLize(companyid);     
				stmt.executeUpdate (query);
				// update payment table
				query = "update payment set ";
				if (creditcardbrand.equals("")) {
					query += "creditcardbrand = NULL, ";
				}
				else {
					query += "creditcardbrand = '" + SQLize(creditcardbrand) + "', ";
				}
						query +=
							"creditcard = EDPP001_ENC.encrypt('" + SQLize(creditcard) + "'), " +
							"creditcardexpiry = EDPP001_ENC.encrypt('" + SQLize(creditcardexpiry) + "'), " +
							"billingname = '" + SQLize(billingname) + "', " +
							"billingaddress1 = '" + SQLize(billingaddress1) + "', " +
							"billingaddress2 = '" + SQLize(billingaddress2) + "', " +
							"billingcity = '" + SQLize(billingcity) + "', ";
					if (billingstate.equals("")) {
						query +=
							"billingstate = NULL, ";
					}
					else {
						query +=
							"billingstate = '" + SQLize(billingstate) + "', ";
					}
						query +=
							"billingzip = '" + SQLize(billingzip) + "', " +
							"billingcountry = '" + SQLize(billingcountry) + "', " +
							"billingphone = '" + SQLize(billingphone) + "', " +
							"checkpayment = '" + SQLize(checkpayment) + "', " +
							//"recordmodificationtimestamp = CURRENT TIMESTAMP " +
							"recordmodificationtimestamp = SYSDATE " +
						"where companyid = " + SQLize(companyid);    
        
				stmt.executeUpdate (query);
			} // if (bPaid) [else]
			// save company information 
			session.setAttribute ("Current Company ID", companyid);
			session.setAttribute ("Current Company Name", companyname);
			session.setAttribute ("Current Company Add1", address1);
			session.setAttribute ("Current Company Add2", address2);
			session.setAttribute ("Current Company City", city);
			session.setAttribute ("Current Company State", state);
			session.setAttribute ("Current Company Zip", zip);
			session.setAttribute ("Current Company Country", country);
			session.setAttribute ("Current Company Phone", companyphone);
			session.setAttribute ("Current Company Fax", fax);
			session.setAttribute ("Current Company URL", url);

			// if the user is not logged in, this is a first-time sign-up
			if (!bPaid) {
				// get user name and e-mail address
				String username = "";
				String password = "";
				String useremail = "";
				query = "select username, EDPP001_denc1.decrypt(password), email from users where userid = '" + SQLize(userid) + "'";
				rs = stmt.executeQuery(query);
				recordfound = rs.next();
				if (recordfound) {
					username = rs.getString(1);
					password = rs.getString(2);
					useremail = rs.getString(3);
				}

				%>
				<% // close the database %>
				<%@ include file="include/close_db.jsp" %>
				<%

				// send confirmation e-mail
				String sMessageText = 
					"Dear " + SMTPize(username) + ", \n" +
					"\n" +
					"Thank you for providing company details and payment information. You are now " +
					"able to submit products and/or services created by " + SMTPize(companyname) + " for consideration in this award " +
					"program.\n" +
					"\n" +
					"Please note we do NOT judge entire companies. You must still submit actual products and services that we will judge. This is \"Step 3 of 3: Submit a new entry\" on the site hoomepage.\n" +
					"\n" +
					"Company registration information you submitted:\n" +
					"\n" +
					SMTPize(companyname) + "\n" +
					SMTPize(address1) + "\n";
				if (!address2.equals("")) {
					sMessageText += SMTPize(address2) + "\n";
				}
				sMessageText +=
					SMTPize(city) + ", " + SMTPize(state) + ", " + SMTPize(zip) + "\n" +
					SMTPize(country) + "\n" +
					"\n" +
					"Payment Information:\n" +
					"\n";
				if (checkpayment.equals("N")) {
					sMessageText += "You have chosen to pay by credit card. $100.00 will be charged in the next few weeks to your credit card number ending with the four numbers " + Right(creditcard, 4) + ".\n";
				}
				else {
					sMessageText += 
						"You have chosen to pay by check. Please mail a check for $100.00 to:\n" +
						"\n" +
						"	eWEEK\n" +
						"	10 President's Landing\n" +
						"	Medford, MA\n" +
						"	02155\n" +
						"	USA\n" +
						"	ATTN: eXcellence Awards\n" +
						"\n" +
						"Please make the check payable to eWEEK.\n" +
						"\n" +
						"We must receive the check by Dec. 31, 2001 or your entry will invalid.";
				}
				sMessageText +=
					"\n" +
					"As a reminder, your site account information is:\n" +
					"\n" +
					"User ID: " + SMTPize(userid) + "\n" +
					"Password: " + SMTPize(password) + "\n" +
					"\n" +
					"Regards,\n" +
					"eWEEK\n" +
					"http://www.excellenceawardsonline.com";
				SendMailMessage (username, useremail, "eWEEK eXcellence company registration and payment confirmation", sMessageText);
				// TODO: SendReceipt (username, useremail);

				// the signup is complete, and login is thereby passed as well, so go to main page
				session.setAttribute ("Login Passed", "true");
				session.removeAttribute("Mid Sign-Up");

				// send new registrants to index.jsp
				request.setAttribute ("msg", "Thank you for your company registration and payment! A confirmation e-mail has been sent to the e-mail address " + useremail + ". You may now proceed to step 3, submitting a new entry for judging. You must still complete this last step before the entry deadline to be in the competition.");
				%>
				<jsp:forward page="index.jsp" />
				<%

			} // if (!bLoggedIn)

			// otherwise, we have edited an existing entry
			else {

				%>
				<% // close the database %>
				<%@ include file="include/close_db.jsp" %>
				<%

				// send new registrants back to main page
				request.setAttribute ("msg", "Company and/or payment details have been updated.");
				%>
				<jsp:forward page="index.jsp">
					<jsp:param name="submit" value="" />
				</jsp:forward>
				<%

			} // if (bLoggedIn) [else]

		} // if (submit.equals("Submit data"))

	} // (session.getAttribute("fromsign_up") == null) [else]

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<%@ include file="include/display_error_msg.jsp" %>

			<%

			if (!bPaid) {
				%>
				<h4 align="center">Step 2 of 3: Register a company</h4>
				<%
				if (companyid.equals("")) {
					%>
					<p align="center">You have not registered any companies into the eXcellence Awards program yet. Please enter company and associated company entry fee payment details.</p>
					<%
				}
				else {
					%>
					<p align="center">You should only register multiple companies with one account if you intend to submit multiple entries created by different vendors. If you are the public relations representative for several different clients, you are in this situation. You will need to pay the entry fee once for each company you register.</p>
					<%
				}
				%>
				<p align="center">Note if you are at a public relations firm, do not enter the details of <i>your</i> firm; enter the details of the company <i>creating</i> the products or services you will enter in step 3 and we will then judge.</p>
				<%
			}
			else {
				%>
				<h4 align="center">Edit Existing Company and/or Entry Fee Payment Details</h4>
				<p align="center">Please edit company and/or entry fee payment details.</p>
				<%
			}
			%>

			<form action="companycreateedit.jsp">

				<table>
					<tr valign="top">
						<td align="right">Full Company Name:</td>
						<td>
							<input name="companyname" size="30" maxlength="50" type="text" value="<%=HTMLize(companyname)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Address line 1:</td>
						<td>
							<input name="address1" size="30" maxlength="30" type="text" value="<%=HTMLize(address1)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Address line 2:</td>
						<td>
							<input name="address2" size="30" maxlength="30" type="text" value="<%=HTMLize(address2)%>">
						</td>
					</tr>
					<tr valign="top">
						<td align="right">City:</td>
						<td>
							<input name="city" size="30" maxlength="30" type="text" value="<%=HTMLize(city)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">State/Province:</td>
						<td>
							<select name="state">
								<option value="">Choose a state/province</option>
								<%
								// here we get the list of states/provinces from the database and build a select box
								query = "select shortname, longname from states order by countrysortorder, shortname";
								rs = stmt.executeQuery(query);
								String stateshortname;
								String statelongname;
								while (rs.next()) {
									stateshortname = rs.getString(1);
									statelongname = rs.getString(2);
									out.print ("<option value=\"" + stateshortname + "\"");
									if (state.equals(stateshortname)) {
										out.print (" selected=\"SELECTED\">");
									} else {
										out.print (">");
									}
									out.println (statelongname);
									out.println ("</option>");
								}
								%>
							</select>
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Zip/Postal Code:</td>
						<td>
							<input name="zip" size="15" maxlength="15" type="text" value="<%=HTMLize(zip)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Country:</td>
						<td>
							<input name="country" size="30" maxlength="30" type="text" value="<%=HTMLize(country)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Company Phone:</td>
						<td>
							<input name="companyphone" size="20" maxlength="20" type="text" value="<%=HTMLize(companyphone)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(format: xxx-xxx-xxxx or +x-xxx-xxx-xxxx)</span></td>
					</tr>
					<tr valign="top">
						<td align="right">Company Fax:</td>
						<td>
							<input name="fax" size="20" maxlength="20" type="text" value="<%=HTMLize(fax)%>">
						</td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(format: xxx-xxx-xxxx or +x-xxx-xxx-xxxx)</span></td>
					</tr>
					<tr valign="top">
						<td align="right">Company Web Site:</td>
						<td>
							<input size="30" name="url" maxlength="100" type="text" value="<%=HTMLize(url)%>">
							<span class="asterisk">*</span>
						</td>
					</tr>
				</table>

				<h4 align="center">Please enter or edit your payment information below.</h4>

				<p>A $100.00 non-tax deductible entry fee per company is required. After program expenses, proceeds will be donated to the <a href="http://www.starlight.org"> Starlight Children's Foundation</a> <a href="http://www.starlight.org/programs/pcpals.htm"> PC Pal</a> program and to the <a href="http://www.yte.org">Youth Tech Entrepreneurs</a> organization.</p>
				<p>Please enter credit card billing information in the boxes provided or choose to pay by check.</p>
				<p>If you want to pay by check, please mail a check for $100.00 to:</p>
				<p>
					eWEEK<br>
					10 President's Landing<br>
					Medford, MA<br>
					02155<br>
					USA<br>
					ATTN: eXcellence Awards
				</p>
				<p>Checks should be made payable to eWEEK.</p>
				<p>We must receive your check by <b>Dec. 31, 2001</b> or your entry will invalid.</p>

				<table border="1" align="center">
					<tr>
						<td align="center" class="reverse" colspan="2">Pay by Credit Card</td>
						<td align="center" class="reverse">Pay by Check</td>
					</tr>
					<tr valign="top">
						<td align="right">Credit Card Brand:</td>
						<td>
							<select name="creditcardbrand">
								<option value="">Choose a credit card</option>
								<%
								// here we get the list of credit card options from the database and build a select box
								query = "select shortname, longname from creditcards";
								rs = stmt.executeQuery(query);
								String creditcardshortname;
								String creditcardlongname;
								while (rs.next()) {
									creditcardshortname = rs.getString(1);
									creditcardlongname = rs.getString(2);
									out.print ("<option value=\"" + creditcardshortname + "\"");
									if (creditcardbrand.equals(creditcardshortname)) {
										out.print (" selected=\"SELECTED\">");
									} else {
										out.print (">");
									}
									out.println (creditcardlongname);
									out.println ("</option>");
								}
								%>
							</select>
							<span class="asterisk">*</span>
						</td>
						<td>
							<%
							// if the user is not logged in, this is a first-time sign-up
							if (!bLoggedIn) {
								checkpayment = "N";
							}
							if (checkpayment.equals("Y")) {
								%>
								<input type="radio" value="N" name="checkpayment">no
								<input type="radio" value="Y" name="checkpayment" CHECKED>yes
								<%
							}
							else {
								%>
								<input type="radio" value="N" name="checkpayment" CHECKED>no
								<input type="radio" value="Y" name="checkpayment">yes
								<%
							}
							%>
							<span class="asterisk">*</span>
						</td>
					</tr>
					<tr valign="top">
						<td align="right">Credit Card Number:</td>
						<td>
							<input name="creditcard" size="20" maxlength="20" type="text" value="<%=HTMLize(creditcard)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Credit Card Expiry Date:</td>
						<td>
							<input name="creditcardexpiry" size="7" maxlength="7" type="text" value="<%=HTMLize(creditcardexpiry)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(format: mm/yyyy)</span></td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Name on Card:</td>
						<td>
							<input name="billingname" size="30" maxlength="30" type="text" value="<%=(billingname)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing Address line 1:</td>
						<td>
							<input name="billingaddress1" size="30" maxlength="30" type="text" value="<%=HTMLize(billingaddress1)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing Address line 2:</td>
						<td>
							<input name="billingaddress2" size="30" maxlength="30" type="text" value="<%=HTMLize(billingaddress2)%>">
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing City:</td>
						<td>
							<input name="billingcity" size="30" maxlength="30" type="text" value="<%=HTMLize(billingcity)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing State/Province:</td>
						<td>
							<select name="billingstate">
								<option value="">Choose a state/province</option>
								<%
								// here we get the list of states/provinces from the database and build a select box
								query = "select shortname, longname from states order by countrysortorder, shortname";
								rs = stmt.executeQuery(query);
								String billingstateshortname;
								String billingstatelongname;
								while (rs.next()) {
									billingstateshortname = rs.getString(1);
									billingstatelongname = rs.getString(2);
									out.print ("<option value=\"" + billingstateshortname + "\"");
									if (billingstate.equals(billingstateshortname)) {
										out.print (" selected=\"SELECTED\">");
									} else {
										out.print (">");
									}
									out.println (billingstatelongname);
									out.println ("</option>");
								}
								%>
							</select>
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing Zip/Postal Code:</td>
						<td>
							<input name="billingzip" size="15" maxlength="15" type="text" value="<%=HTMLize(billingzip)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing Country:</td>
						<td>
							<input name="billingcountry" size="30" maxlength="30" type="text" value="<%=HTMLize(billingcountry)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr valign="top">
						<td align="right">Billing Phone:</td>
						<td>
							<input name="billingphone" size="20" maxlength="20" type="text" value="<%=HTMLize(billingphone)%>">
							<span class="asterisk">*</span>
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td><span class="instructions">(format: xxx-xxx-xxxx or +x-xxx-xxx-xxxx)</span></td>
						<td></td>
					</tr>
				</table>

				<br>

				<p><span class="asterisk">*</span> indicates a required field.</p>
				<p>
					<input name="submit" type="submit" value="Submit data">
					<input type="hidden" name="userid" value="<%=HTMLize(userid)%>">
					<input type="hidden" name="companyid" value="<%=HTMLize(companyid)%>">
				</p>

				<%
				if (!bLoggedIn) {
					%>
					<p><b>Your registration changes will be processed and a confirmation e-mail sent once you press 
					"Submit data". This will take a few seconds...</b></p>
					<%
				}
				%>

			</form>

		</td>
	</tr>
</table>

<% // close the database %>
<%@ include file="include/close_db.jsp" %>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>
