<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Message" Src="..\Controls\DisplayMessage.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
	<head>
		<title>thankyou</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
	</head>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610" border="0">
			<tr>
				<td align="center">
					<h3>Thank You</h3>
				</td>
			</tr>
			<tr>
				<td>
					<p><Custom:Message id="message" runat="server" /></p>
					<p>We appreciate your participation in the program and we look forward to 
						evaluating this product or service.</p>
					<p>To return to the main page, click <a href="../default.aspx">here</a> or on the 
						"Home" link at the top of the page.</p>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</html>
