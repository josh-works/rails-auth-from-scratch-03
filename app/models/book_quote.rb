class BookQuote < ApplicationRecord
  belongs_to :user
  has_rich_text :quote
end
