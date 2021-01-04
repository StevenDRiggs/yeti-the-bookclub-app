class CreateAuthorBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :author_books do |t|
      t.integer :author_id
      t.integer :book_id

      t.timestamps
    end
  end
end
