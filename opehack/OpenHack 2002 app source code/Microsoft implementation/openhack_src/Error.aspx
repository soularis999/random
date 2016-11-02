<%@ Page language="c#" AutoEventWireup="false" %>
<%@ OutputCache Duration="3600" VaryByParam="none" %>
<%@ Register TagPrefix="Custom" TagName="Header" Src=".\Controls\Header.ascx" %>
<%@ Register TagPrefix="Custom" TagName="Footer" Src=".\Controls\Footer.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
<title>error</title>
<link rel="stylesheet" href="normal.css" type="text/css">
</head>
<body MS_POSITIONING="GridLayout">
<Custom:Header id="header" runat="server" />
<h3>Ooops! The site is having a problem or you found a bug.</h3>
<p>Please contact Timothy Dyck, eWEEK at 519-746-4241 or <a href="mailto:timothy_dyck@ziffdavis.com">
timothy_dyck@ziffdavis.com</a> and report this problem.</p>
<br>
<Custom:Footer id="footer" runat="server" />
</body>
</html>
