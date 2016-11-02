<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title>instructions</title>
    <link rel="stylesheet" href="normal.css" type="text/css">
  </head>
  <body MS_POSITIONING="GridLayout">
	<Custom:Header id="header" runat="server"/>
	<Custom:UserBanner id="userBanner" runat="server"/>
    <table width="610" border="0">
		<tr>
			<td>

				<h2>eWEEK eXcellence Awards Program Step-by-Step Instructions</h2>

				<p>All entries must be submitted by <b>23:59 Eastern Standard Time on Monday, Dec. 17, 2001.</b></p>

				<p><b>STEP 1: </b>Create a site account and read entry rules to ensure product or service qualification.</p>
				<p><b>STEP 2: </b>Register a company that is creating the product or service to be judged and pay $100.00 entry fee (one fee per vendor allows unlimited award program entries for that vendor).</p>
				<p><b>STEP 3: </b>Complete and submit an entry form for each product or service entered.</p>

				<a href="Rules.aspx"><b>Proceed to eWEEK eXcellence Awards Program entry rules and eligibility</b></a>

			</td>
		</tr>
	</table>
	<Custom:Footer id="footer" runat="server"/>
  </body>
</html>
