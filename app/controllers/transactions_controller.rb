class TransactionsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :type, :amount, :description, :date, :bank, :category)
  end

  def set_transaction
    @transaction ||= Transaction.find(params[:id])
  end
end
