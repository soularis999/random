<%@ Register TagPrefix="Custom" TagName="Footer" Src="..\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src="..\Controls\Header.ascx" %>
<%@ Page language="c#" Codebehind="CompanyCreateEdit.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.CompanyCreateEdit" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src="..\Controls\UserBanner.ascx" %>
<%@ OutputCache Location="None" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>companycreateedit</title>
		<LINK href="../normal.css" type="text/css" rel="stylesheet">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<META HTTP-EQUIV="Expires" CONTENT="-1" />
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<CUSTOM:HEADER id="header" runat="server"></CUSTOM:HEADER>
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610">
			<tr>
				<td>
					<div id="divPaidHeader" runat="server">
						<h4 align="center">Edit Existing Company and/or Entry Fee Payment Details</h4>
						<p align="center">Please edit company and/or entry fee payment details.</p>
					</div>
					<div id="divNotPaidHeader" runat="server">
						<h4 align="center">Step 2 of 3: Register a company</h4>
					</div>
					<div id="divNotPaidHeaderNoCompany" runat="server">
						<p align="center">You have not registered any companies into the eXcellence Awards 
							program yet. Please enter company and associated company entry fee payment 
							details.</p>
						<p align="center">Note if you are at a public relations firm, do not enter the 
							details of <i>your</i> firm; enter the details of the company <i>creating</i> the 
							products or services you will enter in step 3 and we will then judge.</p>
					</div>
					<div id="divNotPaidHeaderWithCompany" runat="server">
						<p align="center">You should only register multiple companies with one account if 
							you intend to submit multiple entries created by different vendors. If you are 
							the public relations representative for several different clients, you are in 
							this situation. You will need to pay the entry fee once for each company you 
							register.</p>
						<p align="center">Note if you are at a public relations firm, do not enter the 
							details of <i>your</i> firm; enter the details of the company <i>creating</i> the 
							products or services you will enter in step 3 and we will then judge.</p>
					</div>
					<form id="companycreateedit" method="post" runat="server">
						<table>
							<tr vAlign="top">
								<td align="right">Full Company Name:</td>
								<td>&nbsp;
									<asp:textbox id="txtCompanyName" runat="server" MaxLength="100"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvCompanyName" runat="server" ControlToValidate="txtCompanyName" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revCompanyName" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCompanyName" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Address line 1:</td>
								<td>&nbsp;
									<asp:textbox id="txtAddress1" runat="server" MaxLength="50"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvAddress1" runat="server" ControlToValidate="txtAddress1" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revAddress1" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtAddress1" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Address line 2:</td>
								<td>&nbsp;
									<asp:textbox id="txtAddress2" runat="server" MaxLength="50"></asp:textbox>&nbsp;&nbsp;
									<asp:RegularExpressionValidator id="revAddress2" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtAddress2" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr vAlign="top">
								<td align="right">City:</td>
								<td>&nbsp;
									<asp:textbox id="txtCity" runat="server" MaxLength="30"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvCity" runat="server" ControlToValidate="txtCity" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revCity" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCity" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr vAlign="top">
								<td align="right">State/Province:</td>
								<td>&nbsp;
									<asp:dropdownlist id="ddlState" runat="server" DataTextField="LONGNAME" DataValueField="SHORTNAME"></asp:dropdownlist><span class="asterisk">*</span>
									<asp:RegularExpressionValidator id="revState" runat="server" ErrorMessage="RegularExpressionValidator" ControlToValidate="ddlState" ValidationExpression="^\w{2}$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Zip/Postal Code:</td>
								<td>&nbsp;
									<asp:textbox id="txtZip" runat="server" Width="76px" MaxLength="5"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvZip" runat="server" ControlToValidate="txtZip" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revZip" runat="server" ErrorMessage="May only contain numbers." ControlToValidate="txtZip" ValidationExpression="^\d{5}$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Country:</td>
								<td>&nbsp;
									<asp:textbox id="txtCountry" runat="server" MaxLength="30"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvCountry" runat="server" ControlToValidate="txtCountry" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revCountry" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtCountry" ValidationExpression="[ ',\.0-9a-zA-Z_]*" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Company Phone:</td>
								<td>&nbsp;
									<asp:textbox id="txtPhone" runat="server" MaxLength="20"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revPhone" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtPhone" Display="Dynamic" ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: xxx-xxx-xxxx or (xxx)xxx-xxxx)</span></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Company Fax:</td>
								<td>&nbsp;
									<asp:textbox id="txtFax" runat="server" MaxLength="20"></asp:textbox>&nbsp;&nbsp;
									<asp:RegularExpressionValidator id="revFax" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtFax" ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: xxx-xxx-xxxx or (xxx)xxx-xxxx)</span></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Company Web Site:</td>
								<td>&nbsp;
									<asp:textbox id="txtUrl" runat="server" MaxLength="100"></asp:textbox><span class="asterisk">*</span>
									<asp:requiredfieldvalidator id="rfvUrl" runat="server" ControlToValidate="txtUrl" ErrorMessage="Missing field." Display="Dynamic"></asp:requiredfieldvalidator>&nbsp;
									<asp:RegularExpressionValidator id="revUrl" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtUrl" ValidationExpression="(http://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?" Display="Dynamic"></asp:RegularExpressionValidator></td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: http://www.yourcompany.com)</span></td>
							</tr>
						</table>
						<h4 align="center">Please enter or edit your payment information below.</h4>
						<p>A $100.00 non-tax deductible entry fee per company is required. After program 
							expenses, proceeds will be donated to the <a href="http://www.starlight.org">Starlight 
								Children's Foundation</a> <a href="http://www.starlight.org/programs/pcpals.htm">
								PC Pal</a> program and to the <a href="http://www.yte.org">Youth Tech 
								Entrepreneurs</a> organization.</p>
						<p>Please enter credit card billing information in the boxes provided or choose to 
							pay by check.</p>
						<p>If you want to pay by check, please mail a check for $100.00 to:</p>
						<p>eWEEK<br>
							10 President's Landing<br>
							Medford, MA<br>
							02155<br>
							USA<br>
							ATTN: eXcellence Awards
						</p>
						<p>Checks should be made payable to eWEEK.</p>
						<p>We must receive your check by <b>Dec. 31, 2001</b> or your entry will invalid.</p>
						<table border="1">
							<tr>
								<td class="reverse" align="middle" colSpan="2">Pay by Credit Card</td>
								<td class="reverse" align="middle">Pay by Check</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Credit Card Brand:</td>
								<td><asp:dropdownlist id="ddlCreditCardBrand" runat="server" DataTextField="LONGNAME" DataValueField="SHORTNAME"></asp:dropdownlist><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvCreditCardBrand" runat="server" ErrorMessage="Missing field." ControlToValidate="ddlCreditCardBrand" Display="Dynamic"></asp:RequiredFieldValidator>
								</td>
								<td>
									<asp:radiobuttonlist id="rblCheckPayment" runat="server" RepeatDirection="Horizontal" AutoPostBack="True">
										<asp:ListItem Value="no" Selected="True">no</asp:ListItem>
										<asp:ListItem Value="yes">yes<span class="asterisk">*</span></asp:ListItem>
									</asp:radiobuttonlist>
								</td>
							</tr>
							<tr vAlign="top">
								<td align="right">Credit Card Number:</td>
								<td><asp:textbox id="txtCreditCard" runat="server" MaxLength="19"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvCreditCard" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCreditCard" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCreditCard" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtCreditCard" ValidationExpression="\d{4}\-?\d{4}\-?\d{4}\-?\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Credit Card Expiry Date:</td>
								<td><asp:textbox id="txtCreditCardExpiry" runat="server" Width="76px" MaxLength="7"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvCreditCardExpiry" runat="server" ErrorMessage="Missing field." ControlToValidate="txtCreditCardExpiry" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revCreditCardExpiry" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtCreditCardExpiry" ValidationExpression="\d\d?/\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: mm/yyyy)</span></td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Name on Card:</td>
								<td><asp:textbox id="txtBillingName" runat="server" MaxLength="30"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingName" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingName" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingName" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtBillingName" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing Address line 1:</td>
								<td><asp:textbox id="txtBillingAddress1" runat="server" MaxLength="30"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingAddress1" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingAddress1" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingAddress1" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtBillingAddress1" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing Address line 2:</td>
								<td><asp:textbox id="txtBillingAddress2" runat="server" MaxLength="30"></asp:textbox>
									<asp:RegularExpressionValidator id="revBillingAddress2" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtBillingAddress2" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator></td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing City:</td>
								<td><asp:textbox id="txtBillingCity" runat="server" MaxLength="30"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingCity" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingCity" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingCity" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtBillingCity" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing State/Province:</td>
								<td><asp:dropdownlist id="ddlBillingState" runat="server" DataTextField="LONGNAME" DataValueField="SHORTNAME"></asp:dropdownlist>&nbsp;
									<span class="asterisk">*</span>
									<asp:RegularExpressionValidator id="revBillingState" runat="server" ErrorMessage="Invalid format." ControlToValidate="ddlBillingState" ValidationExpression="^\w{2}$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing Zip/Postal Code:</td>
								<td><asp:textbox id="txtBillingZip" runat="server" Width="76px" MaxLength="5"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingZip" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingZip" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingZip" runat="server" ErrorMessage="May only numbers." ControlToValidate="txtBillingZip" ValidationExpression="^\d{5}$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing Country:</td>
								<td><asp:textbox id="txtBillingCountry" runat="server" MaxLength="50"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingCountry" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingCountry" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingCountry" runat="server" ErrorMessage="May only contain letters, numbers, commas, periods, and apostrophes." ControlToValidate="txtBillingCountry" ValidationExpression="^[ ',\.0-9a-zA-Z_]+$" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr vAlign="top">
								<td align="right">Billing Phone:</td>
								<td>
									<asp:textbox id="txtBillingPhone" runat="server" MaxLength="20"></asp:textbox><span class="asterisk">*</span>
									<asp:RequiredFieldValidator id="rfvBillingPhone" runat="server" ErrorMessage="Missing field." ControlToValidate="txtBillingPhone" Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="revBillingPhone" runat="server" ErrorMessage="Invalid format." ControlToValidate="txtBillingPhone" ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" Display="Dynamic"></asp:RegularExpressionValidator>
								</td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td><span class="instructions">(format: xxx-xxx-xxxx or (xxx)xxx-xxxx)</span></td>
								<td></td>
							</tr>
						</table>
						<br>
						<p><span class="asterisk">*</span> indicates a required field. <input type="hidden" id="hfCompanyId" runat="server"></p>
						<p><asp:button id="btnSubmit" runat="server" Text="Submit data"></asp:button>&nbsp;&nbsp;
						</p>
						<p><b>Your registration changes will be processed and a confirmation e-mail sent once 
								you press "Submit data". This will take a few seconds...</b></p>
					</form>
				</td>
			</tr>
		</table>
		<CUSTOM:FOOTER id="footer" runat="server"></CUSTOM:FOOTER>
	</body>
</HTML>
