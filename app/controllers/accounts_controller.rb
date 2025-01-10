class AccountsController < ApplicationController
  def index
    account_id = current_user.account.id
    @all_transactions = Transaction.account(account_id).load_async
    @categories = Category.with_attached_icon.account(account_id).load_async
    @banks = Bank.with_attached_picture.with_attached_icon.account(account_id).load_async
    @today_transactions = Transaction.account(account_id).where(date: Date.today).load_async

    @total_amount_today = 0
    @today_transactions.each do |t|
      if t.transaction_type == 0
        @total_amount_today += t.amount
      else
        @total_amount_today -= t.amount
      end
    end

    @total_balance = 0
    @banks.each do |b|
      @total_balance += b.balance
    end

    @total_income = 0
    @total_expense = 0

    @all_transactions.each do |t|
      if t.transaction_type == 0
        @total_income += t.amount
      else
        @total_expense += t.amount
      end
    end
  end
end
