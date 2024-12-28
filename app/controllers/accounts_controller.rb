class AccountsController < ApplicationController
  def index
    account_id = current_user.account.id
    @transactions = Transaction.account(account_id).where(date: Date.today)
    @categories = Category.account(account_id)
    @banks = Bank.account(account_id)

    @total_amount = 0
    @transactions.each do |t|
      if t.transaction_type == 0
        @total_amount += t.amount
      else
        @total_amount -= t.amount
      end
    end
  end
end
