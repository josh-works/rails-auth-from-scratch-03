json.extract! book_quote, :id, :quote, :book_title, :user_id, :created_at, :updated_at
json.url book_quote_url(book_quote, format: :json)
