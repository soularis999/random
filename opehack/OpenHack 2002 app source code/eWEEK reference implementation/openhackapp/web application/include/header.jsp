<%
// light orange: #FFB600
// dark orange: #FF9200
// dark blue: #000055
%>

<table width="610" border="0" bgcolor="#000055">
	<tr>
		<td align="center" valign="middle">
			<font size="-1">
				<a href="index.jsp" TARGET="_top">Home</A>
				<font color="FF9200">&nbsp;&#124;&nbsp;</font>
				<a href="overview.jsp" TARGET="_top">Overview</A>
				<font color="FF9200">&nbsp;&#124;&nbsp;</font>
				<a href="instructions.jsp" TARGET="_top">Instructions</A>
				<font color="FF9200">&nbsp;&#124;&nbsp;</font>
				<a href="rules.jsp" TARGET="_top">Rules</A>
				<font color="FF9200">&nbsp;&#124;&nbsp;</font>
				<a href="faq.jsp" TARGET="_top">FAQ</A>
				<font color="FF9200">&nbsp;&#124;&nbsp;</font>
				<a href="news.jsp" TARGET="_top">News</A>
			</font>
		</td>
	</tr>
</table>

<%
	if (session.getAttribute("Login Passed") != null) {
		%>
		<br>
		<table width="610">
			<tr>
				<td align="center">
					User Name: <font color="#FF9200"><b><%=session.getAttribute("Current User Name")==null ? "(not entered)" : session.getAttribute("Current User Name")%></b></font>
				</td>
				<td align="center">
					User ID: <font color="#FF9200"><b><%=session.getAttribute("Current User ID")==null ? "(not entered)" : session.getAttribute("Current User ID")%></b></font>
				</td>
			</tr>
		</table>
		<hr align="left" width="610" noshade size="3" color="#000055">
		<%
	}
%>

<br>

