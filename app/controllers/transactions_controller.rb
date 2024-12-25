class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ edit update destroy ]
  def index
    @transactions = Transaction.account(current_user.account.id)
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
    if @transaction.update(transaction_params)
      redirect_to root_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to root_path, status: :see_other, notice: t(".deleted")
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :transaction_type, :amount, :description, :date, :bank_id, :category_id)
  end

  def set_transaction
    @transaction ||= Transaction.find(params[:id])
  end
end
