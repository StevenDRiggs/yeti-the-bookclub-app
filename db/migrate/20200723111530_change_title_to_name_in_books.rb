class ChangeTitleToNameInBooks < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :title
    add_column :books, :name, :string
  end
end
