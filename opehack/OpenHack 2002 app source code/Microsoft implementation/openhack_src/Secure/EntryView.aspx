<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ Page language="c#" Codebehind="EntryView.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.EntryView" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>entryview</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
  </HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<h3>Entry Registration Details</h3><asp:HyperLink ID="hlTopEdit" Runat="server">Edit entry details</asp:HyperLink><br>
		<a href="EntryList.aspx">Return to entry list</a><br>
		<br>
		<table width="610" cellpadding="4">
			<tr>
				<td width="30%" align="right"><b>Company Name: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblCompanyName" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>Product or Service Name: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblProductName" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>Version: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblVersion" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>Announcement Date: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblAnnouncementDate" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>Scheduled Ship Date: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblShipDate" runat="server"></asp:Label></td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>Product or Service's Web page: </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblUrl" runat="server"></asp:Label>
				</td>
			</tr>
			<tr>
				<td width="30%" align="right"><b>NDA or Embargo Required? </b>
				</td>
				<td width="70%" valign="bottom">
					<asp:Label id="lblNda" runat="server"></asp:Label></td>
			</tr>
		</table>
		<table width="610">
			<tr>
				<td>
					<br>
					<hr>
					<br>
				</td>
			</tr>
		</table>
		<table width="610">
			<tr>
				<td>
					<b>Target audience for product or service (max. 1000 characters): </b>
					<br>
					<br>
					<asp:Label id="lblTargetAudience" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Description of product or service (max. 5000 characters): </b>
					<br>
					<br>
					<asp:Label id="lblDescription" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Business problem that the product or service proposes to solve (max. 2000 
						characters): </b>
					<br>
					<br>
					<asp:Label id="lblBusinessProblem" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Please provide the names of competing products or services in your market 
						segment (max. 2000 characters): </b>
					<br>
					<br>
					<asp:Label id="lblCompetitors" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Key features that differentiate this product or service from its competition 
						(max. 5000 characters): </b>
					<br>
					<br>
					<asp:Label id="lblKeyFeatures" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 
						characters): </b>
					<br>
					<br>
					<asp:Label id="lblPrice" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
			<tr>
				<td>
					<b>Provide at least one customer reference, including contact information for 
						someone we could contact to ask about their experiences with this entry (max. 
						5000 characters): </b>
					<br>
					<br>
					<asp:Label id="lblCustomerReferences" runat="server"></asp:Label>
					<br>
					<br>
				</td>
			</tr>
		</table>
		<table width="610">
			<tr>
				<td>
					<br>
					<hr>
					<br>
				</td>
			</tr>
		</table>
		<asp:HyperLink ID="hlBottomEdit" Runat="server">Edit entry details</asp:HyperLink><br>
		<a href="EntryList.aspx">Return to entry list</a><br>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
