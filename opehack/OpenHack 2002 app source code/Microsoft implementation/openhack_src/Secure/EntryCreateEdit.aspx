<%@ Page language="c#" Codebehind="EntryCreateEdit.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.EntryCreateEdit" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>entrycreateedit</title>
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
					<p><b>Note:</b> Users who do not submit a page for more than <b>12 hours</b> are 
						automatically logged out of the system. You should not leave this page open 
						without submitting data for more than this time, or your entry submission will 
						not be saved.</p>
					<h3>Create or Edit Entries</h3>
					<form id="entrycreateedit" method="post" runat="server">
						<table width="610" cellpadding="4">
							<tr>
								<td width="30%" align="right"><b>Company Name: </b>
								</td>
								<td width="70%" valign="bottom">
									<b>
										<asp:Label id="lblCompanyName" runat="server" /></b>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>Product or Service Name: </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:TextBox id="txtProductName" runat="server" MaxLength="100"></asp:TextBox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvProductName" runat="server" ErrorMessage="Missing field." ControlToValidate="txtProductName" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revProductName" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtProductName" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>Version: </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:TextBox id="txtVersion" runat="server" MaxLength="30"></asp:TextBox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvVersion" runat="server" ErrorMessage="Missing field." ControlToValidate="txtVersion" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revVersion" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtVersion" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>Announcement Date: </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:TextBox id="txtAnnouncementDate" runat="server" MaxLength="10"></asp:TextBox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvAnnouncementDate" runat="server" ErrorMessage="Missing field." ControlToValidate="txtAnnouncementDate" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revAnnouncementDate" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtAnnouncementDate" ValidationExpression="\d\d?/\d\d?/\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td width="30%"></td>
								<td width="70%">
									<span class="instructions">(format: <b>mm/dd/yyyy</b>)</span><br>
									<span class="instructions">(announcement date must be on or after <b>Jan. 1, 2001</b>
										and on or before <b>Dec. 31, 2001</b>)</span>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>Scheduled Ship Date: </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:TextBox id="txtShipDate" runat="server" MaxLength="10"></asp:TextBox>
									<span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvShipDate" runat="server" ErrorMessage="Missing field." ControlToValidate="txtShipDate" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revShipDate" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtShipDate" ValidationExpression="\d\d?/\d\d?/\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td width="30%"></td>
								<td width="70%">
									<span class="instructions">(format: <b>mm/dd/yyyy</b>)</span><br>
									<span class="instructions">(ship date must be on or before <b>Jan. 31, 2002</b>)</span>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>Product or Service's Web page: </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:textbox id="txtUrl" runat="server" MaxLength="100"></asp:textbox>
									<asp:RegularExpressionValidator id="revUrl" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtUrl" ValidationExpression="(http://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td width="30%"></td>
								<td width="70%">
									<span class="instructions">(format: http://www.yourcompany.com)</span><br>
								</td>
							</tr>
							<tr>
								<td width="30%" align="right"><b>NDA or Embargo Required? </b>
								</td>
								<td width="70%" valign="bottom">
									<asp:RadioButtonList id="rblNda" runat="server" RepeatDirection="Horizontal">
										<asp:ListItem Value="no" Selected="True">no</asp:ListItem>
										<asp:ListItem Value="yes">yes <span class="asterisk">*</span></asp:ListItem>
									</asp:RadioButtonList>
								</td>
							</tr>
							<tr>
								<td width="30%"></td>
								<td width="70%"><span class="instructions">(Note that any NDAs need to expire after a 
										product or service is publicly announced.)</span></td>
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
									Target audience for product or service (max. 2000 characters):
									<asp:RequiredFieldValidator id="rfvTargetAudience" runat="server" ErrorMessage="Missing field." ControlToValidate="txtTargetAudience" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revTargetAudience" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtTargetAudience" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtTargetAudience" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="2000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
							<tr>
								<td>
									Description of product or service (max. 5000 characters):
									<asp:RequiredFieldValidator id="rfvDescription" runat="server" ErrorMessage="Missing field." ControlToValidate="txtDescription" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revDescription" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtDescription" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtDescription" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="5000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
							<tr>
								<td>
									Business problem that the product or service proposes to solve (max. 2000 
									characters):<br>
									&nbsp;
									<asp:RequiredFieldValidator id="rfvBusinessProblem" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBusinessProblem" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBusinessProblem" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtBusinessProblem" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtBusinessProblem" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="2000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
							<tr>
								<td>
									Please provide the names of competing products or services in your market 
									segment (max. 2000 characters):
									<asp:RequiredFieldValidator id="rfvCompetitors" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCompetitors" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCompetitors" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCompetitors" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtCompetitors" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="2000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
							<tr>
								<td>
									<P>Key features that differentiate this product or service from its competition 
										(max. 5000 characters):
										<asp:RequiredFieldValidator id="rfvKeyFeatures" runat="server" ErrorMessage="Missing field." ControlToValidate="txtKeyFeatures" Display="Dynamic"></asp:RequiredFieldValidator>
										<asp:RegularExpressionValidator id="revKeyFeatures" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtKeyFeatures" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
										<br>
										&nbsp;
										<asp:TextBox id="txtKeyFeatures" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="5000"></asp:TextBox>
										<span class="asterisk">*</span>
										<br>
										<br>
									</P>
								</td>
							</tr>
							<tr>
								<td>
									Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 
									characters):<br>
									&nbsp;
									<asp:RequiredFieldValidator id="rfvPrice" runat="server" ErrorMessage="Missing field." ControlToValidate="txtPrice" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revPrice" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtPrice" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtPrice" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="2000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
							<tr>
								<td>
									Provide at least one customer reference, including contact information for 
									someone we could contact to ask about their experiences with this entry (max. 
									2000 characters):&nbsp;
									<asp:RequiredFieldValidator id="rfvCustomerReferences" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCustomerReferences" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCustomerReferences" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCustomerReferences" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
									<br>
									&nbsp;
									<asp:TextBox id="txtCustomerReferences" runat="server" TextMode="MultiLine" Width="550px" Height="150px" MaxLength="2000"></asp:TextBox>
									<span class="asterisk">*</span>
									<br>
									<br>
								</td>
							</tr>
						</table>
						<p><span class="asterisk">*</span> indicates a required field.</p>
						<p>&nbsp;
							<asp:Button id="btnSubmit" runat="server" Text="Submit data"></asp:Button>&nbsp;&nbsp;&nbsp;
							<INPUT id="hfCompanyId" type="hidden" name="hfCompanyId" runat="server"> <INPUT id="hfProductId" type="hidden" name="hfProductId" runat="server">
						</p>
					</form>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
