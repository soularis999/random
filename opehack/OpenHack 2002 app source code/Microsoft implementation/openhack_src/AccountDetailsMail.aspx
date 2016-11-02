<%@ Page language="c#" Codebehind="AccountDetailsMail.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.AccountDetailsMail" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>accountdetailsmail</title>
		<link rel="stylesheet" href="normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<TABLE height="334" cellSpacing="0" cellPadding="0" width="621" border="0" ms_2d_layout="TRUE">
			<TR vAlign="top">
				<TD width="10" height="15"></TD>
				<TD width="611"></TD>
			</TR>
			<TR vAlign="top">
				<TD height="30"></TD>
				<TD>
					<Custom:Header id="header" runat="server" />
					<Custom:UserBanner id="userBanner" runat="server"/></TD>
			</TR>
			<TR vAlign="top">
				<TD height="258"></TD>
				<TD>
					<table width="610" border="0" height="258">
						<tr>
							<td>
								<p><font color="red"><asp:Label id="lblMessage" runat="server" /></font></p>
								<h2>Mail User ID and Password</h2>
								<p>
									If you have forgotten your user ID or password, please enter your e-mail 
									address here, and we will mail those details to you.
								</p>
								<form id="accountdetailsmail" method="post" runat="server">
									<table>
										<tr>
											<td align="right">E-Mail Address:
											</td>
											<td height="44">
												<asp:textbox id="txtEmail" runat="server" maxlength="50" Width="200px"></asp:textbox>
												<span class="asterisk">*</span>
												<asp:RequiredFieldValidator id="rfvEmail" runat="server" ErrorMessage="Missing field." ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
												<asp:RegularExpressionValidator id="revEmail" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
											</td>
										</tr>
										<tr>
											<td></td>
											<td>
												<br>
												<asp:button id="btnSubmit" runat="server" Text="Email account details"></asp:button>
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
					</table>
				</TD>
			</TR>
			<TR vAlign="top">
				<TD height="31"></TD>
				<TD>
					<Custom:Footer id="footer" runat="server" /></TD>
			</TR>
		</TABLE>
	</body>
</HTML>
