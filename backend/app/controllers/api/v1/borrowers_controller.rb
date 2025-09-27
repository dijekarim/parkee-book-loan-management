class Api::V1::BorrowersController < ApplicationController
  def index
    borrowers = Borrower.search(params[:q])
    @pagy, @borrowers = pagy(borrowers)
    render json: { data: @borrowers, pagination: @pagy }
  end

  def show
    @borrower = Borrower.find(params[:id])
    render json: @borrower
  end

  def create
    @borrower = Borrower.new(borrower_params)
    if @borrower.save
      render json: @borrower, status: :created
    else
      render json: { errors: @borrower.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @borrower = Borrower.find(params[:id])
    if @borrower.update(borrower_params)
      render json: @borrower
    else
      render json: { errors: @borrower.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @borrower = Borrower.find(params[:id])
    @borrower.destroy
    head :no_content
  end

  private

  def borrower_params
    params.require(:borrower).permit(:card_number, :name, :email)
  end
end
