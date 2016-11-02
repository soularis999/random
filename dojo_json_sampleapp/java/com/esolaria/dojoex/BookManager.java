package com.esolaria.dojoex;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class BookManager {


	private static List books = new ArrayList();
	static {
		books.add(new Book(1, "Crime and Punishment", "0679734503", "Fyodor Dostoevsky"));
		books.add(new Book(2, "The Collected Tales of Nikolai Gogol", "0375706151", "Nikolai Gogol"));
		books.add(new Book(3, "King Rat", "0440145465", "James Clavell"));
		books.add(new Book(4, "The Alchemist", "0062502182", "Paulo Coelho"));
		books.add(new Book(5, "A Tale of Two Cities", "0451526562", "Charles Dickens"));
	}


	public static Book getBook(int bookId) {
		Book returnValue = null;
		for (Iterator iter = books.iterator(); iter.hasNext();) {
			Book book = (Book) iter.next();
			if (book.getBookId() == bookId) {
				returnValue = book;
				break;
			}
		}
		return returnValue;
	}

	public static List getBooks() {
		return books;
	}





}