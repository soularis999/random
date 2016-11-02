<%@ page import="java.util.Iterator,
		 java.util.List,
		 com.esolaria.dojoex.Book,
		 com.esolaria.dojoex.BookManager" %>
<%
	String bookIdStr = request.getParameter("bookId");
	int bookId = (bookIdStr == null || "".equals(bookIdStr.trim())) 
		? 0 : Integer.parseInt(bookIdStr);
	Book book = BookManager.getBook(bookId);
	if (book != null) {
		out.println(book.toJSONString());
		System.out.println("itis: " + book.toJSONString());
	}
%>
