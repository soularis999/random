<%
	// if the user is not logged in, redirect to the initial home page
	if (session.getAttribute("Login Passed") == null && session.getAttribute("AdminLogin") == null) {
		%>
		<jsp:forward page="index.jsp" />
		<%
	}
%>
