require "./Inventory"

def main
  inventory = Inventory.new("books.json")

  loop do
    puts "Welcome to the Book Inventory"
    puts "Please select an option:"
    puts "1. List all books"
    puts "2. Add a new book"
    puts "3. Remove a book"
    puts "4. Search for books"
    puts "5. Exit"

    choice = gets.chomp

    case choice
    when "1"
      inventory.list_books
    when "2"
      print "Enter ISBN: "
      isbn = gets.chomp
      print "Enter Title: "
      title = gets.chomp
      print "Enter Author: "
      author = gets.chomp
      inventory.add_book(isbn, title, author)
    when "3"
      print "Enter a search term (ISBN,Title or Author): "
      term = gets.chomp
      inventory.search_books(term)
    when "4"
      print "Enter the ISBN of the book to remove: "
      isbn = gets.chomp
      inventory.remove_book(isbn)
    when "5"
      puts "Goodbye."
      break
    else
      puts "Invalid option. Please type a number from 1 to 5."
    end
  end
end

main
