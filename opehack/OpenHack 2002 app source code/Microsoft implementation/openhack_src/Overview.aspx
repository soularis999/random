<%@ Page language="c#" AutoEventWireup="false" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Message" Src=".\Controls\DisplayMessage.ascx" %>
<%@ Register TagPrefix="Custom" TagName="UserBanner" Src=".\Controls\UserBanner.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title>overview</title>
    <link rel="stylesheet" href="normal.css" type="text/css">
  </head>
  <body MS_POSITIONING="GridLayout">
	<Custom:Header id="header" runat="server"/>
	<Custom:UserBanner id="userBanner" runat="server"/>
    <table width="610" border="0">
		<tr>
			<td>
				<p><font color="red"><Custom:Message id="message" runat="server" /></font></p>

				<h2>eWEEK eXcellence awards reflect new IT demands</h2>

				<p>
					The eWEEK eXcellence awards will give enterprise IT professionals their 
					most comprehensive benchmark for assessing products and services that 
					enhance e-business performance.
				</p>

				<h3>Entry process</h3>

				<p>
					Vendors are invited to enter an unlimited number of products and services 
					announced in the year 2001. eWEEK Labs analysts and eWEEK Corporate Partners 
					will apply their technical and real-world expertise to judge the products. 
					As a result, the eWEEK eXcellence Awards will direct organizations to the 
					products and services that will allow them to establish and maintain 
					enterprise leadership.
				</p>
				<p>
					Each vendor will be charged a non-tax deductible entry fee of $100.00 (no 
					matter the number of products or services entered).
				<p>

				<h3>Selection day</h3>

				<p>
					The eWEEK eXcellence program spans the gamut of IT concerns; after all 
					entries are received, the judges will place products and services into 
					categories that reflect their role in an e-business enterprise.
				</p>
				<p>
					We promise our readers a compelling list of winners when we announce the 
					2001 award recipients on Feb. 21, 2002.
				</p>

				<p>Proceed to <a href="Instructions.aspx">step-by-step</a> instructions...</p>

			</td>
		</tr>
	</table>
	<Custom:Footer id="footer" runat="server"/>
  </body>
</html>
