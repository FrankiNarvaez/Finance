class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.account_id = current_user.account.id

    if @transaction.save
      redirect_to root_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :transaction_type, :amount, :description, :date, :bank_id, :category_id)
  end

  def set_transaction
    @transaction ||= Transaction.find(params[:id])
  end
end
