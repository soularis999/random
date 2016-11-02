<%@ include file="include/try.inc" %>
<%@ include file="include/functions.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Entry Form Sample</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<%

	// define local variables
	String userid = (String) (session.getAttribute("Current User ID"))==null ? "" : (String) (session.getAttribute("Current User ID"));
	String companyid = "";
	String productname = "(sample only -- don't use)";
	String version = "(sample only -- don't use)";
	String announcementdate = "(sample only -- don't use)";
	String shipdate = "(sample only -- don't use)";
	String url = "(sample only -- don't use)";
	String nda = "";
	String targetaudience = "(sample only -- don't use)";
	String description = "(sample only -- don't use)";
	String businessproblem = "(sample only -- don't use)";
	String competitors = "(sample only -- don't use)";
	String keyfeatures = "(sample only -- don't use)";
	String price = "(sample only -- don't use)";
	String customerreferences = "(sample only -- don't use)";

%>

<body>

<%@ include file="include/header.jsp" %>

<table width="610">
	<tr>
		<td>

			<h2>This is <b>not</b> a live form.</h2>
			<p>
				This is the information you will need to have ready when you submit an entry.
				<%
				if (userid.equals("")) {
					%>
					Please <a href="accountcreateedit.jsp">sign up</a> or <a href="login.jsp">log in</a> to see the form that can record your information.
					<%
				}
				else {
					%>
					<% // open the database connection %>
					<%@ include file="include/open_db.jsp" %>
					<%
					query = "select companyid from users_companies where userid = '" + SQLize(userid) + "'";
					rs = stmt.executeQuery(query);
					recordfound = rs.next();
					if (!recordfound) {
						%>
						Please <a href="companycreateedit.jsp">register a company</a> to move onto step 2 of the entry submission process.
						<%
					}
					else {
						%>
						Please <a href="entrycreateedit.jsp">submit a new entry</a> to see the form that can record your information.
						<%
					}
					%>
					<% // close the database connection %>
					<%@ include file="include/close_db.jsp" %>
					<%
				}
				%>
			</p>

			<table width="610" cellpadding="4">
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
							<input type="radio" value="no" name="nda">no
							<input type="radio" value="yes" name="nda" CHECKED>yes
							<%
						}
						else {
							%>
							<input type="radio" value="no" name="nda" CHECKED>no
							<input type="radio" value="yes" name="nda">yes
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
						<textarea name="targetaudience" rows="10" cols="70"><%=targetaudience%></textarea>
						<span class="asterisk">*</span>
						<br>
					</td>
				</tr>
				<tr>
					<td>
						Description of product or service (max. 5000 characters):<br>
						<textarea name="description" rows="10" cols="70"><%=description%></textarea>
						<span class="asterisk">*</span>
						<br>
					</td>
				</tr>
				<tr>
					<td>
						Business problem that the product or service proposes to solve (max. 2000 characters):<br>
						<textarea name="businessproblem" rows="10" cols="70"><%=businessproblem%></textarea>
						<span class="asterisk">*</span>
						<br>
					</td>
				</tr>
				<tr>
					<td>
						Please provide the names of competing products or services in your market segment (max. 2000 characters):<br>
						<textarea name="competitors" rows="10" cols="70"><%=competitors%></textarea>
						<span class="asterisk">*</span>
						<br>
					</td>
				</tr>
				<tr>
					<td>
						Key features that differentiate this product or service from its competition (max. 5000 characters):<br>
						<textarea name="keyfeatures" rows="10" cols="70"><%=keyfeatures%></textarea>
						<span class="asterisk">*</span>
					</td>
				</tr>
				<tr>
					<td>
						Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 characters):<br>
						<textarea name="price" rows="10" cols="70"><%=price%></textarea>
						<span class="asterisk">*</span>
					</td>
				</tr>
				<tr>
					<td>
						Provide at least one customer reference, including contact information for someone we could contact to ask about their experiences with this entry (max. 5000 characters):<br>
						<textarea name="customerreferences" rows="10" cols="70"><%=customerreferences%></textarea>
						<span class="asterisk">*</span>
					</td>
				</tr>
			</table>

		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>

<%@ include file="include/catch.inc" %>

