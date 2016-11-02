<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="OpenHackApp" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="OpenHackApp" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title>rules</title>
    <link rel="stylesheet" href="normal.css" type="text/css">
  </head>
  <body MS_POSITIONING="GridLayout">
	<OpenHackApp:Header id="header" runat="server"/>
	<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610" border="0">
		<tr>
			<td>
				<h2>eWEEK eXcellence Awards Program Entry Rules and Eligibility</h2>

				<ul>
					<li>The product or service <b>MUST</b> have been announced in <b>calendar year 2001.</b> Products and/or services announced before Jan. 1, 2001 or after Dec. 31, 2001 are not eligible.</li>
					<li>The product or service <b>MUST</b> be released or launched to customers on or before <b>Jan. 31, 2002.</b></li>
					<li>Only online entries submitted at this site will be accepted.</li>
					<li>The <b>DEADLINE</b> for all entries is <b>23:59 Eastern Standard Time on Monday, Dec. 17, 2001.</b></li>
					<li>The $100.00 non-tax deductible entry fee per vendor <b>MUST</b> be paid in full. After program expenses, proceeds will be donated equally between the <a href="http://www.starlight.org"> Starlight Children's Foundation</a> <a href="http://www.starlight.org/programs/pcpals.htm"> PC Pal</a> program and to the <a href="http://www.yte.org">Youth Tech Entrepreneurs</a> organization.</li>
					<li>Failure to adhere to the entry rules and/or entry process will result in automatic disqualification without notification.</li>
				</ul>

				<p>NOTE: Upon submission of this product, you grant eWEEK the use of any registration, product or company information gained as a result of this process, without further permission.</p>
				<p><b>Questions? Call 1-800-451-1032, Ext. 3854 or send e-mail to <a href="mailto:excellenceawards@ziffdavis.com">excellenceawards@ziffdavis.com</a>.</b></p>
				<a href="Default.aspx"><b>Return to site homepage to start the registration process.</b></a>

			</td>
		</tr>
	</table>
	<OpenHackApp:Footer id="footer" runat="server"/>
  </body>
</html>
