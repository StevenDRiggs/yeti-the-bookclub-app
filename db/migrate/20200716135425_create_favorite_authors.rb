class CreateFavoriteAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_authors do |t|
      t.integer :user_id
      t.integer :author_id

      t.text :notes

      t.timestamps
    end
  end
end
