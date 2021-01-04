class Author < ApplicationRecord
  has_many :author_books
  has_many :books, through: :author_books
  has_many :book_genres, through: :books
  has_many :genres, through: :book_genres

  has_many :favorite_authors
  has_many :users, through: :favorite_authors

  accepts_nested_attributes_for :books

  validates :name, presence: true

  scope :popular, -> {
    joins(:favorite_authors).group(:name).order('COUNT(authors.name) DESC').order(name: :asc)
  }
end
