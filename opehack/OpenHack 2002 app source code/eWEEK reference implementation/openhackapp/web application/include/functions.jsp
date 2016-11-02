<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MailMessage.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>

<%!

// return right-most portion of a string
public String Right (String sInput, int iLength) {

	// if the number of characters requested is fewer than or equal to the number of characters in the string, return the substring
	if (iLength <= sInput.length()) {
		return sInput.substring(sInput.length()-iLength);
	}
	// otherwise return the whole string as the substring
	else {
		return sInput;
	}

}

// return left-most portion of a string
public String Left (String sInput, int iLength) {

	// if the number of characters requested is fewer than or equal to the number of characters in the string, return the substring
	if (iLength <= sInput.length()) {
		return sInput.substring(0, iLength);
	}
	// otherwise return the whole string as the substring
	else {
		return sInput;
	}

}

// string search-and-replace
public String Replace (String input, String regularExpression, String sub) {

	// check incoming parameters for null or blank string
	if (input == null || input.equals("")) {
		return "";
	}

	// declare variables
	int limit, interps, i;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern pattern = null;
	PatternCompiler compiler = new Perl5Compiler();
	String result;

	// initialize variables
	limit = Util.SUBSTITUTE_ALL;
	interps = Perl5Substitution.INTERPOLATE_ALL;

	try {
		pattern = compiler.compile(regularExpression);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// perform substitution
	result = Util.substitute(matcher, 
					pattern, 
					new Perl5Substitution(sub, interps), 
					input, 
					limit);

	// return result
	return result;

};

// checks user-submitted data for dangerous input
public boolean InputOK (String sInput, int iMaxLength) {

	// declare variables
	boolean tempInputOK = true;
	PatternMatcher matcher = new Perl5Matcher();
	Pattern pattern = null;
	PatternCompiler compiler = new Perl5Compiler();

	// initialize variables

	// list of illegal characters:
	//		|
	//		< (needed to filter out client-side scripting attacks)
	//		>
	String illegalInputRegExp = "[|<>]";
	try {
		pattern = compiler.compile(illegalInputRegExp);
	} catch (MalformedPatternException e){
		System.err.println("Bad pattern.");
		System.err.println(e.getMessage());
	}

	// check incoming parameters for null string (invalid data)
	if (sInput == null) {
		return false;
	}

	// check length
	if (sInput.length() > iMaxLength) {
		return false;
	}

	// check incoming parameters for blank string (this is an acceptable value)
	if (sInput.equals("")) {
		return true;
	}

	// check string contents (if found, tempInputOK set to false)
	tempInputOK = !matcher.contains(sInput, pattern);

	// return result (false means bad input was submitted)
	return tempInputOK;

}

// turn special symbols into HTML quoted strings (needed to display user input properly and set data in form fields properly)
public String HTMLize (String sInput) {

	// check incoming parameters for null or blank string
	if (sInput == null || sInput.equals("")) {
		return "";
	}

	// declare variables
	StringCharacterIterator iter = new StringCharacterIterator(sInput);
	StringBuffer sbResult = new StringBuffer(sInput.length()+100);	// StringBuffer will expand further if needed

	// loop through input string
	for (char c = iter.first(); c != CharacterIterator.DONE ; c=iter.next()) {
		if (c == '"') {
			sbResult.append("&quot;");
		}
		else if (c == '<') {
			sbResult.append("&lt;");
		}
		else if (c == '>') {
			sbResult.append("&gt;");
		}
		else if (c == '\n') {
			sbResult.append("<br>\n");
		}
		else {
			// otherwise add the letter
			sbResult.append(c);
		}
	}

	// return result
	return sbResult.toString();

};

// prepare passed input for insertion into a SQL string
public String SQLize (String sInput) {

//System.err.print ("sInput = " + sInput + "\n");

	// check incoming parameters for null or blank string
	if (sInput == null || sInput.equals("")) {
		return "";
	}

	// declare variables
	StringCharacterIterator iter = new StringCharacterIterator(sInput);
	StringBuffer sbResult = new StringBuffer(sInput.length()+100);	// StringBuffer will expand further if needed

	// loop through input string
	for (char c = iter.first(); c != CharacterIterator.DONE; c=iter.next()) {
		if (c == '\'') {
			sbResult.append("''");
		}
		else if (c == '"') {
			sbResult.append("&quot;");
		}
		else {
			sbResult.append(c);
		}
	}

	// return result
	return sbResult.toString();

}

// send an e-mail message
public void SendMailMessage (String sToName, String sToAddress, String sSubject, String sMessage) {

	try {
		com.oreilly.servlet.MailMessage msg = new com.oreilly.servlet.MailMessage("mail.excellenceawardsonline.com");
		msg.from ("eweek@excellenceawardsonline.com");
		msg.setHeader ("Reply-To","excellenceawards@ziffdavis.com");
		msg.to (sToAddress);
		msg.setSubject(sSubject);
		msg.getPrintStream().print (sMessage);
		msg.sendAndClose();
	}
	catch (Exception e) {
		// some kind of mail server error happened
		System.err.println ("==================================================");
		System.err.println ("Mail error: " + e);
		System.err.println ("Message sent to: " + sToName + " at " + sToAddress);
		System.err.println ("Subject: " + sSubject);
		System.err.println ("Message: " + sMessage);
		e.printStackTrace(System.err);
	}
	
}

%>
