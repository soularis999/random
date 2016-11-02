<%
	// get msg value if the attribute has been set
	String errormessage = request.getAttribute("msg") == null ? "" : HTMLize((String)request.getAttribute("msg"));

	if (!errormessage.equals("")) {
		// security check for client-side scripting attack
		if (errormessage.indexOf("<",1) != -1 || errormessage.indexOf(">",1) != -1 || errormessage.indexOf("%",1) != -1) {
			errormessage = "Error message invalid. Please contact eWEEK for assistance.";
			//errormessage =  "There has been an application error, please try again.";
		}
		// display error message
		out.println ("<p class=\"errormessage\">" + errormessage + "</p>");
     //out.println ("<p class=\"errormessage\">There has been an application error, please try again.</p>");
	}

	request.setAttribute ("msg", "");
%>

