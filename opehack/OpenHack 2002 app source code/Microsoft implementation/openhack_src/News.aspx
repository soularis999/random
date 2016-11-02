<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title>news</title>
    <link rel="stylesheet" href="normal.css" type="text/css">
  </head>
  <body MS_POSITIONING="GridLayout">
	<Custom:Header id="header" runat="server"/>
	<Custom:UserBanner id="userBanner" runat="server"/>
    <table width="610" border="0">
		<tr>
			<td>
				<h2>Latest Site News</h2>
				<p>
					<b>2/26/2002</b> -- The winners of the 2001 eWEEK eXcellence Awards program have been <a href="http://www.eweek.com/article/0,3658,s=702&a=23110,00.asp">announced</a>.
				</p>
				<p>
					<b>1/03/2002</b> -- The <a href="Faq.aspx">Frequently Asked Questions</a> list has been updated.
				</p>
				<p>
					<b>1/03/2002</b> -- Site registrations are re-enabled. This is to allow people who wish to get a site account to register their e-mail addresses for alerts about next year's awards program to do so.
				</p>
				<p>
					<b>early morning 12/22/2001</b> -- The 2001 eWEEK eXcellence Awards program is closed to new entries. Thank you for your submissions! The judging process has started and will continue until February 2002.
				</p>
				<p>
					<b>12/14/2001</b> -- To allow a little more time for entries, the deadline for awards submissions has been extended to <strong>midnight Eastern time on Friday, Dec. 21.</strong>
				</p>
				<p>
					<b>12/14/2001</b> -- Site problem for those using Internet Explorer 5.0 on Macintosh computers<br>
					<br>
					We have confirmed a site problem for users running Internet Explorer 5.0 on Macintosh computers. These users will be able to create an account but when they try to register a company, the link just redisplays the home page and they find they have been logged out.<br>
					<br>
					If you are having this problem, send an e-mail message to <a href="mailto:timothy_dyck@ziffdavis.com">timothy_dyck@ziffdavis.com</a> and we will enter your information for you. Please include the address and phone number of the company being registered, payment information, and the information needed on the entry form. All e-mail messages must be sent by the normal site deadline to be accepted.<br>
					<br>
					The following Macintosh configurations have been tested by us and confirmed to work correctly, so if you can switch browsers or switch computers and submit the information yourself, that is a faster option.<br>
					<br>
					Netscape 4.7 on MacOS 9.1 -- <strong>works</strong><br>
					Opera beta on MacOS 9.1 -- <strong>works</strong><br>
					Internet Explorer 5.1 on MacOS 10.1 -- <strong>works</strong>
				</p>
				<p>
					<b>12/12/2001</b> -- Last year's eXcellence Awards are posted on the site. We had some requests for this information.
				</p>
				<p>
					<b>12/10/2001</b> -- The site was down from 23:30 to 23:34 to install a renewal of our digital certificate.
				</p>
				<p>
					<b>12/10/2001</b> -- The <a href="Faq.aspx">Frequently Asked Questions</a> list has been updated.
				</p>
				<p>
					<b>12/10/2001</b> -- Extra use for "customer reference" field in submission form<br>
					<br>
					One person asked us if they should be submitting information on how a customer used the submitted product or service in this field, or just the customer's contact information by itself. We had been expecting the later, but having further details is quite a good idea. So, if you would like to submit details on this customer case in this field, go ahead and do so.<br>
					<br>
					The maximum allowable length for the field has been increased from 1000 to 5000 characters to accommodate this change.<br>
					<br>
					If you already submitted your entry under the original size limits but would like to add more information, you can edit your entry using the "View, edit or delete entries" option on the site homepage.
				</p>
				<p>
					<b>12/10/2001</b> -- Fix and explanation for entry submission error message similar to "COM.ibm.db2.jdbc.DB2Exception: [IBM][CLI Driver][DB2/LINUX] SQL0433N  Value ... is too long or has invalid characters.  SQLSTATE=22001"<br>
					<br>
					If you entered more characters than allowed in the entry fields (most fields were limited to 1000 characters), then you got an error from the database. We apologize for this! The code for the site now checks if entries are too long itself, and tells you how much each entry needs to be shorted by to meet the size requirements. We have also doubled the size of the 1000 character fields to 2000 characters to allow more space should you wish to use it.<br>
					<br>
					If you already submitted your entry under the original size limits but would like to add more information, you can edit your entry using the "View, edit or delete entries" option on the site homepage.
				</p>
				<p>
					<b>12/10/2001</b> -- The database was down for about 20 minutes at 11:00 to increase the size of the rows in the entries table to allow for longer text in the entry form (see item above).
				</p>
				<p>
					<b>11/19/2001</b> -- The <a href="Faq.aspx">Frequently Asked Questions</a> list has been updated.
				</p>
				<p>
					<b>10/26/2001</b> -- The site is working well and entries are steadily arriving. We have updated the <a href="Faq.aspx">Frequently Asked Questions</a> list based on common questions we have received so far.
				</p>
				<p>
					<b>10/01/2001</b> -- The eWEEK eXcellence Awards site is open for entries.
				</p>
			</td>
		</tr>
	</table>
	<Custom:Footer id="footer" runat="server"/>
  </body>
</html>
