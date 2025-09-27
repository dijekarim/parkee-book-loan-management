# spec/controllers/api/v1/books_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all books' do
      book1 = create(:book)
      book2 = create(:book)
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |b| b['id'] }).to match_array([ book1.id, book2.id ])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      book = create(:book)
      get :show, params: { id: book.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct book' do
      book = create(:book)
      get :show, params: { id: book.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(book.id)
      expect(json_response['title']).to eq(book.title)
      expect(json_response['isbn']).to eq(book.isbn)
      expect(json_response['stock']).to eq(book.stock)
    end
  end

  describe 'POST #create' do
    it 'creates a new book' do
      book_params = attributes_for(:book)
      post :create, params: { book: book_params }
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(book_params[:title])
      expect(json_response['isbn']).to eq(book_params[:isbn])
      expect(json_response['stock']).to eq(book_params[:stock])
    end

    it 'returns an error for invalid input' do
      post :create, params: { book: { title: '', isbn: '', stock: -1 } }
      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Title can't be blank")
      expect(json_response['errors']).to include("Isbn can't be blank")
      expect(json_response['errors']).to include('Stock must be greater than or equal to 0')
    end
  end

  # Add more test cases for update and destroy actions
end
