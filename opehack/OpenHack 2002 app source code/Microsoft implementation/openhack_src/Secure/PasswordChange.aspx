<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ Page language="c#" Codebehind="PasswordChange.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.PasswordChange" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>passwordchange</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
  </HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610" border="0">
			<tr>
				<td>
					<h2>Change Password</h2>
					<p>Please enter your current password and your new password twice in the fields 
						below.</p>
					<p><font color="red"><asp:Label id="lblMessage" runat="server" /></font></p>
					<form id="passwordchange" method="post" runat="server">
						<table>
							<tr valign="top">
								<td align="right">Current password:
								</td>
								<td>
									<asp:textbox id="txtCurrentPassword" runat="server" maxlength="16" Width="100" TextMode="Password"></asp:textbox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvCurrentPassword" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCurrentPassword"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCurrentPassword" runat="server" ControlToValidate="txtNewPassword1" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr valign="top">
								<td></td>
								<td>
									<span class="instructions">(maximum 16 characters)</span>
								</td>
							</tr>
							<tr valign="top">
								<td align="right">New password:
								</td>
								<td>
									<asp:textbox id="txtNewPassword1" runat="server" maxlength="16" Width="100" TextMode="Password"></asp:textbox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvNewPassword1" runat="server" ErrorMessage="Missing field." ControlToValidate="txtNewPassword1" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revNewPassword1" runat="server" ControlToValidate="txtNewPassword1" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr valign="top">
								<td align="right">Retype new password:
								</td>
								<td>
									<asp:textbox id="txtNewPassword2" runat="server" maxlength="16" Width="100" TextMode="Password"></asp:textbox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvNewPassword2" runat="server" ErrorMessage="Missing field." ControlToValidate="txtNewPassword2" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:CompareValidator id="cvNewPassword2" runat="server" ErrorMessage="CompareValidator" ControlToValidate="txtNewPassword2" ControlToCompare="txtNewPassword1" Display="Dynamic">Passwords do not match.</asp:CompareValidator>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<br><br>
									<asp:button id="btnSubmit" runat="server" Text="Change password"></asp:button>
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
