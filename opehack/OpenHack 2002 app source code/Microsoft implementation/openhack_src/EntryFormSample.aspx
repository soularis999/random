<%@ Page language="c#" Codebehind="EntryFormSample.aspx.cs" AutoEventWireup="false" Inherits="OpenHack.EntryFormSample" enableViewState="False"%>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>entryformsample</title>
		<link rel="stylesheet" href="normal.css" type="text/css">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<Custom:Header id="header" runat="server" />
		<Custom:UserBanner id="userBanner" runat="server"/>
		<table width="610">
			<tr>
				<td>
					<h2>This is <b>not</b> a live form.</h2>
					<p>
						This is the information you will need to have ready when you submit an entry.
					</p>
					<div id="divHeaderUserUnknown" runat="server">Please <a href="accountcreateedit.aspx">sign 
							up</a> or <a href="login.aspx">log in</a> to see the form that can record 
						your information.</div>
					<div id="divHeaderUserKnownNoPastCompany" runat="server">Please <a href="secure/companycreateedit.aspx">
							register a company</a> to move onto step 2 of the entry submission process.</div>
					<div id="divHeaderUserKnownWithPastCompany" runat="server">Please <a href="secure/entrycreateedit.aspx">
							submit a new entry</a> to see the form that can record your information.</div>
					<table width="610" cellpadding="4">
						<tr>
							<td width="30%" align="right"><b>Product or Service Name: </b>
							</td>
							<td width="70%" valign="bottom">
								<input name="productname" type="text" size="30" maxlength="100" value="(sample only -- don't use)">
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td width="30%" align="right"><b>Version: </b>
							</td>
							<td width="70%" valign="bottom">
								<input name="version" type="text" size="30" maxlength="30" value="(sample only -- don't use)">
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td width="30%" align="right"><b>Announcement Date: </b>
							</td>
							<td width="70%" valign="bottom">
								<input name="announcementdate" type="text" size="30" maxlength="30" value="(sample only -- don't use)">
								<span class="asterisk">*</span><br>
							</td>
						</tr>
						<tr>
							<td width="30%"></td>
							<td width="70%">
								<span class="instructions">(format: <b>mm/dd/yyyy</b> or spell the month out)</span><br>
								<span class="instructions">(announcement date must be on or after <b>Jan. 1, 2001</b>
									and on or before <b>Dec. 31, 2001</b>)</span>
							</td>
						</tr>
						<tr>
							<td width="30%" align="right"><b>Scheduled Ship Date: </b>
							</td>
							<td width="70%" valign="bottom">
								<input name="shipdate" type="text" size="30" maxlength="30" value="(sample only -- don't use)">
								<span class="asterisk">*</span><br>
							</td>
						</tr>
						<tr>
							<td width="30%"></td>
							<td width="70%">
								<span class="instructions">(format: <b>mm/dd/yyyy</b> or spell the month out)</span><br>
								<span class="instructions">(ship date must be on or before <b>Jan. 31, 2002</b>)</span>
							</td>
						</tr>
						<tr>
							<td width="30%" align="right"><b>Product or Service's Web page: </b>
							</td>
							<td width="70%" valign="bottom">
								<input name="url" type="text" size="30" maxlength="100" value="(sample only -- don't use)">
							</td>
						</tr>
						<tr>
							<td width="30%" align="right"><b>NDA or Embargo Required? </b>
							</td>
							<td width="70%" valign="bottom">
								<input type="radio" value="no" name="nda" CHECKED>no <input type="radio" value="yes" name="nda">yes
								<span class="asterisk">*</span><br>
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
								Target audience for product or service (max. 2000 characters):<br>
								<textarea name="targetaudience" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
								<br>
							</td>
						</tr>
						<tr>
							<td>
								Description of product or service (max. 5000 characters):<br>
								<textarea name="description" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
								<br>
							</td>
						</tr>
						<tr>
							<td>
								Business problem that the product or service proposes to solve (max. 2000 
								characters):<br>
								<textarea name="businessproblem" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
								<br>
							</td>
						</tr>
						<tr>
							<td>
								Please provide the names of competing products or services in your market 
								segment (max. 2000 characters):<br>
								<textarea name="competitors" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
								<br>
							</td>
						</tr>
						<tr>
							<td>
								Key features that differentiate this product or service from its competition 
								(max. 5000 characters):<br>
								<textarea name="keyfeatures" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td>
								Pricing (if there is a wide range, provide entry-level pricing) (max. 2000 
								characters):<br>
								<textarea name="price" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
							</td>
						</tr>
						<tr>
							<td>
								Provide at least one customer reference, including contact information for 
								someone we could contact to ask about their experiences with this entry (max. 
								5000 characters):<br>
								<textarea name="customerreferences" rows="10" cols="70">(sample only -- don't use)</textarea>
								<span class="asterisk">*</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<Custom:Footer id="footer" runat="server" />
	</body>
</HTML>
