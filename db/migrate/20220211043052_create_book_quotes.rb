class CreateBookQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :book_quotes do |t|
      t.string :quote
      t.string :book_title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
