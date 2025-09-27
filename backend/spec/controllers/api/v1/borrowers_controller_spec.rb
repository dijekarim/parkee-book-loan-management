# spec/controllers/api/v1/borrowers_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::BorrowersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all borrowers' do
      borrower1 = create(:borrower)
      borrower2 = create(:borrower)
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |b| b['id'] }).to match_array([ borrower1.id, borrower2.id ])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      borrower = create(:borrower)
      get :show, params: { id: borrower.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct borrower' do
      borrower = create(:borrower)
      get :show, params: { id: borrower.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(borrower.id)
      expect(json_response['name']).to eq(borrower.name)
      expect(json_response['email']).to eq(borrower.email)
    end
  end

  describe 'POST #create' do
    it 'creates a new borrower' do
      borrower_params = attributes_for(:borrower)
      post :create, params: { borrower: borrower_params }
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(borrower_params[:name])
      expect(json_response['email']).to eq(borrower_params[:email])
    end

    it 'returns an error for invalid input' do
      post :create, params: { borrower: { name: '', email: '' } }
      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Name can't be blank")
      expect(json_response['errors']).to include("Email can't be blank")
    end
  end

  # Add more test cases for update and destroy actions
end
