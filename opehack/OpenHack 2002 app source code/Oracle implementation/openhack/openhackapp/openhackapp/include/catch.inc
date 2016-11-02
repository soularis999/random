<%
// end of try block
}
// catch all exceptions here
catch (Exception e) {

	// private reporting
	System.err.println ();
	System.err.println ("==========");
	java.util.Date CurrentDate = new java.util.Date();
	System.err.println (java.text.DateFormat.getDateTimeInstance().format(CurrentDate));
	System.err.println ("Exception occurred:");
	System.err.println ();
	e.printStackTrace (System.err);
	System.err.println ();

	// display user error message
	out.println ("<h3>Ooops! The site is having a problem or you found a bug.</h3>");
	out.println ("<p>Please contact Timothy Dyck, eWEEK at 519-746-4241 or <a href=\"mailto:timothy_dyck@ziffdavis.com\">timothy_dyck@ziffdavis.com</a> and report this problem.</p>");
	out.println ("<br>");
	//out.println ("<p>The error message is:</p>");
	out.println ("<br>");
	out.println ("<pre>");
		//out.println (e);
	out.println ("</pre>");

};
%>
