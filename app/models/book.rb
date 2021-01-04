class Book < ApplicationRecord
  has_many :author_books
  has_many :authors, through: :author_books

  has_many :book_genres
  has_many :genres, through: :book_genres

  has_many :favorite_books
  has_many :users, through: :favorite_books

  accepts_nested_attributes_for :authors
  accepts_nested_attributes_for :genres

  validates :name, presence: true

  scope :popular, -> {
    joins(:favorite_books).group(:name).order('COUNT(books.name) DESC').order(name: :asc)
  }
end
