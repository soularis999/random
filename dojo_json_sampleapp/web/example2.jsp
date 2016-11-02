<%@ page 
   import="java.util.Iterator,
           java.util.List,
           com.esolaria.dojoex.Book,
           com.esolaria.dojoex.BookManager" %>
<%
    List books = BookManager.getBooks();
%>

<html>
<body>
<head>
<title>Example 1</title>
<script language="javascript" src="js/dojo/dojo.js"></script>
<script language="javascript">
 dojo.require("dojo.io.*");
 dojo.require("dojo.event.*");
 dojo.require("dojo.html.*");

function trMouseOver(bookId) {
 getBookInfo(bookId);
}

function trMouseOut(evt) {
 var bookDiv = document.getElementById("bookInfo");
 bookDiv.style.display = "none";
}

function getBookInfo(bookId) {
 var params = new Array();
 params['bookId'] = bookId;
 var bindArgs = {
  url: "actions/book.jsp",
  error: function(type, data, evt){alert("error");},
  mimetype: "text/json",
  content: params
 };
 var req = dojo.io.bind(bindArgs);
 dojo.event.connect(req, "load", this, "populateDiv");
}

function populateDiv(type, data, evt) {
 var bookDiv = document.getElementById("bookInfo");
 if (!data) {
  bookDiv.style.display = "none";
 } else {
  bookDiv.innerHTML = "ISBN: " + data.isbn + "<br/>Author: " + data.author;
  bookDiv.style.display = "";
 }
}
</script>


</head>


<body>
<h1>Books</h1>
<p>
Hover over book title for more information.
</p>
<table cellspacing="0" cellpadding="3" style="background-color:lavender; border: solid 1px #CCCCCC">
<% for (Iterator iter = books.iterator(); iter.hasNext();) {
Book book = (Book) iter.next(); %>

<tr onmouseover="trMouseOver(<%=book.getBookId()%>)" onmouseout="trMouseOut(<%=book.getBookId()%>)">
<td><%=book.getTitle()%></td>
</tr>
<% } %>
</table>
<div id="bookInfo" style="display:none;"></div>

</body>
</html>

