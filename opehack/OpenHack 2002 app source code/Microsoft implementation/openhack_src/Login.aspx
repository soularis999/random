<%@ Page language="c#" Codebehind="Login.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.Login" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>login</title>
		<link rel="stylesheet" href="normal.css" type="text/css">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610" border="0">
			<tr>
				<td>
					<p><font color="red"><asp:Label id="lblMessage" runat="server"></asp:Label></font></p>
					<h3 align="center">Secure Login</h3>
					<div align="center">
						<form id="login" method="post" runat="server">
							<table border="0" bgcolor="#333399">
								<tr>
									<td align="right">
										<span class="logintext">User ID: </span>
										<asp:TextBox id="txtUserId" Width="100" maxlength="10" runat="server" />
										<br>
										<span class="logintext">Password: </span>
										<asp:TextBox id="txtPassword" TextMode="password" Width="100" maxlength="16" runat="server" />
									</td>
									<td valign="top">
										<asp:Button id="btnSubmit" runat="server" Text="log in"></asp:Button>
									</td>
								</tr>
							</table>
							<asp:RequiredFieldValidator id="rfvUserId" runat="server" ErrorMessage="User ID required.<br>" ControlToValidate="txtUserId"></asp:RequiredFieldValidator>
							<asp:RequiredFieldValidator id="rfvPassword" runat="server" ErrorMessage="Password required.<br>" ControlToValidate="txtPassword"></asp:RequiredFieldValidator>
							<asp:RegularExpressionValidator id="revUserId" runat="server" ErrorMessage="User ID may only contain letters, numbers, commas, and underscores.<br>" ControlToValidate="txtUserId" ValidationExpression="^[0-9a-zA-Z_]+$"></asp:RegularExpressionValidator>
							<asp:RegularExpressionValidator id="revPassword" runat="server" ErrorMessage="Password may only contain letters, numbers, commas, periods, and apostrophes.<br>" ControlToValidate="txtPassword" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$"></asp:RegularExpressionValidator>
						</form>
					</div>
					<p align="center">
						Note: User IDs are not case-sensitive. Passwords <b>are</b> case-sensitive.
					</p>
					<p align="center">
						If you have forgotten your password, we can <a href="accountdetailsmail.aspx">email</a>
						it to you.
					</p>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
