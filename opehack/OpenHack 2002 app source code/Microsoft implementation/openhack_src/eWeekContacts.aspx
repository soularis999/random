<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title>eweekcontacts</title>
    <link rel="stylesheet" href="normal.css" type="text/css">
  </head>
  <body MS_POSITIONING="GridLayout">
	<Custom:Header id="header" runat="server"/>
	<Custom:UserBanner id="userBanner" runat="server"/>
    <table width="610" border="0">
		<tr>
			<td>
				<h3>eWEEK eXcellence Awards Program Contacts</h3>

				<p>For any program questions, please call eWEEK at 1-800-451-1032, ext. 3854 or e-mail us at <a href="mailto:excellenceawards@ziffdavis.com">excellenceawards@ziffdavis.com</a>.</p>
				<p>To report any technical problems <em>only,</em> please call Timothy Dyck, eWEEK Labs, at 519-746-4241 or e-mail <a href="mailto:timothy_dyck@ziffdavis.com">timothy_dyck@ziffdavis.com</a>.</p>
			</td>
		</tr>
	</table>
	<Custom:Footer id="footer" runat="server"/>
  </body>
</html>
