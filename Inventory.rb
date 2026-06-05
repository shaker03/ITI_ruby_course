require "json"

class Book
  attr_accessor :isbn, :title, :author, :count

  def initialize(isbn, title, author, count = 1)
    @isbn = isbn
    @title = title
    @author = author
    @count = count
  end

  def to_hash
    {
      "title" => @title,
      "author" => @author,
      "isbn" => @isbn,
      "count" => @count,
    }
  end

  def to_s
    "(isbn: #{@isbn}) #{@title} by #{@author} "
  end
end

class Inventory
  def initialize(filename)
    @filename = filename
    @books = []
    #to load the book from file when the inventory is initialized
    load_books_from_file
  end

  #fn to add book to inventory
  def add_book(isbn, title, author)
    if title.empty? || author.empty? || isbn.empty?
      puts "Error: Input cannot be empty!"
      return
    end

    existing_book = @books.find { |book| book.isbn == isbn }
    #if the book exist add 1
    if existing_book
      existing_book.count += 1
      existing_book.title = title
      existing_book.author = author
      puts "Updated existing book, Count is now #{existing_book.count}."
    else
      new_book = Book.new(isbn, title, author)
      @books << new_book
      puts "New book with title '#{title}' added successfully!"
    end
    #to save the book to file after adding or updating
    save_books_to_file
  end

  #fn to list all books in inventory
  def list_books
    if @books.empty?
      puts "The inventory is currently empty."
      return
    end

    sorted_books = @books.sort_by { |book| book.isbn }

    puts "--- Inventory List ---"
    sorted_books.each do |book|
      puts "ISBN: #{book.isbn} | Title: #{book.title} | Author: #{book.author} | Qty: #{book.count}"
    end
    puts "----------------------"
  end

  def remove_book(isbn)
    initial_length = @books.length
    @books.reject! { |book| book.isbn == isbn }

    if @books.length < initial_length
      puts "Book removed successfully."
      save_books_to_file
    else
      puts "No book found with that ISBN."
    end
  end

  def search_books(keyword)
    title = keyword.downcase
    #search for books that match the keyword in title, author, or isbn
    results = @books.select do |book|
      book.title.downcase.include?(title) ||
        book.author.downcase.include?(title) ||
        book.isbn.downcase.include?(title)
    end

    if results.empty?
      puts "\n>> No books found matching '#{title}'."
    else
      puts "\n--- Search Results ---"
      results.each do |book|
        puts "{ISBN: #{book.isbn}, Title: '#{book.title}', Author: #{book.author}, Qty: #{book.count}}"
      end
      puts "----------------------"
    end
  end

  #internal fn to save books to file and load books from file
  private

  def save_books_to_file
    hash_array = @books.map { |book| book.to_hash }
    #to save the book to file after adding or updating
    File.write(@filename, JSON.pretty_generate(hash_array))
  end

  def load_books_from_file
    if !File.exist?(@filename)
      puts "No existing inventory file found. Starting with an empty inventory."
      return
    end

    file_data = File.read(@filename)
    parsed_data = JSON.parse(file_data)

    @books = parsed_data.map do |item|
      Book.new(item["isbn"], item["title"], item["author"], item["count"])
    end
  end
end
