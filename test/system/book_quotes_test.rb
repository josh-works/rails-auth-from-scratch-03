require "application_system_test_case"

class BookQuotesTest < ApplicationSystemTestCase
  setup do
    @book_quote = book_quotes(:one)
  end

  test "visiting the index" do
    visit book_quotes_url
    assert_selector "h1", text: "Book quotes"
  end

  test "should create book quote" do
    visit book_quotes_url
    click_on "New book quote"

    fill_in "Book title", with: @book_quote.book_title
    fill_in "Quote", with: @book_quote.quote
    fill_in "User", with: @book_quote.user_id
    click_on "Create Book quote"

    assert_text "Book quote was successfully created"
    click_on "Back"
  end

  test "should update Book quote" do
    visit book_quote_url(@book_quote)
    click_on "Edit this book quote", match: :first

    fill_in "Book title", with: @book_quote.book_title
    fill_in "Quote", with: @book_quote.quote
    fill_in "User", with: @book_quote.user_id
    click_on "Update Book quote"

    assert_text "Book quote was successfully updated"
    click_on "Back"
  end

  test "should destroy Book quote" do
    visit book_quote_url(@book_quote)
    click_on "Destroy this book quote", match: :first

    assert_text "Book quote was successfully destroyed"
  end
end
