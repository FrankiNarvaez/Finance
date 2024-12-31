class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ edit update destroy ]
  def index
    @transactions = Transaction.account(current_user.account.id)
    @transactions = FindTransactions.new(@transactions).call(filter_params)
  end

  def new
    @transaction = Transaction.new
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.account_id = current_user.account.id

    if transaction.save
      bank = Bank.find(transaction.bank_id)
      balance = bank.balance
      if transaction.transaction_type == 0
        balance += transaction.amount
      else
        balance -= transaction.amount
      end
      bank.update(balance: balance)
      redirect_to root_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @transaction.transaction_type != transaction_params[:transaction_type].to_i
      change_transaction_type(@transaction.bank_id, @transaction.amount, transaction_params[:transaction_type].to_i)
    end

    if @transaction.bank_id != transaction_params[:bank_id].to_i
      change_bank(@transaction.bank_id, transaction_params[:bank_id].to_i, @transaction.amount, @transaction.transaction_type)
    end

    if @transaction.amount != transaction_params[:amount].to_i
      change_amount(@transaction.bank_id, @transaction.amount, transaction_params[:amount].to_i, transaction_params[:transaction_type].to_i)
    end

    # Need refactor
    if @transaction.update(transaction_params)
      redirect_to root_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    bank = Bank.find(@transaction.bank_id)
    amount = @transaction.amount
    type = @transaction.transaction_type
    if @transaction.destroy
      if type == 0
        bank.update(balance: bank.balance - amount)
      else
        bank.update(balance: bank.balance + amount)
      end
      redirect_to root_path, status: :see_other, notice: t(".deleted")
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :transaction_type, :amount, :description, :date, :bank_id, :category_id)
  end

  def filter_params
    params.permit(:transaction_type, :bank, :category, :query_text)
  end

  def set_transaction
    @transaction ||= Transaction.find(params[:id])
  end

  def change_bank(before_bank_id, after_bank_id, amount, transaction_type)
    before_bank = Bank.find(before_bank_id)
    after_bank = Bank.find(after_bank_id)

    if transaction_type == 0
      before_bank.update(balance: before_bank.balance - amount)
      after_bank.update(balance: after_bank.balance + amount)
    else
      before_bank.update(balance: before_bank.balance + amount)
      after_bank.update(balance: after_bank.balance - amount)
    end

    @transaction.update(bank_id: after_bank_id)
  end

  def change_amount(bank_id, before_amount, new_amount, transaction_type)
    bank = Bank.find(bank_id)

    if transaction_type == 0
      bank.update(balance: bank.balance - before_amount + new_amount)
    else
      bank.update(balance: bank.balance + before_amount - new_amount)
    end

    @transaction.update(amount: new_amount)
  end

  def change_transaction_type(bank_id, amount, new_type)
    bank = Bank.find(bank_id)

    if new_type == 0
      bank.update(balance: bank.balance + 2 * amount)
    else
      bank.update(balance: bank.balance - 2 * amount)
    end

    @transaction.update(transaction_type: new_type)
  end
end
