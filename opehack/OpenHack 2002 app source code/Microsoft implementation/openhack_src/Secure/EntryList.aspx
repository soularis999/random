<%@ Register TagPrefix="Custom" TagName="Message" Src="..\Controls\Displaymessage.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Page language="c#" Codebehind="EntryList.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.Entrylist" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>entrylist</title>
		<link rel="stylesheet" href="../normal.css" type="text/css">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<p><font color="red"><Custom:Message id="message" runat="server" /></font></p>
		<h3>View, Edit or Delete Entries</h3>
		<p><font color="red"><div id="divMessage" runat="server"><b>No entries submitted.</b><br>
					<br>
					Return to <a href="../default.aspx">home page</a>.</div>
			</font>
		<P></P>
		<asp:DataGrid id="dgList" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:TemplateColumn HeaderText="Company Name">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.COMPANYNAME").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn HeaderText="Product or Service Name">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.PRODUCTNAME").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn HeaderText="Version">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.VERSION").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn HeaderText="Registration Date">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.RECORDCREATIONTIMESTAMP", "{0:d}").ToString()) %>'>
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn>
					<ItemTemplate>
						<a href='entryview.aspx?hfProductId=<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
							<font size="-1">View Entry Details</font></a>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn>
					<ItemTemplate>
						<a href='entrycreateedit.aspx?hfProductId=<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
							<font size="-1">Edit Entry</font></a>
					</ItemTemplate>
				</asp:TemplateColumn>
				<asp:TemplateColumn>
					<ItemTemplate>
						<a href='entrydelete.aspx?hfProductId=<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
							<font size="-1">Delete Entry</font></a>
					</ItemTemplate>
				</asp:TemplateColumn>
			</Columns>
		</asp:DataGrid>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
