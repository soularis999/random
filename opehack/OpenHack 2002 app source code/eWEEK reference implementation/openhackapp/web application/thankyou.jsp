<%@ include file="include/logged_in_check.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

<html>

<head>
	<title>Thank You</title>
	<link rel="stylesheet" href="include/normal.css" type="text/css">
</head>

<body>

<%@ include file="include/header.jsp" %>

<table width="610" border="0">
	<tr>
		<td align="center">
			<h3>Thank You</h3>
		</td>
	</tr>
	<tr>
		<td>
			<%
			String msg = request.getAttribute("msg") == null ? "" : (String)request.getAttribute("msg");
			if (!msg.equals("")) {
				%>
				<p><%=msg%></p>
				<%
			}
			request.setAttribute ("msg", "");
			%>
			<p>We appreciate your participation in the program and we look forward to evaluating this product or service.</p>
			<p>To return to the main page, click <a href="index.jsp">here</a> or on the "Home" link at the top of the page.</p>
		</td>
	</tr>
</table>

<%@ include file="include/footer.jsp" %>

</body>

</html>
