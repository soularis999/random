<%@ Page language="c#" Codebehind="AccountCreateEdit.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.AccountCreateEdit" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Message" Src=".\Controls\Displaymessage.ascx" %>
<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>accountcreateedit</title>
		<link rel="stylesheet" href="normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610">
			<tr>
				<td><p><font color="red"><Custom:Message id="message" runat="server" /></font></p>
					<div id="divHeaderNew" align="center" runat="server">
						<h4 align="center">Step 1 of 3: Create an account</h4>
						<h4 align="center">Please enter your user information below to create a site 
							account.</h4>
					</div>
					<div id="divHeaderEdit" align="center" runat="server">
						<h4 align="center">Edit User Account Details</h4>
					</div>
					<form id="accountcreateedit" method="post" runat="server">
						<table cellSpacing="5">
							<tr>
								<td></td>
								<td>
									<p><font color="red"><asp:Label id="lblMessage" runat="server" /></font></p>
								</td>
							</tr>
							<tr vAlign="top">
								<td></td>
								<td>
									<span id="spanFormEdit" runat="server" class="instructions">(User ID cannot be 
										changed once an account is created.)</span> <span id="spanFormNew" runat="server" class="instructions">
										(maximum 10 characters)</span>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">User ID:</td>
								<td><asp:textbox id="txtUserId" runat="server" maxlength="10" Width="100"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvUserId" runat="server" ErrorMessage="Missing field." ControlToValidate="txtUserId" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revUserId" runat="server" ControlToValidate="txtUserId" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td></td>
								<td>
									<span id="spanPasswordEdit" runat="server" class="instructions">(Please change 
										password using the <A class="small" href="secure/passwordchange.aspx">Change 
											Password</A> page.)</span> <span id="spanPasswordNew" runat="server" class="instructions">
										(maximum 16 characters)</span>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Password:</td>
								<td><asp:textbox id="txtPassword" runat="server" maxlength="16" Width="100" TextMode="Password"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvPassword" runat="server" ErrorMessage="Missing field." ControlToValidate="txtPassword" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Confirm Password:</td>
								<td><asp:textbox id="txtPassword2" runat="server" maxlength="16" Width="100" TextMode="Password"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvPassword2" runat="server" ErrorMessage="Missing field." ControlToValidate="txtPassword2" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:CompareValidator id="cvPassword2" runat="server" ErrorMessage="Passwords do not match." ControlToValidate="txtPassword2" ControlToCompare="txtPassword" Display="Dynamic"></asp:CompareValidator>
								</td>
							</tr>
							<tr>
								<td colspan="2"><br>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Full Name:</td>
								<td><asp:textbox id="txtUserName" runat="server" maxlength="30" Width="200"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvUserName" runat="server" ErrorMessage="Missing field." ControlToValidate="txtUserName" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revUserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Title:</td>
								<td><asp:textbox id="txtTitle" runat="server" maxlength="50" Width="200"></asp:textbox>
									<asp:RegularExpressionValidator id="revTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Full Company Name:</td>
								<td><asp:textbox id="txtCompanyName" runat="server" maxlength="50" Width="200"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvCompanyName" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCompanyName" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCompanyName" runat="server" ErrorMessage="<br>May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCompanyName" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Phone:</td>
								<td><asp:textbox id="txtUserPhone" runat="server" maxlength="20" Width="200"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvUserPhone" runat="server" ErrorMessage="Missing field." ControlToValidate="txtUserPhone" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revUserPhone" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtUserPhone" ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: xxx-xxx-xxxx or (xxx)xxx-xxxx)</span></td>
							</tr>
							<tr vAlign="top">
								<td align="right">E-Mail Address:
								</td>
								<td><asp:textbox id="txtEmail" runat="server" maxlength="50" Width="200"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvEmail" runat="server" ErrorMessage="Missing field." ControlToValidate="txtEmail" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revEmail" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(We will send e-mail messages to this address alerting 
										you to upcoming deadlines and updating you on your entry's status.)</span></td>
							</tr>
							<tr>
								<td align="right">Send you a notification e-mail when next year's awards program 
									starts?</td>
								<td vAlign="bottom" width="70%">
									<asp:RadioButtonList id="rblContact" runat="server" Width="1px" RepeatDirection="Horizontal">
										<asp:ListItem Value="yes" Selected="True">yes</asp:ListItem>
										<asp:ListItem Value="no">no</asp:ListItem>
									</asp:RadioButtonList>
									<br>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<p><span class="asterisk">*</span> indicates a required field.</p>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<br>
									<asp:button id="btnSubmit" runat="server" Text="Submit data"></asp:button>
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
