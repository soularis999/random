<%@ Register TagPrefix="Custom" TagName="Message" Src=".\Controls\DisplayMessage.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<%@ OutputCache Location="None" %>
<%@ Page language="c#" Codebehind="Default.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.Default" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>eWEEK eXcellence Awards (OpenHack Contest)</title>
		<link rel="stylesheet" href="normal.css" type="text/css">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610">
			<tr>
				<td>
					<p align="center"><asp:Label Font-Bold="True" ID="lblContestHeader" Runat="server"></asp:Label></p>
				</td>
			</tr>
			<tr>
				<td align="middle">
					<p><font color="red"><Custom:Message id="message" runat="server" /></font></p>
				</td>
			</tr>
		</table>
		<table width="610" cellspacing="20">
			<tr>
				<td width="70%" valign="top">
					<h2 align="center">eWEEK eXcellence Awards</h2>
					<p>
						eWEEK Openhack is an online security test. Openhack 4 is based on the actual 
						code from eWEEK's eXcellence Awards Web site.
					</p>
					<p>
						In the actual eXcellence Awards process, you are asked for credit card details 
						to cover the entry fee. For Openhack, do <b>not</b> enter a real credit card 
						number! The site will accept any number used.
					</p>
				</td>
				<td width="30%" align="middle" valign="top">
					<div align="center"><a href="default.aspx"><img src="images/EWEA2_small.jpg" width="168" height="107" alt="eWEEK eXcellence Awards logo" border="0"></a></div>
					<asp:Table width="100%" id="tblTopMenu" Runat="server">
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Text="Site News" CssClass="reverse"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Text="last updated &lt;a class=&quot;small&quot; href=&quot;news.aspx&quot;&gt;Feb. 26, 2002&lt;/a&gt;" CssClass="small"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Text="&lt;br&gt;"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Text="Your Status" CssClass="reverse"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell Text="Account:" CssClass="small"></asp:TableCell>
							<asp:TableCell Font-Bold="True" Text="Created" CssClass="small"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell Text="Entry fee:" CssClass="small"></asp:TableCell>
							<asp:TableCell Font-Bold="True" CssClass="small"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell Text="Total entries:" CssClass="small"></asp:TableCell>
							<asp:TableCell Font-Bold="True" CssClass="small"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Text="&lt;br&gt;" CssClass="small"></asp:TableCell>
						</asp:TableRow>
						<asp:TableRow>
							<asp:TableCell ColumnSpan="2" Font-Bold="True" HorizontalAlign="Center" CssClass="small"></asp:TableCell>
						</asp:TableRow>
					</asp:Table>
					<p class="small">
						<a class="small" href="entryformsample.aspx">Sample entry form</a><br>
						<br>
						<a class="small" href="http://www.eweek.com/article/0,3658,s=702&amp;a=23530,00.asp">
							See the 2001 winners of the real eWEEK eXcellence Awards</a>
					</p>
					<!-- unknown user -->
					<p class="small">
						<asp:Label ID="lblStep1" Runat="server"></asp:Label>
						<asp:HyperLink CssClass="small" id="hlCreateAccount" runat="server">
							<b>Create an account</b></asp:HyperLink>
						<asp:Label ID="lblStep1or" Runat="server"></asp:Label>
						<asp:HyperLink CssClass="small" id="hlLogin" runat="server">
							<b>Log in</b></asp:HyperLink>
					</p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlForgotPassword" runat="server"><b>Forgot 
								your user ID or password?</b></asp:HyperLink></p>
					<!-- if logged in steps -->
					<p class="small">
						<asp:Label ID="lblStep2" Runat="server"></asp:Label>
						<asp:HyperLink CssClass="small" id="hlRegisterCompany" runat="server">
							<b>Register a company</b></asp:HyperLink>
						<asp:Label ID="lblStep3" Runat="server"></asp:Label>
						<asp:HyperLink CssClass="small" id="hlAddNewEntry" runat="server">
							<b>Submit a new entry</b></asp:HyperLink>
					</p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlEditEntries" runat="server"><b>View, 
								edit or delete entries</b></asp:HyperLink></p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlViewEntries" runat="server"><b>View 
								entries</b></asp:HyperLink></p>
					<!-- if logged in default -->
					<p class="small"><asp:HyperLink CssClass="small" id="hlEditAccountDetails" runat="server"><b>Edit 
								user account details</b></asp:HyperLink></p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlEditCompany2" runat="server"><b>View 
								or edit company and/or payment details</b></asp:HyperLink></p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlAddNewCompany2" runat="server"><b>Register 
								another company</b></asp:HyperLink></p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlLogout" runat="server"><b>Log out</b></asp:HyperLink></p>
					<p class="small"><asp:HyperLink CssClass="small" id="hlChangePassword" runat="server"><b>Change 
								password</b></asp:HyperLink></p>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
