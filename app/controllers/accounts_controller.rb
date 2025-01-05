class AccountsController < ApplicationController
  def index
    account_id = current_user.account.id
    @transactions = Transaction.account(account_id).where(date: Date.today).load_async
    @categories = Category.with_attached_icon.account(account_id).load_async
    @banks = Bank.with_attached_picture.with_attached_icon.account(account_id).load_async

    @total_amount_today = 0
    @transactions.each do |t|
      if t.transaction_type == 0
        @total_amount_today += t.amount
      else
        @total_amount_today -= t.amount
      end
    end
  end
end
