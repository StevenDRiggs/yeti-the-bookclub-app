class Genre < ApplicationRecord
  has_many :book_genres
  has_many :books, through: :book_genres
  has_many :author_books, through: :books
  has_many :authors, through: :author_books

  has_many :favorite_genres
  has_many :users, through: :favorite_genres

  accepts_nested_attributes_for :books

  validates :name, presence: true

  scope :popular, -> {
    joins(:favorite_genres).group(:name).order('COUNT(genres.name) DESC').order(name: :asc)
  }
end
