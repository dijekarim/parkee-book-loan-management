# spec/controllers/api/v1/loans_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::LoansController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all loans' do
      loan1 = create(:loan)
      loan2 = create(:loan)
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |l| l['id'] }).to match_array([ loan1.id, loan2.id ])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      loan = create(:loan)
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct loan' do
      loan = create(:loan)
      get :show, params: { id: loan.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(loan.id)
      expect(json_response['book_id']).to eq(loan.book_id)
      expect(json_response['borrower_id']).to eq(loan.borrower_id)
      expect(json_response['borrow_date']).to eq(loan.borrow_date.as_json)
      expect(json_response['return_date']).to eq(loan.return_date.as_json)
    end
  end

  describe 'POST #create' do
    it 'creates a new loan when book is in stock' do
      book = create(:book, stock: 5)
      borrower = create(:borrower)
      loan_params = attributes_for(:loan, book_id: book.id, borrower_id: borrower.id)
      post :create, params: { loan: loan_params }
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['book_id']).to eq(book.id)
      expect(json_response['borrower_id']).to eq(borrower.id)
      expect(json_response['borrow_date']).to be_present
      expect(json_response['return_date']).to be_present
    end

    it 'returns an error for invalid input' do
      book = create(:book, stock: 0)
      borrower = create(:borrower)
      post :create, params: { loan: { book_id: book.id, borrower_id: borrower.id, borrow_date: nil, return_date: nil } }
      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Borrow date can't be blank")
      expect(json_response['errors']).to include("Return date can't be blank")
      expect(json_response['errors']).to include('Book is out of stock')
    end
  end

  # Add more test cases for destroy action
end
