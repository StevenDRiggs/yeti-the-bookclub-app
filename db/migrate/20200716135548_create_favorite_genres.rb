class CreateFavoriteGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_genres do |t|
      t.integer :user_id
      t.integer :genre_id

      t.text :notes

      t.timestamps
    end
  end
end
