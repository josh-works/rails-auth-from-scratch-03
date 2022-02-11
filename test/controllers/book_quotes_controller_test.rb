require "test_helper"

class BookQuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_quote = book_quotes(:one)
  end

  test "should get index" do
    get book_quotes_url
    assert_response :success
  end

  test "should get new" do
    get new_book_quote_url
    assert_response :success
  end

  test "should create book_quote" do
    assert_difference("BookQuote.count") do
      post book_quotes_url, params: { book_quote: { book_title: @book_quote.book_title, quote: @book_quote.quote, user_id: @book_quote.user_id } }
    end

    assert_redirected_to book_quote_url(BookQuote.last)
  end

  test "should show book_quote" do
    get book_quote_url(@book_quote)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_quote_url(@book_quote)
    assert_response :success
  end

  test "should update book_quote" do
    patch book_quote_url(@book_quote), params: { book_quote: { book_title: @book_quote.book_title, quote: @book_quote.quote, user_id: @book_quote.user_id } }
    assert_redirected_to book_quote_url(@book_quote)
  end

  test "should destroy book_quote" do
    assert_difference("BookQuote.count", -1) do
      delete book_quote_url(@book_quote)
    end

    assert_redirected_to book_quotes_url
  end
end
