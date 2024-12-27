class AccountsController < ApplicationController
  def index
    account_id = current_user.account.id
    @transactions = Transaction.account(account_id).where(date: Date.today)
    @categories = Category.account(account_id)
    @banks = Bank.account(account_id)
  end
end
