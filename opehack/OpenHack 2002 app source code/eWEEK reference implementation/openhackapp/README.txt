eWEEK Openhack 4 application
============================

Mar. 27, 2002 version

For questions, contact:
	Timothy Dyck
	eWEEK Labs West Coast Technical Director
	timothy_dyck@ziffdavis.com
	519-746-4241

Web application code is written in JavaServer Pages and run using a Java 1.3 Java virtual machine. Database scripts are for IBM DB2 7.2.

Third-party libraries used:
	Jason Hunter's com.oreilly.servlet.MailMessage class (to send e-mail)
	Apache's oro.text.regex class (for regular expressions)
	IBM DB2 JDBC driver

Security changes I would make:
	- wrap credit card processing in a stored procedure and then restrict access to the credit card table to that procedure so there is an enforced API to access or change credit card data
	- restrict such a stored procedure so only part of a credit card number that can ever be retrieved are the credit card type and the last four digits of the number
	- more checks for client-side scripting attacks (I've probably missed some as I haven't hunted for them)
	- attacks using hexadecimal- or unicode-encoded characters (not sure if these would work or not)
