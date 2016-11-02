<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>
<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>Entry Registration Details</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// declare variables
	PatternMatcher matcher = new Perl5Matcher();
	Pattern validProductIdPattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	boolean MissingInput;

	String userid = (String) session.getAttribute("Current User ID");
	String companyname;
	String productname;
	String version;
	String announcementdate;
	String shipdate;
	String url;
	String nda;
	String targetaudience;
	String description;
	String businessproblem;
	String competitors;
	String keyfeatures;
	String price;
	String customerreferences;

	// initialize variables
	String validProductIDRegExp = "[0-9]+";
	try {
		validProductIdPattern = compiler.compile(validProductIDRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// get passed parameters
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

	// get entry information
	query = "select companies.companyname, products.productname, products.version, products.announcementdate, products.shipdate, products.url, products.nda, products.targetaudience, products.description, products.businessproblem, products.competitors, products.keyfeatures, products.price, products.customerreferences " +
				"from companies, products " +
				"where companies.id = products.companyid " +
					"and products.id = " + SQLize(productid);
	rs = stmt.executeQuery(query);
	recordfound = rs.next();

	// get product or service registration data
	companyname = rs.getString(1);
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

%>

<body>

<%@ include file="include/header.jsp" %>

<h3>Entry Registration Details</h3>

<a href="entrycreateedit.jsp?productid=<%=productid%>">Edit entry details</a><br>
<a href="entrylist.jsp">Return to entry list</a><br>

<br>

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
			if ((url != null) && (!url.equals(""))) {
				%>
				<a class="small" href="http://<%=url%>"><%=url%></a>
				<%
			}
			else {
				%>
				(not provided)
				<%
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
			<b>Target audience for product or service (max. 1000 characters): </b><br>
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

<a href="entrycreateedit.jsp?productid=<%=productid%>">Edit entry details</a><br>
<a href="entrylist.jsp">Return to entry list</a><br>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

