<%
	// get msg value if the attribute has been set
	String errormessage = request.getAttribute("msg") == null ? "" : (String)request.getAttribute("msg");

	if (!errormessage.equals("")) {
		// security check for client-side scripting attack
		if (errormessage.indexOf("<s") != -1 || errormessage.indexOf("<S") != -1) {
			errormessage = "Error message invalid. Please contact eWEEK for assistance.";
		}
		// display error message
		out.println ("<p class=\"errormessage\">" + errormessage + "</p>");
	}

	request.setAttribute ("msg", "");
%>

