require 'securerandom'

class User < ApplicationRecord
  has_secure_password

  has_many :favorite_authors
  has_many :authors, through: :favorite_authors

  has_many :favorite_books
  has_many :books, through: :favorite_books

  has_many :favorite_genres
  has_many :genres, through: :favorite_genres

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true


  def self.find_or_create_by_auth_hash(auth_hash)
    user = self.find_by(name: auth_hash[:name], email: auth_hash[:email])
    if user.nil?
      user = self.new(name: auth_hash[:name], email: auth_hash[:email], password: SecureRandom.hex(16))
      unless user.save
        return nil
      end
    end

    user
  end

  
  def fav_authors(author)
    self.favorite_authors.where(author_id: author.id).first
  end

  def fav_books(book)
    self.favorite_books.where(book_id: book.id).first
  end
  
  def fav_genres(genre)
    self.favorite_genres.where(genre_id: genre.id).first
  end
end
