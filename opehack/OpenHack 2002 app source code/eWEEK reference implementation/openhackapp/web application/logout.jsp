<%
	// log out the user and go back to the home page
	session.invalidate();
	request.setAttribute ("msg", "You have logged out.");
	%>
	<jsp:forward page="index.jsp">
		<jsp:param name="submit" value="" />
	</jsp:forward>
	<%
%>

