class Api::V1::BooksController < ApplicationController
  def index
    books = Book.search(params[:q])
    @pagy, @books = pagy(books)
    render json: { data: @books, pagination: @pagy }
  end

  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      render json: @book
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    head :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :isbn, :stock)
  end
end
