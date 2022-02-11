class BookQuotesController < ApplicationController
  before_action :set_book_quote, only: %i[ show edit update destroy ]

  # GET /book_quotes or /book_quotes.json
  def index
    @book_quotes = BookQuote.all.includes(:user)
  end

  # GET /book_quotes/1 or /book_quotes/1.json
  def show
  end

  # GET /book_quotes/new
  def new
    @book_quote = BookQuote.new
  end

  # GET /book_quotes/1/edit
  def edit
  end

  # POST /book_quotes or /book_quotes.json
  def create
    @book_quote = BookQuote.new(book_quote_params)

    respond_to do |format|
      if @book_quote.save
        format.html { redirect_to book_quote_url(@book_quote), notice: "Book quote was successfully created." }
        format.json { render :show, status: :created, location: @book_quote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book_quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_quotes/1 or /book_quotes/1.json
  def update
    respond_to do |format|
      if @book_quote.update(book_quote_params)
        format.html { redirect_to book_quote_url(@book_quote), notice: "Book quote was successfully updated." }
        format.json { render :show, status: :ok, location: @book_quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book_quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_quotes/1 or /book_quotes/1.json
  def destroy
    @book_quote.destroy

    respond_to do |format|
      format.html { redirect_to book_quotes_url, notice: "Book quote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_quote
      @book_quote = BookQuote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_quote_params
      params.require(:book_quote).permit(:quote, :book_title, :user_id)
    end
end
