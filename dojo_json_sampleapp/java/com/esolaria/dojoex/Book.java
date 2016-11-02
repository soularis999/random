package com.esolaria.dojoex;

import org.json.JSONObject;
import org.json.JSONException;

public class Book {

	private int bookId;
	private String title;
	private String isbn;
	private String author;


	public Book(int bookId, String title, String isbn, String author) {
		this.bookId = bookId;
		this.title = title;
		this.isbn = isbn;
		this.author = author;
	}


	public void setBookId(int bookId) {
		this.bookId = bookId;
	}
	public int getBookId() {
		return this.bookId;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	public String getTitle() {
		return this.title;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getIsbn() {
		return this.isbn;
	}

	public void setAuthor(String author) {
		this.author = author;
	}
	public String getAuthor() {
		return this.author;
	}

	public String toJSONString() throws JSONException {
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("bookId", new Integer(this.bookId));
		jsonObj.put("title", this.title);
		jsonObj.put("isbn", this.isbn);
		jsonObj.put("author", this.author);
		return jsonObj.toString();
	}

}