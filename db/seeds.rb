# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  AuthorBook.drop_all
  Author.drop_all
  BookGenre.drop_all
  Book.drop_all
  FavoriteAuthor.drop_all
  FavoriteBook.drop_all
  FavoriteGenre.drop_all
  Genre.drop_all
  User.drop_all
rescue NoMethodError
end

5.times do |i|
  user = User.create(name: "user#{i}", email: "user#{i}@email.com", password: "password#{i}")
  puts "created #{user}"
end

10.times do |j|
  author = Author.create(name: "author#{j}")
  puts "created #{author}"

  book = Book.create(name: "book#{j}")
  puts "created #{book}"

  genre = Genre.create(name: "genre#{j}")
  puts "created #{genre}"
end

Book.all.each do |book|
  book.authors << Author.all.sample
  book.genres << Genre.all.sample
  puts book
end

Book.all.sample(2).each do |book|
  author = Author.all.sample
  while book.authors.include?(author)
    author = Author.all.sample
  end
  book.authors << author
  puts book
end

Book.all.sample(3) do |book|
  genre = Genre.sample
  while book.genres.include?(genre) do
    genre = Genre.all.sample
  end
  book.genres << genre
  puts book
end

User.all.each do |user|
  (1..3).to_a.sample.times do
    author = Author.all.sample
    user.authors << author unless user.authors.include?(author)
    book = Book.all.sample
    user.books << book unless user.books.include?(book)
    genre = Genre.all.sample
    user.genres << genre unless user.genres.include?(genre)
  end
  puts user
end
