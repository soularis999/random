<%@ Page language="c#" Codebehind="EntryDelete.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.EntryDelete" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>entrydelete</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610">
			<tr>
				<td>
					<h3>Confirm Entry Deletion</h3>
					<table cellpadding="5">
						<tr>
							<td class="reverse">Company Name</td>
							<td class="reverse">Product or
								<br>
								Service Name</td>
							<td class="reverse">Version</td>
							<td class="reverse">Registration<br>
								Timestamp</td>
						</tr>
						<tr>
							<td><b><asp:Label ID="lblCompanyName" Runat="server" /></b></td>
							<td><b><asp:Label ID="lblProductName" Runat="server" /></b></td>
							<td><asp:Label ID="lblVersion" Runat="server" /></td>
							<td><asp:Label ID="lblRecordCreationTimeStamp" Runat="server" /></td>
						</tr>
					</table>
					<br>
					If you would like to permanently delete this entry, then click the "Delete 
					entry" button.<br>
					<br>
					If you would like to cancel this action, click the "Cancel" button to return to 
					the entry list.<br>
					<br>
					<form id="entrydelete" method="post" runat="server">
						&nbsp;
						<asp:Button id="btnDelete" runat="server" Text="Delete Entry"></asp:Button>
						<asp:Button id="btnCancel" runat="server" Text="Cancel"></asp:Button>
						<input id="hfProductId" type="hidden" runat="server">
					</form>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
