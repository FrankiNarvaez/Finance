class Account < ApplicationRecord
  after_save :create_bank

  belongs_to :user
  has_many :banks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  def create_bank
    Bank.create(name: "My money", balance: 0, account_id: id)
  end
end
