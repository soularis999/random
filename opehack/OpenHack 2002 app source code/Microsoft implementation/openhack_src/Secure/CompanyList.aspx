<%@ Page language="c#" Codebehind="CompanyList.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.CompanyList" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>companylist</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<p><font color="red"><div id="divMessage" runat="server"><b>No companies submitted.</b><br>
					<br>
					Return to <a href="../default.aspx">home page</a>.</div>
			</font>
		<P></P>
		<asp:DataGrid id="dgList" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:TemplateColumn HeaderText="Name">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.COMPANYNAME").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn HeaderText="Number of Entries">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.NUMBEROFENTRIES").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn HeaderText="Registration Date">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.RECORDCREATIONTIMESTAMP", "{0:d}")) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn>
					<ItemTemplate>
						<a href='companycreateedit.aspx?hfCompanyId=<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
							<font size="-1">Edit company or payment details</font></a>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn>
					<ItemTemplate>
						<a href='entrycreateedit.aspx?hfCompanyId=<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
							<font size="-1">Submit a new entry for this company</font></a>
					</ItemTemplate>
				</asp:TemplateColumn>
			</Columns>
		</asp:DataGrid>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
